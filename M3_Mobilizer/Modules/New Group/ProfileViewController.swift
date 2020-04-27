//
//  ProfileViewController.swift
//  M3_Mobilizer
//
//  Created by Happy Sanz Tech on 12/02/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON
import SDWebImage

class ProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var uploadedImage = UIImage()
    var imagePicker = UIImagePickerController()
    var student_id = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Profile"
        NavigationBarTitleColor.navbar_TitleColor
        name.delegate = self
        phone.delegate = self
        address.delegate = self
        mail.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.loadDetails()
        imgView.sd_setImage(with: URL(string: GlobalVariables.user_pic  ?? ""), placeholderImage: UIImage(named: "profile photo.png"))

    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == name
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
        }
        else if textField == phone
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
        }
        else if textField == address
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
        }
        else if textField == mail
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == name
        {
            name.becomeFirstResponder()
        }
        else if textField == phone
        {
            address.becomeFirstResponder()
        }
        else if textField == address
        {
            mail.becomeFirstResponder()
        }
        else if textField == mail
        {
           mail.resignFirstResponder()
           self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
           self.view.endEditing(true);
        }
    }
    
    func loadDetails ()
    {
        let functionName = "apimobilizer/user_profile/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!]
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
                        let userdata = JSON?["userprofile"] as? NSDictionary
                        print(userdata as Any)
                        let address = userdata?["address"] as? String
                        let email =  userdata?["email"] as? String
                        let id = userdata?["id"] as? String
                        let name =  userdata?["name"] as? String
                        let phone = userdata?["phone"] as? String
                        let profile_pic = userdata?["profile_pic"] as? String

                        self.loadValues(name: name!, phone: phone!, address: address!, mail: email!, profileImg: profile_pic!)
                        self.student_id = id!

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
    
    func loadValues (name:String,phone:String,address:String,mail:String,profileImg:String)
    {
        self.name.text = name
        self.address.text = address
        self.mail.text = mail
        self.phone.text = phone
        
        imgView.sd_setImage(with: URL(string: profileImg), placeholderImage: UIImage(named: "profile photo.png"))
        self.imgView.layer.cornerRadius = imgView.bounds.width/2
        self.imgView.clipsToBounds = true
    }
    
    @IBAction func imgBtn(_ sender: Any)
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
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
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
        
        if  let editedImage = info[.originalImage] as? UIImage
        {
            self.imgView.image = editedImage
            self.imgView.layer.cornerRadius = imgView.bounds.width/2
            self.imgView.layer.borderWidth = 1
            self.imgView.layer.borderColor = UIColor.lightGray.cgColor
            self.imgView.clipsToBounds = true
        }
        //Dismiss the UIImagePicker after selection
        self.webRequest_Image()
        picker.dismiss(animated: true, completion: nil)
    }
        
    @IBAction func save(_ sender: Any)
    {
        if self.name.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "name cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
               // print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.phone.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "phone cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
               // print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.address.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "address cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
               // print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.mail.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "mail cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
               // print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            self.sendValuestoServer()
        }
    }
    
    func sendValuestoServer ()
    {
        let functionName = "apimobilizer/user_profile_update/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!,"address":self.address.text!,"mail":self.mail.text!]
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
                        let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                           // print("You've pressed default");
                           self.dismiss(animated: true, completion: nil)
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
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
    
    func webRequest_Image ()
    {
        
        let imgData = uploadedImage.jpegData(compressionQuality: 0.75)
           
        if imgData == nil
        {
              //self.performSegue(withIdentifier: "back_selectPage", sender: self)
        }
        else
        {
            let functionName = "apimobilizer/user_profilepic/"
            let baseUrl = Baseurl.baseUrl + functionName + GlobalVariables.user_id!
            let url = URL(string: baseUrl)!
               
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imgData!, withName: "user_pic",fileName: "file.jpg", mimeType: "image/jpg")
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
                          //    ActivityIndicator().hideActivityIndicator(uiView: self.view)
                        if (response.result.value as? NSDictionary) != nil
                        {
//                            self.performSegue(withIdentifier: "back_selectPage", sender: self)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
             }
           }
       }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
