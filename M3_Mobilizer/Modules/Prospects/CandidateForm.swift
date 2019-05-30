//
//  CandidateForm.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 12/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

class CandidateForm: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate
{
        
     var locationManager = CLLocationManager()
    
     var currentLocation: CLLocation!
    
     var hour = ""
    
     var minutes = ""
    
    // var admission_date = ""
    
     var latitudeCurrentLocation: CLLocationDegrees = 0.0
    
     var longitudeCurrentLocation: CLLocationDegrees = 0.0
    
     var uploadedImage = UIImage()

     var student_id = ""

     var touchesBegan = "0"
    
     var locationisUpdate = "YES"

     var streetName = ""
    
    var _id = [String]()
    var tradename = [String]()
    
    var trade_id = ""


    @IBAction func submitButton(_ sender: Any)
    {
            GlobalVariables.studentname = fullName.text
            GlobalVariables.sex = gender.text
            let _age = age.text
            let _religion = religion.text
            let _community = casteName.text
            let _dob = dob.text
            let _nationality = nationality.text
            let _caste = caste.text
            let _bloodgroup = bloodGroup.text
            GlobalVariables.father_name = fatherName.text
            let _motherName = motherName.text
            let _mobileNumber = mobileNumber.text
            let _seccondarymobNum = mobilenumberSecondary.text
            let _mailId = emailId.text
            let _state = state.text
            let _city = city.text
            GlobalVariables.address = addressLine1.text
            let _address2 = addressLine2.text
            let _address3 = addressLine3.text
            let _motherTonque = motherTonque.text
//            let _department = department.text
            let _graduation = graduation.text
            let _schollName = scholName.text
            let _boardName = boardName.text
            let _adharNumber = adharNumber.text
        
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            let date = Date()
            let preferred_timing = dateFormatter.string(from: date)
        
            let dateformatter4 = DateFormatter()
            dateformatter4.dateFormat = "yyyy-MM-dd hh:mm"
            let now = Date()
            let admisiondate = dateformatter4.string(from: now)
        
            print(_address2!,_address3!,self.trade_id)
            
            if (GlobalVariables.studentname!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (GlobalVariables.sex!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_age!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (Int(_age!)! < 18)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_dob!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_religion!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_community!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (GlobalVariables.father_name!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_motherName!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_bloodgroup!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_mobileNumber!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_state!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_city!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (GlobalVariables.address!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_motherTonque!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_adharNumber!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                let functionName = "apimobilizer/add_student"
                let baseUrl = Baseurl.baseUrl + functionName
                let url = URL(string: baseUrl)!
                let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "pia_id": GlobalVariables.pia_id!,"have_aadhaar_card":is_adhar, "aadhaar_card_number": _adharNumber!, "name": GlobalVariables.studentname!, "sex": GlobalVariables.sex!, "dob":_dob!, "age": _age!, "nationality": _nationality!, "religion": _religion!, "community_class": _community!, "community": _caste!, "father_name": GlobalVariables.father_name!, "mother_name": _motherName!, "mobile": _mobileNumber!, "sec_mobile": _seccondarymobNum!, "email": _mailId!, "state": _state!, "city": _city!, "address": GlobalVariables.address!   , "mother_tongue": _motherTonque!, "disability": disablity, "blood_group": _bloodgroup!, "admission_date": admisiondate, "admission_location": self.streetName, "preferred_trade": self.trade_id, "preferred_timing": preferred_timing, "last_institute": _schollName!, "last_studied": _boardName!, "qualified_promotion": _graduation!, "transfer_certificate": is_transfercert, "admission_latitude": latitudeCurrentLocation, "admission_longitude": longitudeCurrentLocation, "status": "Pending", "created_at": admisiondate,"created_by": GlobalVariables.user_id!]
                
                Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
                    {
                        response in
                        switch response.result
                        {
                        case .success:
                            print(response)
                            let JSON = response.result.value as? [String: Any]
                            let msg = JSON?["msg"] as? String
                            let status = JSON?["status"] as? String
                            if (status == "success")
                            {
                                self.student_id = String(format: "%@",JSON?["admission_id"] as! CVarArg)
                                self.webRequest_Image ()
                            }
                            else
                            {
                                let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                    print("You've pressed default");
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
    }
    func webRequest_Image ()
    {
     
        let imgData = uploadedImage.jpegData(compressionQuality: 0.75)
        
        if imgData == nil
        {
           self.performSegue(withIdentifier: "back_selectPage", sender: self)
        }
        else
        {
            let functionName = "apimobilizer/student_picupload/"
            let baseUrl = Baseurl.baseUrl + functionName + student_id
            let url = URL(string: baseUrl)!
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imgData!, withName: "student_pic",fileName: "file.jpg", mimeType: "image/jpg")
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
                            self.performSegue(withIdentifier: "back_selectPage", sender: self)

                        }
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        }
    }
    
    @IBOutlet var submitOutlet: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    var picker = UIPickerView()
    
    var datePicker = UIDatePicker()
    
    var genderPicker = [String]()

    var bloodgroupArr : NSMutableArray = NSMutableArray()
    
    var bloodgroup_id : NSMutableArray = NSMutableArray()

    var is_disablity = true
    
    var is_tc = true

    var is_adharcard = true

    var disablity = ""
    
    var is_transfercert = ""

    var is_adhar = ""
    

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var studentImage: UIImageView!
    
    @IBOutlet weak var fullName: UITextField!
    
    @IBOutlet weak var gender: UITextField!
    
    @IBOutlet weak var dob: UITextField!
    
    @IBOutlet weak var age: UITextField!
    
    @IBOutlet weak var nationality: UITextField!
    
    @IBOutlet weak var religion: UITextField!
    
    @IBOutlet weak var caste: UITextField!
    
    @IBOutlet weak var casteName: UITextField!
    
    @IBOutlet weak var bloodGroup: UITextField!
    
    @IBOutlet weak var fatherName: UITextField!
    
    @IBOutlet weak var motherName: UITextField!
    
    @IBOutlet weak var mobileNumber: UITextField!
    
    @IBOutlet weak var mobilenumberSecondary: UITextField!
    
    @IBOutlet weak var emailId: UITextField!
    
    @IBOutlet weak var state: UITextField!
    
    @IBOutlet weak var city: UITextField!
    
    @IBOutlet weak var addressLine1: UITextField!
    
    @IBOutlet weak var addressLine2: UITextField!
    
    @IBOutlet weak var addressLine3: UITextField!
    
    @IBOutlet weak var motherTonque: UITextField!
    
    @IBOutlet weak var disabilityImageView: UIImageView!
    
    @IBAction func disabilityButton(_ sender: Any)
    {
        if is_disablity == false
        {
            disabilityImageView.image = UIImage(named: "rec-01.png")
            is_disablity = true
            disablity = "1"
        }
        else
        {
            disabilityImageView.image = UIImage(named: "rec1.png")
            is_disablity = false
            disablity = "0"
        }
    }
    
    @IBOutlet weak var tcImageView: UIImageView!
    
    @IBOutlet weak var adharImageview: UIImageView!
    
    @IBOutlet weak var department: UITextField!
    
    @IBOutlet weak var graduation: UITextField!
    
    @IBOutlet weak var scholName: UITextField!
    
    @IBOutlet weak var boardName: UITextField!
    
    @IBAction func adharButton(_ sender: Any)
    {
        if is_adharcard == false
        {
            adharImageview.image = UIImage(named: "rec-01.png")
            is_adharcard = true
            is_adhar = "1"
        }
        else
        {
            adharImageview.image = UIImage(named: "rec1.png")
            is_adharcard = false
            is_adhar = "0"
        }
    }
    
    @IBAction func tcButton(_ sender: Any)
    {
        if is_tc == false
        {
            tcImageView.image = UIImage(named: "rec-01.png")
            is_tc = true
            is_transfercert = "1"
        }
        else
        {
            tcImageView.image = UIImage(named: "rec1.png")
            is_tc = false
            is_transfercert = "0"
        }
    }
    
    @IBOutlet weak var adharNumber: UITextField!
    
    @IBAction func profilrImageButton(_ sender: Any)
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
            self.studentImage.image = editedImage
            self.studentImage.layer.cornerRadius = studentImage.bounds.width/2
            self.studentImage.layer.borderWidth = 1
            self.studentImage.layer.borderColor = UIColor.lightGray.cgColor
            self.studentImage.clipsToBounds = true
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Form"
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationisUpdate = "YES"
            locationManager.startUpdatingLocation()
        }
        
        let functionName = "apimobilizer/select_bloodgroup/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!]
        
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    print(response)
                    let JSON = response.result.value as? [String: Any]
                    let msg = JSON?["msg"] as? String
                    let status = JSON?["status"] as? String
                    self.bloodgroupArr.removeAllObjects()
                    self.bloodgroup_id.removeAllObjects()
                    if (status == "success")
                    {
                            var bloodgroup = JSON?["Bloodgroup"] as? [Any]
                            
                            for i in 0..<(bloodgroup?.count ?? 0)
                            {
                                var dict = bloodgroup?[i] as? [AnyHashable : Any]
                                let blood_group_name = dict?["blood_group_name"] as? String
                                let blood_group_id = dict?["id"] as? String
                           
                                self.bloodgroupArr.add(blood_group_name!)
                                self.bloodgroup_id.add(blood_group_id!)

                            }
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    break
                case .failure(let error):
                    print(error)
                }
        }
        
        fullName.delegate = self
        gender.delegate = self
        dob.delegate = self
        age.delegate = self
        religion.delegate = self
        nationality.delegate = self
        caste.delegate = self
        casteName.delegate = self
        bloodGroup.delegate = self
        fatherName.delegate = self
        motherName.delegate = self
        mobileNumber.delegate = self
        mobilenumberSecondary.delegate = self
        emailId.delegate = self
        state.delegate = self
        city.delegate = self
        addressLine1.delegate = self
        addressLine2.delegate = self
        addressLine3.delegate = self
        motherTonque.delegate = self
        department.delegate = self
        graduation.delegate = self
        scholName.delegate = self
        boardName.delegate = self
        adharNumber.delegate = self

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        navigationLetfButton ()
        
        let _View =  UserDefaults.standard.string(forKey: "View")

        if _View == "fromadharView"
        {
            if GlobalVariables.studentname != ""
            {
                fullName.text = GlobalVariables.studentname
            }
            if GlobalVariables.sex != ""
            {
                if GlobalVariables.sex == "M"
                {
                    gender.text = "Male"
                }
                else if  GlobalVariables.sex == "F"
                {
                    gender.text = "FeMale"
                }
                else
                {
                    gender.text = "Other"
                }
            }
            if GlobalVariables.dob != ""
            {
                dob.text = GlobalVariables.dob
            }
            if GlobalVariables.aadhaar_card_number != ""
            {
                adharNumber.text = GlobalVariables.aadhaar_card_number
            }
            if GlobalVariables.father_name != ""
            {
                fatherName.text = GlobalVariables.father_name
            }
            if GlobalVariables.address != ""
            {
                addressLine1.text = GlobalVariables.address
            }
            if GlobalVariables.state != ""
            {
                state.text = GlobalVariables.state
            }
            if GlobalVariables.city != ""
            {
                city.text = GlobalVariables.city
                addressLine2.text = GlobalVariables.city
            }
            if GlobalVariables.pincode != ""
            {
                addressLine3.text = GlobalVariables.pincode
            }
        }
        else if _View == "fromaddprospectView"
        {
            
        }
        else
        {
            viewStudentsDetails ()
        }
        
        genderPicker = ["Male", "Female", "Others"]
        
        is_disablity = false

        submitOutlet.layer.cornerRadius = 4
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(ageDoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(agecancelClick))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        // add toolbar to textField
        age.inputAccessoryView = toolbar
        
        let toolbarAdhar = UIToolbar();
        toolbarAdhar.sizeToFit()
        
        //done button & cancel button
        let doneadharButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(adharDoneClick))
        let spaceadharButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let canceladharButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(adharcancelClick))
        toolbarAdhar.setItems([canceladharButton,spaceadharButton,doneadharButton], animated: false)
        
