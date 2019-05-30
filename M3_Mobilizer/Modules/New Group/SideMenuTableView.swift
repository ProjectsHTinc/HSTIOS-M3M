//
//  SideMenuTableView.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 02/01/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire

class SideMenuTableView: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet var userImageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    var uploadedImage = UIImage()

    @IBOutlet var imgeOutlet: UIButton!
    
    @IBAction func imgaeButton(_ sender: Any)
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
            self.userImageView.image = editedImage
            self.userImageView.layer.cornerRadius = userImageView.bounds.width/2
            self.userImageView.layer.borderWidth = 1
            self.userImageView.layer.borderColor = UIColor.lightGray.cgColor
            self.userImageView.clipsToBounds = true
            
            webRequest_Image ()
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func webRequest_Image ()
    {
        let imgData = uploadedImage.jpegData(compressionQuality: 0.75)
        
        if imgData == nil
        {
            let alertController = UIAlertController(title: "M3", message: "successfully updated", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
                
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
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
                        if (response.result.value as? NSDictionary) != nil{
                            
                            let alertController = UIAlertController(title: "M3", message: "Sucess", preferredStyle: .alert)
                            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                print("You've pressed default");
                                
                                self.dismiss(animated: true, completion: nil)
                            }
                            alertController.addAction(action1)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        }
        
    }
    
    @IBAction func centerButton(_ sender: Any)
    {
         UserDefaults.standard.set("NO", forKey: "fromDashboard")
         self.performSegue(withIdentifier: "sidemenu_Center", sender: self)
    }
    @IBAction func tradeButton(_ sender: Any)
    {
        UserDefaults.standard.set("false", forKey: "fromCenterDetail")
        UserDefaults.standard.set("NO", forKey: "fromDashboard")
        self.performSegue(withIdentifier: "sidemenu_Trade", sender: self)
    }
    @IBAction func prospectsButton(_ sender: Any)
    {
        UserDefaults.standard.set("NO", forKey: "fromDashboard")
        self.performSegue(withIdentifier: "sidemenu_Prospects", sender: self)
    }
    @IBAction func dashboard(_ sender: Any)
    {
       // self.dismiss(animated: true, completion: nil)
    }
    @IBAction func logOut(_ sender: Any)
    {
        GlobalVariables.deviceToken = ""
        GlobalVariables.user_id = ""
        GlobalVariables.name = ""
        GlobalVariables.user_name = ""
        GlobalVariables.user_pic = ""
        GlobalVariables.user_type = ""
        GlobalVariables.user_type_name = ""
        
      
        /* staff profile */
        GlobalVariables.staff_address = ""
        GlobalVariables.staff_age = ""
        GlobalVariables.staff_community = ""
        GlobalVariables.staff_community_class = ""
        GlobalVariables.staff_email = ""
        GlobalVariables.staff_name = ""
        GlobalVariables.staff_nationality = ""
        GlobalVariables.staff_phone = ""
        GlobalVariables.staff_qualification = ""
        GlobalVariables.staff_religion = ""
        GlobalVariables.staff_role_type = ""
        GlobalVariables.staff_sex = ""
        GlobalVariables.staff_staff_id = ""

        /* center */
        GlobalVariables.center_id = ""
        
        /* student details Scaning */
        GlobalVariables.aadhaar_card_number = ""
        GlobalVariables.address = ""
        GlobalVariables.admission_date = ""
        GlobalVariables.admission_latitude = ""
        GlobalVariables.admission_location = ""
        GlobalVariables.admission_longitude = ""
        GlobalVariables.age = ""
        GlobalVariables.blood_group = ""
        GlobalVariables.city = ""
        GlobalVariables.community = ""
        GlobalVariables.community_class = ""
        GlobalVariables.created_at = ""
        GlobalVariables.created_by = ""
        GlobalVariables.disability = ""
        GlobalVariables.dob = ""
        GlobalVariables.email = ""
        GlobalVariables.enrollment = ""
        GlobalVariables.father_name = ""
        GlobalVariables.have_aadhaar_card = ""
        GlobalVariables.studentid = ""
        GlobalVariables.last_institute = ""
        GlobalVariables.last_studied = ""
        GlobalVariables.mobile = ""
        GlobalVariables.mother_name = ""
        GlobalVariables.mother_tongue = ""
        GlobalVariables.studentname = ""
        GlobalVariables.nationality = ""
        GlobalVariables.pia_id = ""
        GlobalVariables.preferred_timing = ""
        GlobalVariables.preferred_trade = ""
        GlobalVariables.qualified_promotion = ""
        GlobalVariables.religion = ""
        GlobalVariables.sec_mobile = ""
        GlobalVariables.sex = ""
        GlobalVariables.state = ""
        GlobalVariables.status = ""
        GlobalVariables.student_pic = ""
        GlobalVariables.transfer_certificate = ""
        GlobalVariables.updated_at = ""
        GlobalVariables.updated_by = ""
        GlobalVariables.pincode = ""
        
        /* user details */
        GlobalVariables.role = ""
        GlobalVariables.usersname = ""
        GlobalVariables.userssex = ""
        GlobalVariables.usersdob = ""
        GlobalVariables.usersnationality = ""
        GlobalVariables.usersreligion = ""
        GlobalVariables.userscommunity_class = ""
        GlobalVariables.userscommunity = ""
        GlobalVariables.usersaddress = ""
        GlobalVariables.usersemail = ""
        GlobalVariables.sec_email = ""
        GlobalVariables.phone = ""
        GlobalVariables.sec_phone = ""
        GlobalVariables.qualification = ""
        GlobalVariables.user_master_id = ""
        
        UserDefaults.standard.removeObject(forKey: "View")
        UserDefaults.standard.removeObject(forKey: "user_View")
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "M3_Login", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! Login
//        self.present(nextViewController, animated:true, completion:nil)
        self.performSegue(withIdentifier: "logout", sender: self)
    }
    @IBAction func taskButton(_ sender: Any)
    {
      UserDefaults.standard.set("NO", forKey: "fromDashboard")
      self.performSegue(withIdentifier: "sidemenu_Task", sender: self)
    }
    
    @IBAction func changePassword(_ sender: Any)
    {
        UserDefaults.standard.set("NO", forKey: "fromDashboard")
        self.performSegue(withIdentifier: "to_ChangePassowrd", sender: self)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        NavigationBarTitleColor.navbar_TitleColor
        
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath.row == 0)
        {
            return 191
        }
        else
        {
            return 60
        }
        
    }
    
}
