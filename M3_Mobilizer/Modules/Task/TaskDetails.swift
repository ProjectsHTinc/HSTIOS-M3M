//
//  TaskDetails.swift
//  M3_Mobilizer
//
//  Created by Happy Sanz Tech on 21/01/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class TaskDetails: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var descripitionText: UITextView!
    @IBOutlet weak var taskDate: UITextField!
    @IBOutlet weak var uploadPhotoOutlet: UIButton!
    @IBOutlet weak var viewPhotoOutlet: UIButton!
    @IBOutlet weak var updateOutlet: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var taskType: UITextField!
    @IBOutlet weak var taskStatus: UITextField!
    
    var uploadedImage = UIImage()
    var imagePicker = UIImagePickerController()
    var datePicker = UIDatePicker()
    
    
    var titleText = String()
    var descripition = String()
    var date = String()
    var _taskType = String()
    var status = String()
    var taskID = String()
    var attandenceID = String()


    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Attendance Task"
        self.titleLabel.delegate = self
        self.descripitionText.delegate = self
        self.taskDate.delegate = self
        self.taskType.delegate = self
        self.taskStatus.delegate = self

        self.titleLabel.text = titleText
        self.descripitionText.text = descripition
        self.taskDate.text = date
        self.taskType.text = _taskType
        self.taskStatus.text = status

        print(titleText)
        self.navigationRightButton ()

    }
    
    func navigationRightButton ()
    {
        let navigationRightButton = UIButton(type: .custom)
        navigationRightButton.setImage(UIImage(named: "editMobilizer"), for: .normal)
        navigationRightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navigationRightButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        let navigationButton = UIBarButtonItem(customView: navigationRightButton)
        self.navigationItem.setRightBarButtonItems([navigationButton], animated: true)
    }
    
    @objc func clickButton()
    {
        self.performSegue(withIdentifier: "commentsPage", sender: self)
    }
    
    @IBAction func uploadPhoto(_ sender: Any)
    {
       let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
           alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
               self.openCamera()
           }))
           
           alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
               self.openGallary()
           }))
           
           alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
           
           //If you want work actionsheet on ipad then you have to use popoverPresentationController to present the actionsheet, otherwise app will crash in iPad
           switch UIDevice.current.userInterfaceIdiom {
           case .pad:
               alert.popoverPresentationController?.sourceView = sender as? UIView
               alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
               alert.popoverPresentationController?.permittedArrowDirections = .up
           default:
               break
           }
           
           self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
           if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
           {
               imagePicker.sourceType = UIImagePickerController.SourceType.camera
               //If you dont want to edit the photo then you can set allowsEditing to false
               imagePicker.allowsEditing = true
               imagePicker.delegate = self
               self.present(imagePicker, animated: true, completion: nil)
           }
           else
           {
               let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               self.present(alert, animated: true, completion: nil)
           }
       }
       
       //MARK: - Choose image from camera roll
       
       func openGallary(){
           imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
           //If you dont want to edit the photo then you can set allowsEditing to false
           imagePicker.allowsEditing = true
           imagePicker.delegate = self
           self.present(imagePicker, animated: true, completion: nil)
       }
       
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
           uploadedImage = (info[.originalImage] as? UIImage)!
           self.uploadTaskPictue(taskImage: uploadedImage)
           //Dismiss the UIImagePicker after selection
           picker.dismiss(animated: true, completion: nil)
       }
    
    @IBAction func viewPhoto(_ sender: Any)
    {
        self.performSegue(withIdentifier: "taskImageView", sender: self)
    }
    
    @IBAction func update(_ sender: Any)
    {
        if self.taskDate.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "title cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
               // print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.descripitionText.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "descripition cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
               // print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.taskDate.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "date cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
               // print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            self.updateButtonIsClicked(title: self.titleLabel.text!, descripition: self.descripitionText.text!, taskDate: self.taskDate.text!, task_id: self.taskID, status: self.status)
        }
    }
    
    func updateButtonIsClicked (title:String, descripition:String, taskDate:String, task_id:String, status:String)
    {
        let functionName = "apimobilizer/update_task/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "task_title":title, "task_id":task_id, "task_description":descripition, "task_date":taskDate, "status":status]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    MBProgressHUD.hide(for: self.view, animated: true)
                    print(response)
                    let JSON = response.result.value as? [String: Any]
                    let msg = JSON?["msg"] as? String
                    let status = JSON?["status"] as? String
                    if (status == "success")
                    {
                        //let taskDetails = JSON?["taskDetails"] as? [Any]
                        self.navigationController?.popViewController(animated: true)
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                           // print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    break
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func uploadTaskPictue(taskImage:UIImage)
    {
       let imgData = uploadedImage.jpegData(compressionQuality: 0.75)
       if imgData == nil
       {
           let alertController = UIAlertController(title: "M3", message: "please select the image", preferredStyle: .alert)
           let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
              // print("You've pressed default");
           }
           alertController.addAction(action1)
           self.present(alertController, animated: true, completion: nil)
       }
       else
       {
           MBProgressHUD.showAdded(to: self.view, animated: true)
           let functionName = "apimobilizer/task_picupload/"
           let baseUrl = Baseurl.baseUrl + functionName + taskID + "/"
           let url = URL(string: baseUrl)!
           
           Alamofire.upload(multipartFormData: { multipartFormData in
               multipartFormData.append(imgData!, withName: "task_pic",fileName: "file.jpg", mimeType: "image/jpg")
           },
           to:url)
           { (result) in
               switch result {
               case .success(let upload, _, _):
                   
                   upload.uploadProgress(closure: { (progress) in
                       print("Upload Progress: \(progress.fractionCompleted)")
                   })
                   
                   upload.responseJSON { response in
                   print(response.result.value as Any)
                   MBProgressHUD.hide(for: self.view, animated: true)
                   if (response.result.value as? NSDictionary) != nil
                   {
                     
                   }
                }
                   
               case .failure(let encodingError):
                   print(encodingError)
               }
           }
       }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "commentsPage")
        {
            let vc = segue.destination as! AddTask
            vc.task_id =  self.taskID
            vc.attandenceID = self.attandenceID

        }
    }
    

}