        adharNumber.inputAccessoryView = toolbarAdhar
                
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        let functionName = "apimobilizer/select_trade/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!,"pia_id":GlobalVariables.pia_id!]
        
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    print(response)
                    let JSON = response.result.value as? [String: Any]
                    let msg = JSON?["msg"] as? String
                    let status = JSON?["status"] as? String
                    if (status == "success")
                    {
                        var tradeList = JSON?["Trades"] as? [Any]
                        for i in 0..<(tradeList?.count ?? 0)
                        {
                            var dict = tradeList?[i] as? [AnyHashable : Any]
                            let trade_name = dict?["trade_name"] as? String
                            let trade_id = dict?["id"] as? String
                            
                            self.tradename.append(trade_name ?? "")
                            self._id.append(trade_id ?? "")
                        }
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
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
    
    @objc func ageDoneClick ()
    {
        religion.becomeFirstResponder()
    }
    
    @objc func agecancelClick ()
    {
        age.resignFirstResponder()
    }
    
    @objc func adharDoneClick ()
    {
        adharNumber.resignFirstResponder()
    }
    
    @objc func adharcancelClick ()
    {
        adharNumber.resignFirstResponder()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if locationisUpdate == "YES"
        {
            locationManager.stopUpdatingLocation()
            let location = locations.last! as CLLocation
            
            /* you can use these values*/
            latitudeCurrentLocation = location.coordinate.latitude
            longitudeCurrentLocation = location.coordinate.longitude
            locationisUpdate = "NO"
            locationName ()
        }
       
    }
    
    func locationName ()
    {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude:latitudeCurrentLocation, longitude:longitudeCurrentLocation)
        geoCoder.reverseGeocodeLocation(location, completionHandler:
            {
                placemarks, error -> Void in
                
                // Place details
                guard let placeMark = placemarks?.first else { return }
                
                // Location name
                if let locationName = placeMark.locality {
                    print(locationName)
                }
                // Street address
                if let street = placeMark.subLocality
                {
                    print(street)
                    self.streetName = String(format: "%@",street)
                }
                //   City
                if let city = placeMark.subAdministrativeArea {
                    print(city)
                }
                // Zip code
                if let zip = placeMark.isoCountryCode {
                    print(zip)
                }
                // Country
                if let country = placeMark.country {
                    print(country)
                }
        })
    }
    
    func navigationLetfButton ()
    {
        let navigationLetfButton = UIButton(type: .custom)
        navigationLetfButton.setImage(UIImage(named: "back-01"), for: .normal)
        navigationLetfButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navigationLetfButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        let navigationButton = UIBarButtonItem(customView: navigationLetfButton)
        self.navigationItem.setLeftBarButton(navigationButton, animated: true)
    }
    
    @objc func clickButton()
    {
        self.performSegue(withIdentifier: "back_selectPage", sender: self)
    }
    
    @objc func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        touchesBegan = "1"
        view.endEditing(true)
    }

    func viewStudentsDetails ()
    {
        let functionName = "apipia/view_student"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["student_id": GlobalVariables.studentid!]
        
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    print(response)
                    let JSON = response.result.value as? [String: Any]
                    let msg = JSON?["msg"] as? String
                    let status = JSON?["status"] as? String
                    if (status == "success")
                    {
                        var studentDetails = JSON?["studentDetails"] as? [Any]
                        
                        for i in 0..<(studentDetails?.count ?? 0)
                        {
                            var dict = studentDetails?[i] as? [AnyHashable : Any]
                            GlobalVariables.aadhaar_card_number = (dict!["aadhaar_card_number"] as! String)
                            GlobalVariables.address = (dict!["address"] as! String)
                            GlobalVariables.admission_date = (dict!["admission_date"] as! String)
                            GlobalVariables.admission_latitude = (dict!["admission_latitude"] as! String)
                            GlobalVariables.admission_location = (dict!["admission_location"] as! String)
                            GlobalVariables.admission_longitude = (dict!["admission_longitude"] as! String)
                            GlobalVariables.aadhaar_card_number = (dict!["aadhaar_card_number"] as! String)
                            GlobalVariables.age = (dict!["age"] as! String)
                            GlobalVariables.blood_group = (dict!["blood_group"] as! String)
                            GlobalVariables.city = (dict!["city"] as! String)
                            GlobalVariables.community = (dict!["community"] as! String)
                            GlobalVariables.community_class = (dict!["community_class"] as! String)
                            GlobalVariables.created_at = (dict!["created_at"] as! String)
                            GlobalVariables.created_by = (dict!["created_by"] as! String)
                            GlobalVariables.disability = (dict!["disability"] as! String)
                            GlobalVariables.dob = (dict!["dob"] as! String)
                            GlobalVariables.email = (dict!["email"] as! String)
                            GlobalVariables.enrollment = (dict!["enrollment"] as! String)
                            GlobalVariables.father_name = (dict!["father_name"] as! String)
                            GlobalVariables.have_aadhaar_card = (dict!["have_aadhaar_card"] as! String)
                            GlobalVariables.studentid = (dict!["id"] as! String)
                            GlobalVariables.last_institute = (dict!["last_institute"] as! String)
                            GlobalVariables.last_studied = (dict!["last_studied"] as! String)
                            GlobalVariables.mobile = (dict!["mobile"] as! String)
                            GlobalVariables.mother_name = (dict!["mother_name"] as! String)
                            GlobalVariables.mother_tongue = (dict!["mother_tongue"] as! String)
                            GlobalVariables.studentname = (dict!["name"] as! String)
                            GlobalVariables.nationality = (dict!["nationality"] as! String)
                            GlobalVariables.pia_id = (dict!["pia_id"] as! String)
                            GlobalVariables.preferred_timing = (dict!["preferred_timing"] as! String)
                            GlobalVariables.preferred_trade = (dict!["preferred_trade"] as! String)
                            GlobalVariables.qualified_promotion = (dict!["qualified_promotion"] as! String)
                            GlobalVariables.religion = (dict!["religion"] as! String)
                            GlobalVariables.sec_mobile = (dict!["sec_mobile"] as! String)
                            GlobalVariables.sex = (dict!["sex"] as! String)
                            GlobalVariables.state = (dict!["state"] as! String)
                            GlobalVariables.status = (dict!["status"] as! String)
                            GlobalVariables.student_pic = (dict!["student_pic"] as! String)
                            GlobalVariables.transfer_certificate = (dict!["transfer_certificate"] as! String)
                            GlobalVariables.updated_at = (dict!["updated_at"] as! String)
                            GlobalVariables.updated_by = (dict!["updated_by"] as! String)
                            
                            self.updateValues ()
                            
                        }
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
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
    
    func updateValues ()
    {
        if GlobalVariables.aadhaar_card_number != ""
        {
            self.adharNumber.text = GlobalVariables.aadhaar_card_number
        }
            
        if GlobalVariables.sex != ""
        {
            if  GlobalVariables.sex == "Male"
            {
                self.gender.text = "Male"
            }
            else if  GlobalVariables.sex == "Female"
            {
                self.gender.text = "FeMale"
            }
            else
            {
                self.gender.text = "Other"
            }
        }
            
        if GlobalVariables.age !=  ""
        {
            self.age.text = GlobalVariables.age!
        }
            
        if GlobalVariables.blood_group != ""
        {
            self.bloodGroup.text = GlobalVariables.blood_group
        }
            
        if GlobalVariables.city != ""
        {
            self.city.text = GlobalVariables.city
        }
        if GlobalVariables.community != ""
        {
            self.caste.text = GlobalVariables.community
        }
        if GlobalVariables.community_class != ""
        {
            self.casteName.text = GlobalVariables.community_class
        }
        if GlobalVariables.dob != ""
        {
            self.dob.text = GlobalVariables.dob
        }
        if GlobalVariables.email != ""
        {
            self.emailId.text = GlobalVariables.email
        }
        if GlobalVariables.father_name != ""
        {
            self.fatherName.text = GlobalVariables.father_name
        }
        if GlobalVariables.last_institute != ""
        {
            self.boardName.text = GlobalVariables.last_institute
        }
        if GlobalVariables.last_studied != ""
        {
            self.scholName.text = GlobalVariables.last_studied
        }
        if GlobalVariables.mobile != ""
        {
            self.mobileNumber.text = GlobalVariables.mobile
        }
        if GlobalVariables.mother_name != ""
        {
            self.motherName.text = GlobalVariables.mother_name
        }
        if GlobalVariables.mother_tongue != ""
        {
            self.motherTonque.text = GlobalVariables.mother_tongue
        }
        if GlobalVariables.studentname != ""
        {
            self.fullName.text = GlobalVariables.studentname
        }
        if GlobalVariables.nationality != ""
        {
            self.nationality.text = GlobalVariables.nationality
        }
        if GlobalVariables.preferred_trade != ""
        {
            self.department.text = GlobalVariables.preferred_trade
        }
        if GlobalVariables.religion != ""
        {
            self.religion.text = GlobalVariables.religion
        }
        if GlobalVariables.sec_mobile != ""
        {
            self.mobilenumberSecondary.text = GlobalVariables.sec_mobile
        }
        if GlobalVariables.state != ""
        {
            self.state.text = GlobalVariables.state
        }
        if GlobalVariables.address != ""
        {
            self.addressLine1.text = GlobalVariables.address
        }
        if GlobalVariables.qualified_promotion != ""
        {
            self.graduation.text = GlobalVariables.qualified_promotion
        }
        if GlobalVariables.disability == "1"
        {
            disabilityImageView.image = UIImage(named: "rec1.png")
            is_disablity = false
            disablity = "0"

        }
        if GlobalVariables.transfer_certificate == "1"
        {
            tcImageView.image = UIImage(named: "rec1.png")
            is_tc = false
            is_transfercert = "0"
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == fullName
        {
            gender.becomeFirstResponder()
            self.pickerforGender(self.gender)
        }
        else if textField == age
        {
            religion.becomeFirstResponder()
        }
        else if textField == religion
        {
            casteName.becomeFirstResponder()
        }
        else if textField == casteName
        {
            fatherName.becomeFirstResponder()
        }
        else if textField == fatherName
        {
            dob.becomeFirstResponder()
            self.pickStartDate(self.dob)
        }
        else if textField == nationality
        {
            caste.becomeFirstResponder()
        }
        else if textField == caste
        {
            bloodGroup.becomeFirstResponder()
            self.pickerforGender(self.bloodGroup)
        }
        else if textField == motherName
        {
            mobileNumber.becomeFirstResponder()
        }
        else if textField == mobileNumber
        {
            mobilenumberSecondary.becomeFirstResponder()
        }
        else if textField == mobilenumberSecondary
        {
            emailId.becomeFirstResponder()
        }
        else if textField == emailId
        {
            state.becomeFirstResponder()
        }
        else if textField == state
        {
            city.becomeFirstResponder()
        }
        else if textField == city
        {
            addressLine1.becomeFirstResponder()
        }
        else if textField == addressLine1
        {
            addressLine2.becomeFirstResponder()
        }
        else if textField == addressLine2
        {
            addressLine3.becomeFirstResponder()
        }
        else if textField == addressLine3
        {
            motherTonque.becomeFirstResponder()
        }
        else if textField == motherTonque
        {
            gender.tag = 0
            bloodGroup.tag = 0
            department.becomeFirstResponder()
            self.pickerforGender(self.department)
        }
        else if textField == department
        {
            
            graduation.becomeFirstResponder()
        }
        else if textField == graduation
        {
            scholName.becomeFirstResponder()
        }
        else if textField == scholName
        {
            boardName.becomeFirstResponder()
        }
        else if textField == boardName
        {
            adharNumber.becomeFirstResponder()
        }
        else if textField == adharNumber
        {
            adharNumber.resignFirstResponder()
            self.view.endEditing(true);
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == fullName
        {
            gender.tag = 1
            self.pickerforGender(self.gender)
        }
        else if textField == gender
        {
            gender.tag = 1
            self.pickerforGender(self.gender)

        }
        else if textField == bloodGroup
        {
            bloodGroup.tag = 2
            gender.tag = 0
            self.pickerforGender(self.bloodGroup)
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
        }
        else if textField == age
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
        }
        else if textField == religion
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
        }
        else if textField == casteName
        {
            bloodGroup.tag = 2
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
        }
        else if textField == fatherName
        {
            self.pickStartDate(self.dob)
        }
        else if textField == dob
        {
            self.pickStartDate(self.dob)
        }
        else if textField == nationality
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
        }
        else if textField == caste
        {
            self.pickerforGender(self.bloodGroup)
        }
        else if textField == motherName
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
        }
        else if textField == mobileNumber
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 400), animated: true)
        }
        else if textField == mobilenumberSecondary
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 400), animated: true)
        }
        else if textField == emailId
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 400), animated: true)
        }
        else if textField == state
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 400), animated: true)
        }
        else if textField == city
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 400), animated: true)
        }
        else if textField == addressLine1
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 600), animated: true)
        }
        else if textField == addressLine2
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 600), animated: true)
        }
        else if textField == addressLine3
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 600), animated: true)
        }
        else if textField == motherTonque
        {
           self.pickerforGender(self.department)
        }
        else if textField == department
        {
            gender.tag = 0
            bloodGroup.tag = 0
            self.pickerforGender(self.department)
        }
        else if textField == graduation
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 800), animated: true)
        }
        else if textField == scholName
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 800), animated: true)
        }
        else if textField == boardName
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 900), animated: true)
        }
        else if textField == adharNumber
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1000), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if touchesBegan == "0"
        {
            touchesBegan = "0"

            if textField == fullName
            {
                gender.tag = 1
                gender.becomeFirstResponder()
                self.pickerforGender(self.gender)
            }
            else if textField == gender
            {
                gender.tag = 1
                age.becomeFirstResponder()
            }
            else if textField == bloodGroup
            {
                bloodGroup.tag = 2
                motherName.becomeFirstResponder()
            }
            else if textField == age
            {
                religion.becomeFirstResponder()
            }
            else if textField == religion
            {
                casteName.becomeFirstResponder()
            }
            else if textField == casteName
            {
                fatherName.becomeFirstResponder()
                bloodGroup.tag = 2
            }
            else if textField == fatherName
            {
                dob.becomeFirstResponder()
                self.pickStartDate(self.dob)
            }
            else if textField == nationality
            {
                caste.becomeFirstResponder()
            }
            else if textField == caste
            {
                bloodGroup.becomeFirstResponder()
                self.pickerforGender(self.bloodGroup)
            }
            else if textField == motherName
            {
                mobileNumber.becomeFirstResponder()
            }
            else if textField == mobileNumber
            {
                mobilenumberSecondary.becomeFirstResponder()
            }
            else if textField == mobilenumberSecondary
            {
                emailId.becomeFirstResponder()
            }
            else if textField == emailId
            {
                state.becomeFirstResponder()
            }
            else if textField == state
            {
                city.becomeFirstResponder()
            }
            else if textField == city
            {
                addressLine1.becomeFirstResponder()
            }
            else if textField == addressLine1
            {
                addressLine2.becomeFirstResponder()
            }
            else if textField == addressLine2
            {
                addressLine3.becomeFirstResponder()
            }
            else if textField == addressLine3
            {
                gender.tag = 0
                bloodGroup.tag = 0
                motherTonque.becomeFirstResponder()
            }
            else if textField == motherTonque
            {
                gender.tag = 0
                bloodGroup.tag = 0
                department.becomeFirstResponder()
                self.pickerforGender(self.department)
            }
            else if textField == department
            {
                graduation.becomeFirstResponder()
            }
            else if textField == graduation
            {
                scholName.becomeFirstResponder()
            }
            else if textField == scholName
            {
                boardName.becomeFirstResponder()
            }
            else if textField == boardName
            {
                adharNumber.becomeFirstResponder()
            }
            else if textField == adharNumber
            {
                adharNumber.resignFirstResponder()
                self.view.endEditing(true);
            }
        }
        else
        {
            textField.resignFirstResponder()
            
            touchesBegan = "1"
        }
    }
    
    func pickStartDate(_ textField : UITextField)
    {
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = .date
        dob.inputView = self.datePicker
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(startDateDoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        // add toolbar to textField
        dob.inputAccessoryView = toolbar
        // add datepicker to textField
        dob.inputView = datePicker
    }
    
    @objc func startDateDoneClick()
    {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        dateFormatter1.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
        dob.text = dateFormatter1.string(from: datePicker.date)
        dob.resignFirstResponder()
        nationality.becomeFirstResponder()
    }
    
    @objc func cancelClick()
    {
        dob.resignFirstResponder()
        nationality.becomeFirstResponder()
    }
    
    func pickerforGender(_ textField : UITextField)
    {
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        picker.backgroundColor = .white
        
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(genderpickerdoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:  #selector(genderpickercancelClick))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        gender.inputView = picker
        gender.inputAccessoryView = toolBar
        
        bloodGroup.inputView = picker
        bloodGroup.inputAccessoryView = toolBar
        
        department.inputView = picker
        department.inputAccessoryView = toolBar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if gender.tag == 1
        {
            return genderPicker.count
        }
        else if bloodGroup.tag == 2
        {
            return bloodgroupArr.count
        }
        else
        {
            return tradename.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if gender.tag == 1
        {
             return genderPicker[row]
        }
        else if bloodGroup.tag == 2
        {
            return (bloodgroupArr[row] as! String)
        }
        else
        {
            return tradename[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if gender.tag == 1
        {
            self.gender.text = genderPicker[row]
            
        }
        else if bloodGroup.tag == 2
        {
            self.bloodGroup.text = (bloodgroupArr[row] as! String)
            
        }
        else
        {
            self.department.text = tradename[row]
            trade_id = _id[row]
            print(_id)
            print(trade_id)
        }
    }
    
    @objc func genderpickerdoneClick ()
    {
        if gender.tag == 1
        {
            let selectedIndex = picker.selectedRow(inComponent: 0)
            gender.text = genderPicker[selectedIndex]
            gender.resignFirstResponder()
            age.becomeFirstResponder()
        }
        else if bloodGroup.tag == 2
        {
            let selectedIndex = picker.selectedRow(inComponent: 0)
            bloodGroup.text = (bloodgroupArr[selectedIndex] as! String)
            bloodGroup.resignFirstResponder()
            motherName.becomeFirstResponder()
        }
        else
        {
            let selectedIndex = picker.selectedRow(inComponent: 0)
            department.text = tradename[selectedIndex]
            department.resignFirstResponder()
            graduation.becomeFirstResponder()
        }
    }
    
    @objc func genderpickercancelClick ()
    {
        if gender.tag == 1
        {
            gender.resignFirstResponder()
            age.becomeFirstResponder()
        }
        else if bloodGroup.tag == 2
        {
            bloodGroup.resignFirstResponder()
            motherName.becomeFirstResponder()
        }
        else
        {
            department.resignFirstResponder()
            graduation.becomeFirstResponder()
        }
    }
}
