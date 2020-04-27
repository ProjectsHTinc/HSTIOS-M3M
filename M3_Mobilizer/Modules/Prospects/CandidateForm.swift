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
import ReachabilitySwift
import SwiftyJSON
import SDWebImage
import Photos
import MBProgressHUD

class CandidateForm: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate
{
    
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
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var hour = ""
    var minutes = ""
    //  var admission_date = ""
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
    var databasePath = String()
    var gps_status = String()
    let reachability = Reachability()
    var networkConnectionFrom = String()
    var imageName = String()
    var years = [String]()
    var qualificatioArray = [String]()
    var jobCardArray = [String]()
    var lastInsertedID  = Int()
    var qualifieedPromoArray = [String]()
    var communityClass = [String]()

     
     @IBOutlet var submitOutlet: UIButton!
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
     @IBOutlet weak var disabilityImageView: UIImageView!
     
     @IBOutlet weak var degree: UITextField!
     @IBOutlet weak var yearOfEducation: UITextField!
     @IBOutlet weak var yearOfPassing: UITextField!
     @IBOutlet weak var identificationMarksOne: UITextField!
     @IBOutlet weak var identificationMarksTwo: UITextField!
     @IBOutlet weak var headOfFamily: UITextField!
     @IBOutlet weak var highestEducationQualification: UITextField!
     @IBOutlet weak var fatherMobileNumber: UITextField!
     @IBOutlet weak var motherMobileNumber: UITextField!
     @IBOutlet weak var yearlyIncome: UITextField!
     @IBOutlet weak var languageKnown: UITextField!
     @IBOutlet weak var numberOfMembersInFamily: UITextField!
     @IBOutlet weak var tcImageView: UIImageView!
     @IBOutlet weak var adharImageview: UIImageView!
     @IBOutlet weak var department: UITextField!
     @IBOutlet weak var graduation: UITextField!
     @IBOutlet weak var adharNumber: UITextField!
     @IBOutlet weak var jobCard: UITextField!
     @IBOutlet weak var motherTonque: UITextField!
     @IBOutlet weak var qualifiedPromotion: UITextField!
     @IBOutlet weak var lastStudied: UITextField!
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Form"
        //self.CreateTableForProspectData ()
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationisUpdate = "YES"
            locationManager.startUpdatingLocation()
        }
        self.bloodgroupArr = ["A+","O+","B+","AB+","A-","O-","B-","AB-"]
        self.bloodgroup_id = ["1","2","3","4","5","6","7","8"]
        self.qualifieedPromoArray = ["Pass","Fail","DropOut"]
        self.communityClass = ["SC","ST","BC","MBC","OC"]
        
        qualifiedPromotion.delegate = self
        lastStudied.delegate = self
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
        motherTonque.delegate = self
        department.delegate = self
        graduation.delegate = self
        adharNumber.delegate = self
        degree.delegate = self
        yearOfEducation.delegate = self
        yearOfPassing.delegate = self
        identificationMarksOne.delegate = self
        identificationMarksTwo.delegate = self
        headOfFamily.delegate = self
        highestEducationQualification.delegate = self
        fatherMobileNumber.delegate = self
        motherMobileNumber.delegate = self
        yearlyIncome.delegate = self
        languageKnown.delegate = self
        numberOfMembersInFamily.delegate = self
        jobCard.delegate = self
        
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
               // addressLine3.text = GlobalVariables.pincode
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
        if UserDefaults.standard.object(forKey: "tradenamesKey") != nil && UserDefaults.standard.object(forKey: "tradeIDKey") != nil
        {
            self.tradename = UserDefaults.standard.object(forKey: "tradenamesKey") as! [String]
            self._id = UserDefaults.standard.object(forKey: "tradeIDKey") as! [String]
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: ReachabilityChangedNotification,
                                               object: reachability)
        do{
            try reachability!.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
        
        self.yearsForPickerView()
        self.qualificatioArray = ["School","UG","PG","Diploma","Others"]
        self.jobCardArray = ["MGNRGEA","BPL/PIP Card"]
    }
    
    func yearsForPickerView()
    {
        var formattedDate: String? = ""
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        formattedDate = format.string(from: date)
        
        for i in (Int(formattedDate!)!-70..<Int(formattedDate!)!+1).reversed() {
                years.append("\(i)")
            }

        print(years)
    }
    
    @objc func reachabilityChanged(note: Notification)
    {
          let reachability = note.object as! Reachability
          switch reachability.currentReachabilityStatus {
          case .notReachable:
          print("Network became unreachable")
          networkConnectionFrom = "No Connection"
          gps_status = "N"
          case .reachableViaWiFi:
          print("Network reachable through WiFi")
          networkConnectionFrom = "WiFi"
          gps_status = "Y"
          case .reachableViaWWAN:
          print("Network reachable through Cellular Data")
          networkConnectionFrom = "MobileData"
          gps_status = "Y"
      }
    }
    
    func CreateTableForProspectData ()
    {
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        databasePath = dirPaths[0].appendingPathComponent("contacts.db").path
        
        if !filemgr.fileExists(atPath: databasePath as String) {
            
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
            
        if (contactDB.open()) {
            let sql_stmt = "CREATE TABLE IF NOT EXISTS Prospects_data_storage (ID INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT NOT NULL, pia_id TEXT NOT NULL, name TEXT NOT NULL, sex TEXT NOT NULL, dob TEXT NOT NULL, age TEXT NOT NULL, nationality TEXT NOT NULL, religion TEXT NOT NULL, community_class TEXT NOT NULL, community TEXT NOT NULL, blood_group TEXT NOT NULL, father_name TEXT NOT NULL, mother_name TEXT NOT NULL, mobile TEXT NOT NULL, sec_mobile TEXT NOT NULL, email TEXT NOT NULL, qualification TEXT NOT NULL, degree TEXT NOT NULL, yearOfEducation TEXT NOT NULL, yearOfPassing TEXT NOT NULL, identificationMarkOne TEXT NOT NULL, identificationMarkTwo TEXT NOT NULL, headOfFamily TEXT NOT NULL, highestEducationQualification TEXT NOT NULL, fatherMobileNumber TEXT NOT NULL, motherMobileNumber TEXT NOT NULL, yearlyIncome TEXT NOT NULL, motherTonque TEXT NOT NULL, languagesKnown TEXT NOT NULL, numbOfFamilyMembers TEXT NOT NULL, state TEXT NOT NULL, city TEXT NOT NULL, addressOne TEXT NOT NULL, addressTwo TEXT NOT NULL, disability TEXT NOT NULL, preferred_trade TEXT NOT NULL, aadhaar_card_number TEXT NOT NULL, jobcard TEXT NOT NULL, admission_date TEXT NOT NULL, admission_location TEXT NOT NULL, admission_latitude TEXT NOT NULL, admission_longitude TEXT NOT NULL, status TEXT NOT NULL, created_at TEXT NOT NULL, created_by TEXT NOT NULL, prospectImage BLOB, gps_status TEXT NOT NULL, sync_status TEXT NOT NULL)"
            
                if !(contactDB.executeStatements(sql_stmt)) {
                    print("Error: \(contactDB.lastErrorMessage())")
                }
            contactDB.close()
        }
        else {
        print("Error: \(contactDB.lastErrorMessage())")
        }
      }
    }
    
    func insertProspectValuesToDB ()
    {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let imgData = uploadedImage.pngData()
            if imgData != nil
            {
                self.imageName = imgData?.base64EncodedString(options: .lineLength64Characters) ?? ""
            }
            else
            {
                let alertController = UIAlertController(title: "M3", message: "image is mandatory", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
        
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
        
            let _qualification = graduation.text
            let _degree = degree.text
            let _QulaifiedPromo = qualifiedPromotion.text
            let _lastStudied = lastStudied.text
            let _yearOfEducation = yearOfEducation.text
            let _yearofPassing = yearOfPassing.text
            let _identificationMarksOne = identificationMarksOne.text
            let _identificationMarksTwo = identificationMarksTwo.text
        
            let _headOfFamily = headOfFamily.text
            let _highestEducation = highestEducationQualification.text
            let _fatherMobile = fatherMobileNumber.text
            let _motherMobile = motherMobileNumber.text
            let _yearlyIncome = yearlyIncome.text
            let _languagesKnown = languageKnown.text
            let _numberOfMembers = numberOfMembersInFamily.text
        
            let _state = state.text
            let _city = city.text
            GlobalVariables.address = addressLine1.text
            let _address2 = addressLine2.text
            let _preferedTrade = department.text
            let _adharNumber = adharNumber.text
            let _jobCard = jobCard.text
            let _motherTonque = motherTonque.text

            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            let date = Date()
//            let preferred_timing = dateFormatter.string(from: date)

            let dateformatter4 = DateFormatter()
            dateformatter4.dateFormat = "yyyy-MM-dd hh:mm"
            let now = Date()
            let admisiondate = dateformatter4.string(from: now)
        
            print(_address2!,self.trade_id)

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
            else if (Int(_age!)! < 15)
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
            else if (_caste!.isEmpty)
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
            else if (_mobileNumber!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_mailId!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_qualification!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_degree!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_QulaifiedPromo!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_lastStudied!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_yearOfEducation!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_yearofPassing!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_identificationMarksOne!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_identificationMarksTwo!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_headOfFamily!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_highestEducation!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_fatherMobile!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_motherMobile!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_yearlyIncome!.isEmpty)
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
            else if (_languagesKnown!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_numberOfMembers!.isEmpty)
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
            else if (_preferedTrade!.isEmpty)
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
                let fileURL = try! FileManager.default
                    .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent("test.sqlite")

                let database = FMDatabase(url: fileURL)

                guard database.open() else {
                    print("Unable to open database")
                    return
                }
                
                do {
                    
                    let insertSQL = "insert into Prospects_data_storage (user_id, pia_id, name, sex, dob, age, nationality, religion, community_class, community, blood_group, father_name, mother_name, mobile, sec_mobile, email, qualification, degree, qualifiedPromotion, LastStudied, yearOfEducation, yearOfPassing, identificationMarkOne, identificationMarkTwo, headOfFamily, highestEducationQualification, fatherMobileNumber, motherMobileNumber, yearlyIncome, motherTonque, languagesKnown, numbOfFamilyMembers, state, city, addressOne, addressTwo, disability, preferred_trade, aadhaar_card_number, jobcard, admission_date, admission_location, admission_latitude, admission_longitude, status, created_at, created_by, prospectImage, gps_status, sync_status) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
                    
                    try database.executeUpdate(insertSQL, values: [GlobalVariables.user_id!, GlobalVariables.pia_id!, GlobalVariables.studentname!, GlobalVariables.sex!, _dob as Any, _age as Any, _nationality as Any, _religion as Any, _community as Any, _caste as Any, _bloodgroup as Any, GlobalVariables.father_name!, _motherName as Any, _mobileNumber as Any, _seccondarymobNum as Any, _mailId as Any, _qualification!, _degree as Any, _QulaifiedPromo as Any, _lastStudied as Any, _yearOfEducation as Any, _yearofPassing as Any, _identificationMarksOne as Any, _identificationMarksTwo as Any, _headOfFamily as Any, _highestEducation as Any, _fatherMobile as Any, _motherMobile as Any, _yearlyIncome as Any, _motherTonque as Any, _languagesKnown as Any, _numberOfMembers as Any, _state as Any, _city as Any, GlobalVariables.address as Any, _address2 as Any, disablity, self.trade_id, _adharNumber!, _jobCard!, admisiondate, self.streetName, latitudeCurrentLocation, longitudeCurrentLocation, "Pending", admisiondate, GlobalVariables.user_id!,self.imageName, gps_status, "N"])
                    
                    self.lastInsertedID = Int(database.lastInsertRowId)
                    print(self.lastInsertedID)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    print("Value inserted")
                    let alertController = UIAlertController(title: "M3", message: "Data Saved", preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                        print("You've pressed default");
                        self.performSegue(withIdentifier: "to_Documentation", sender: self)
                    }
                    alertController.addAction(action1)
                    self.present(alertController, animated: true, completion: nil)
                    
                   }
                catch {
                     print("failed: \(error.localizedDescription)")
                  }

                  database.close()
                
            }
    }
    
    func pickStartDate(_ textField : UITextField)
    {
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = .date
        dob.inputView = self.datePicker
        datePicker.setValue(UIColor.black, forKeyPath: "textColor")
        // ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        // Done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(startDateDoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        // Add toolbar to textField
        dob.inputAccessoryView = toolbar
        // Add datepicker to textField
        dob.inputView = datePicker
    }
    
    @objc func startDateDoneClick()
    {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        dob.text = dateFormatter1.string(from: datePicker.date)
        let dobToAge = getAgeFromDOF(date: dob.text!)
        if dobToAge < 15
        {
            let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
                self.dob.becomeFirstResponder()
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            self.age.text = String(dobToAge)
            dob.resignFirstResponder()
            religion.becomeFirstResponder()
        }

    }
    
    @objc func cancelClick()
    {
        self.dob.text = ""
        dob.resignFirstResponder()
        religion.becomeFirstResponder()
    }
    
    func pickerforGender(_ textField : UITextField)
    {
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        picker.backgroundColor = .white
        picker.setValue(UIColor.black, forKeyPath: "textColor")
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
        
        yearOfPassing.inputView = picker
        yearOfPassing.inputAccessoryView = toolBar
        
        yearOfEducation.inputView = picker
        yearOfEducation.inputAccessoryView = toolBar
        
        graduation.inputView = picker
        graduation.inputAccessoryView = toolBar
        
        jobCard.inputView = picker
        jobCard.inputAccessoryView = toolBar
        
        qualifiedPromotion.inputView = picker
        qualifiedPromotion.inputAccessoryView = toolBar
        
        caste.inputView = picker
        caste.inputAccessoryView = toolBar


    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if gender.isFirstResponder
        {
            return genderPicker.count
        }
        else if bloodGroup.isFirstResponder
        {
            return bloodgroupArr.count
        }
        else if department.isFirstResponder
        {
            return tradename.count
        }
        else if qualifiedPromotion.isFirstResponder
        {
            return qualifieedPromoArray.count
        }
        else if yearOfPassing.isFirstResponder
        {
            return years.count
        }
        else if yearOfEducation.isFirstResponder
        {
            return years.count
        }
        else if graduation.isFirstResponder
        {
            return qualificatioArray.count
        }
        else if jobCard.isFirstResponder
        {
            return jobCardArray.count
        }
        else
        {
            return communityClass.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if gender.isFirstResponder
        {
             return genderPicker[row]
        }
        else if bloodGroup.isFirstResponder
        {
            return (bloodgroupArr[row] as! String)
        }
        else if department.isFirstResponder
        {
            return tradename[row]
        }
        else if qualifiedPromotion.isFirstResponder
        {
            return qualifieedPromoArray [row]
        }
        else if yearOfPassing.isFirstResponder
        {
            return years[row]
        }
        else if yearOfEducation.isFirstResponder
        {
            return years[row]
        }
        else if graduation.isFirstResponder
        {
            return qualificatioArray[row]
        }
        else if jobCard.isFirstResponder
        {
            return jobCardArray[row]
        }
        else
        {
            return communityClass[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if gender.isFirstResponder
        {
            self.gender.text = genderPicker[row]
        }
        else if bloodGroup.isFirstResponder
        {
            self.bloodGroup.text = (bloodgroupArr[row] as! String)
        }
        else if department.isFirstResponder
        {
            self.department.text = tradename[row]
            trade_id = _id[row]
            print(_id)
            print(trade_id)
        }
        else if qualifiedPromotion.isFirstResponder
        {
            self.qualifiedPromotion.text = qualifieedPromoArray[row]
        }
        else if yearOfPassing.isFirstResponder
        {
            self.yearOfPassing.text = years[row]
        }
        else if yearOfEducation.isFirstResponder
        {
            self.yearOfEducation.text = years[row]
        }
        else if graduation.isFirstResponder
        {
            self.graduation.text = qualificatioArray[row]
        }
        else if jobCard.isFirstResponder
        {
            self.jobCard.text = jobCardArray[row]
        }
        else
        {
            self.caste.text = communityClass[row]
        }
    }
    
    @objc func genderpickerdoneClick ()
    {
        if gender.isFirstResponder
        {
            let selectedIndex = picker.selectedRow(inComponent: 0)
            gender.text = genderPicker[selectedIndex]
            gender.resignFirstResponder()
            dob.becomeFirstResponder()
        }
        else if bloodGroup.isFirstResponder
        {
            let selectedIndex = picker.selectedRow(inComponent: 0)
            bloodGroup.text = (bloodgroupArr[selectedIndex] as! String)
            bloodGroup.resignFirstResponder()
            motherName.becomeFirstResponder()
        }
        else if department.isFirstResponder
        {
            let selectedIndex = picker.selectedRow(inComponent: 0)
            department.text = tradename[selectedIndex]
            trade_id = _id[selectedIndex]
            print(trade_id)
            department.resignFirstResponder()
//            graduation.becomeFirstResponder()
        }
        else if qualifiedPromotion.isFirstResponder
        {
            let selectedIndex = picker.selectedRow(inComponent: 0)
            qualifiedPromotion.text = qualifieedPromoArray [selectedIndex]
            qualifiedPromotion.resignFirstResponder()
            lastStudied.becomeFirstResponder()
        }
        else if yearOfEducation.isFirstResponder
        {
             let selectedIndex = picker.selectedRow(inComponent: 0)
             yearOfEducation.text = years[selectedIndex]
             yearOfEducation.resignFirstResponder()
             yearOfPassing.becomeFirstResponder()
        }
        else if yearOfPassing.isFirstResponder
        {
            let selectedIndex = picker.selectedRow(inComponent: 0)
            yearOfPassing.text = years[selectedIndex]
            yearOfPassing.resignFirstResponder()
            identificationMarksOne.becomeFirstResponder()
        }
        else if graduation.isFirstResponder
        {
            let selectedIndex = picker.selectedRow(inComponent: 0)
            graduation.text = qualificatioArray[selectedIndex]
            graduation.resignFirstResponder()
            degree.becomeFirstResponder()
        }
        else if jobCard.isFirstResponder
        {
            let selectedIndex = picker.selectedRow(inComponent: 0)
            jobCard.text = jobCardArray[selectedIndex]
            jobCard.resignFirstResponder()
        }
        else
        {
            let selectedIndex = picker.selectedRow(inComponent: 0)
            caste.text = communityClass[selectedIndex]
            caste.resignFirstResponder()
            bloodGroup.becomeFirstResponder()

        }
    }
    
    @objc func genderpickercancelClick ()
    {
        if gender.isFirstResponder
        {
            gender.resignFirstResponder()
            dob.becomeFirstResponder()
        }
        else if bloodGroup.isFirstResponder
        {
            bloodGroup.resignFirstResponder()
            motherName.becomeFirstResponder()
        }
        else if department.isFirstResponder
        {
            department.resignFirstResponder()
        }
        else if qualifiedPromotion.isFirstResponder
        {
            lastStudied.becomeFirstResponder()
        }
        else if yearOfEducation.isFirstResponder
        {
             yearOfPassing.becomeFirstResponder()
        }
        else if yearOfPassing.isFirstResponder
        {
            identificationMarksOne.becomeFirstResponder()
        }
        else if graduation.isFirstResponder
        {
            degree.becomeFirstResponder()
        }
        else if jobCard.isFirstResponder
        {
            jobCard.resignFirstResponder()
            self.view.endEditing(true);
        }
        else
        {
            caste.resignFirstResponder()
            bloodGroup.becomeFirstResponder()
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
     
    @IBAction func submitButton(_ sender: Any)
    {
        if networkConnectionFrom == "No Connection"
        {
            self.insertProspectValuesToDB()
        }
        else
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
            let _qualification = graduation.text

            let _degree = degree.text
            let _QulaifiedPromo = qualifiedPromotion.text
            let _lastStudied = lastStudied.text
            let _yearOfEducation = yearOfEducation.text
            let _yearofPassing = yearOfPassing.text
            let _identificationMarksOne = identificationMarksOne.text
            let _identificationMarksTwo = identificationMarksTwo.text

            let _headOfFamily = headOfFamily.text
            let _highestEducation = highestEducationQualification.text
            let _fatherMobile = fatherMobileNumber.text
            let _motherMobile = motherMobileNumber.text
            let _yearlyIncome = yearlyIncome.text
            let _languagesKnown = languageKnown.text
            let _numberOfMembers = numberOfMembersInFamily.text

            let _state = state.text
            let _city = city.text
            GlobalVariables.address = addressLine1.text
            let _address2 = addressLine2.text
            let _motherTonque = motherTonque.text
            let _adharNumber = adharNumber.text
            let _jobCard = jobCard.text

//          let dateFormatter : DateFormatter = DateFormatter()
//          dateFormatter.dateFormat = "HH:mm:ss"
//          let date = Date()
//          let preferred_timing = dateFormatter.string(from: date)
            let dateformatter4 = DateFormatter()
            dateformatter4.dateFormat = "yyyy-MM-dd hh:mm"
            let now = Date()
            let admisiondate = dateformatter4.string(from: now)
            print(_address2!,self.trade_id)
            let imgData = uploadedImage.jpegData(compressionQuality: 0.75)
            if imgData == nil
            {
                let alertController = UIAlertController(title: "M3", message: "Image is mandatory", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (GlobalVariables.studentname!.isEmpty)
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
            else if (Int(_age!)! < 15)
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
            else if (_caste!.isEmpty)
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
            else if (_mobileNumber!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_mailId!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_qualification!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_degree!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_QulaifiedPromo!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_lastStudied!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_yearOfEducation!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_yearofPassing!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_yearOfEducation! < _yearofPassing!)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_identificationMarksOne!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_identificationMarksTwo!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_headOfFamily!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_highestEducation!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_fatherMobile!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_motherMobile!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_yearlyIncome!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_languagesKnown!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (_numberOfMembers!.isEmpty)
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
            else if (_address2!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (self.department.text!.isEmpty)
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
                let _View =  UserDefaults.standard.string(forKey: "View")
                if _View == "fromaddprospectView"
                {
                    let baseUrl = Baseurl.baseUrl + "apimobilizer/add_student"
                    let url = URL(string: baseUrl)!
                    let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "pia_id": GlobalVariables.pia_id!, "name": GlobalVariables.studentname!, "sex": GlobalVariables.sex!, "dob":_dob!, "age": _age!, "nationality": _nationality!, "religion": _religion!, "community_class": _community!, "community": _caste!, "blood_group": _bloodgroup!,  "father_name": GlobalVariables.father_name!, "mother_name": _motherName!, "mobile": _mobileNumber!, "sec_mobile": _seccondarymobNum!, "email": _mailId!, "qualification": _qualification!, "qualification_details": _degree!,"qualified_promotion": _QulaifiedPromo!, "last_studied": _lastStudied!, "year_of_edu": _yearOfEducation!, "year_of_pass": _yearofPassing!, "identification_mark_1": _identificationMarksOne!, "identification_mark_2": _identificationMarksTwo!, "head_family_name": _headOfFamily!, "head_family_edu": _highestEducation!, "no_family": _numberOfMembers!, "mother_tongue": _motherTonque!, "lang_known": _languagesKnown!, "yearly_income": _yearlyIncome!, "father_mobile": _fatherMobile!, "mother_mobile": _motherMobile!, "jobcard_type": _jobCard!, "state": _state!, "city": _city!, "address": GlobalVariables.address!, "disability": disablity, "aadhaar_card_number": _adharNumber!, "admission_date": admisiondate, "admission_location": self.streetName, "preferred_trade": self.trade_id, "admission_latitude": latitudeCurrentLocation, "admission_longitude": longitudeCurrentLocation, "status": "Pending", "created_at": admisiondate,"created_by": GlobalVariables.user_id!]

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
                                    GlobalVariables.studentid = String(format: "%@",JSON?["admission_id"] as! CVarArg)
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
                else
                {
                    let baseUrl = Baseurl.baseUrl + "apimobilizer/update_student"
                    let url = URL(string: baseUrl)!
                    let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "pia_id": GlobalVariables.pia_id!, "admission_id": GlobalVariables.studentid!, "name": GlobalVariables.studentname!, "sex": GlobalVariables.sex!, "dob":_dob!, "age": _age!, "nationality": _nationality!, "religion": _religion!, "community_class": _community!, "community": _caste!, "blood_group": _bloodgroup!,  "father_name": GlobalVariables.father_name!, "mother_name": _motherName!, "mobile": _mobileNumber!, "sec_mobile": _seccondarymobNum!, "email": _mailId!, "qualification": _qualification!, "qualification_details": _degree!, "qualified_promotion": _QulaifiedPromo!, "last_studied": _lastStudied!, "year_of_edu": _yearOfEducation!, "year_of_pass": _yearofPassing!, "identification_mark_1": _identificationMarksOne!, "identification_mark_2": _identificationMarksTwo!, "head_family_name": _headOfFamily!, "head_family_edu": _highestEducation!, "no_family": _numberOfMembers!, "mother_tongue": _motherTonque!, "lang_known": _languagesKnown!, "yearly_income": _yearlyIncome!, "father_mobile": _fatherMobile!, "mother_mobile": _motherMobile!, "jobcard_type": _jobCard!, "state": _state!, "city": _city!, "address": GlobalVariables.address!, "disability": disablity, "aadhaar_card_number": _adharNumber!, "admission_date": admisiondate, "admission_location": self.streetName, "preferred_trade": self.trade_id, "admission_latitude": latitudeCurrentLocation, "admission_longitude": longitudeCurrentLocation, "status": "Pending", "created_at": admisiondate,"created_by": GlobalVariables.user_id!]

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
                                   let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                                   let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                       print("You've pressed default");
                                       self.performSegue(withIdentifier: "to_Documentation", sender: self)
                                   }
                                   alertController.addAction(action1)
                                   self.present(alertController, animated: true, completion: nil)
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
        }
//           self.performSegue(withIdentifier: "to_Documentation", sender: self)

    }
    
    func webRequest_Image ()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let imgData = uploadedImage.jpegData(compressionQuality: 0.75)
            let functionName = "apimobilizer/student_picupload/"
            let baseUrl = Baseurl.baseUrl + functionName + GlobalVariables.studentid!
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
                        MBProgressHUD.hide(for: self.view, animated: true)
                        if (response.result.value as? NSDictionary) != nil
                        {
                            self.performSegue(withIdentifier: "to_Documentation", sender: self)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
    }
    
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
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
        //self.performSegue(withIdentifier: "back_selectPage", sender: self)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        touchesBegan = "1"
        view.endEditing(true)
    }

    func viewStudentsDetails ()
    {
        let functionName = "apimobilizer/view_student"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["admission_id": GlobalVariables.studentid!]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    print(response)
                    MBProgressHUD.hide(for: self.view, animated: true)
 //                   let value =  as? [String: Any]
                    let json = JSON(response.result.value ?? "")
                    let msg = json["msg"].string
                    let status = json["status"]
                    if (status == "success")
                    {
                        let studentDetails = json["studentDetails"].dictionary
                        print(studentDetails as Any)
//                        for i in 0..<(studentDetails?.count ?? 0)
//                        {
//                          let dict = studentDetails?[i] as? [AnyHashable : Any]
                            GlobalVariables.aadhaar_card_number = json["studentDetails"]["aadhaar_card_number"].string
                            GlobalVariables.address = json["studentDetails"]["address"].string
                            GlobalVariables.admission_date = json["studentDetails"]["admission_date"].string
                            GlobalVariables.admission_latitude = json["studentDetails"]["admission_latitude"].string
                            GlobalVariables.admission_location = json["studentDetails"]["admission_location"].string
                            GlobalVariables.admission_longitude = json["studentDetails"]["admission_longitude"].string
                            GlobalVariables.aadhaar_card_number = json["studentDetails"]["aadhaar_card_number"].string
                            GlobalVariables.age = json["studentDetails"]["age"].string
                            GlobalVariables.blood_group = json["studentDetails"]["blood_group"].string
                            GlobalVariables.city = json["studentDetails"]["city"].string
                            GlobalVariables.community = json["studentDetails"]["community"].string
                            GlobalVariables.community_class = json["studentDetails"]["community_class"].string
                            GlobalVariables.created_at = json["studentDetails"]["created_at"].string
                            GlobalVariables.created_by = json["studentDetails"]["created_by"].string
                            GlobalVariables.disability = json["studentDetails"]["disability"].string
                            GlobalVariables.dob = json["studentDetails"]["dob"].string
                            GlobalVariables.email = json["studentDetails"]["email"].string
                            GlobalVariables.enrollment = json["studentDetails"]["enrollment"].string
                            GlobalVariables.father_name = json["studentDetails"]["father_name"].string
//                          GlobalVariables.have_aadhaar_card = (dict!["have_aadhaar_card"] as! String)
                            GlobalVariables.studentid = json["studentDetails"]["id"].string
                            GlobalVariables.last_institute = json["studentDetails"]["last_institute"].string
                            GlobalVariables.last_studied = json["studentDetails"]["last_studied"].string
                            GlobalVariables.mobile = json["studentDetails"]["mobile"].string
                            GlobalVariables.mother_name = json["studentDetails"]["mother_name"].string
                            GlobalVariables.mother_tongue = json["studentDetails"]["mother_tongue"].string
                            GlobalVariables.studentname = json["studentDetails"]["name"].string
                            GlobalVariables.nationality = json["studentDetails"]["nationality"].string
                            GlobalVariables.pia_id = json["studentDetails"]["pia_id"].string
//                          GlobalVariables.preferred_timing = (dict!["preferred_timing"] as! String)
                            GlobalVariables.preferred_trade = json["studentDetails"]["preferred_trade"].string
                            self.trade_id = json["studentDetails"]["preferred_trade"].string!
                            GlobalVariables.qualified_promotion = json["studentDetails"]["qualification"].string
                            GlobalVariables.religion = json["studentDetails"]["religion"].string
                            GlobalVariables.sec_mobile = json["studentDetails"]["sec_mobile"].string
                            GlobalVariables.sex = json["studentDetails"]["sex"].string
                            GlobalVariables.state = json["studentDetails"]["state"].string
                            GlobalVariables.status = json["studentDetails"]["status"].string
                            GlobalVariables.student_pic = json["studentDetails"]["student_pic"].string
//                          GlobalVariables.transfer_certificate = (dict!["transfer_certificate"] as! String)
                            GlobalVariables.updated_at = json["studentDetails"]["updated_at"].string
                            GlobalVariables.updated_by = json["studentDetails"]["updated_by"].string
                            
                            GlobalVariables.degree = json["studentDetails"]["qualification_details"].string
                            GlobalVariables.yearOfEducation = json["studentDetails"]["year_of_edu"].string
                            GlobalVariables.yearofPassing = json["studentDetails"]["year_of_pass"].string
                            GlobalVariables.identificationMarksOne = json["studentDetails"]["identification_mark_1"].string
                            GlobalVariables.identificationMarksTwo = json["studentDetails"]["identification_mark_2"].string
                            GlobalVariables.headOfFamily = json["studentDetails"]["head_family_name"].string
                            GlobalVariables.highestEducation = json["studentDetails"]["head_family_edu"].string
                            GlobalVariables.fatherMobile = json["studentDetails"]["father_mobile"].string
                            GlobalVariables.motherMobile = json["studentDetails"]["mother_mobile"].string
                            GlobalVariables.yearlyIncome = json["studentDetails"]["yearly_income"].string
                            GlobalVariables.languagesKnown = json["studentDetails"]["lang_known"].string
                            GlobalVariables.numberOfMembers = json["studentDetails"]["no_family"].string
                            GlobalVariables.jobCard = json["studentDetails"]["jobcard_type"].string

                            self.updateValues ()
                            
//                        }
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
        if GlobalVariables.degree != ""
        {
            self.degree.text = GlobalVariables.degree
        }
        if GlobalVariables.yearOfEducation != ""
        {
            self.yearOfEducation.text = GlobalVariables.yearOfEducation
        }
        if GlobalVariables.yearofPassing != ""
        {
            self.yearOfPassing.text = GlobalVariables.yearofPassing
        }
        if GlobalVariables.identificationMarksOne != ""
        {
            self.identificationMarksOne.text = GlobalVariables.identificationMarksOne
        }
        if GlobalVariables.identificationMarksTwo != ""
        {
            self.identificationMarksTwo.text = GlobalVariables.identificationMarksTwo
        }
        if GlobalVariables.headOfFamily != ""
        {
            self.headOfFamily.text = GlobalVariables.headOfFamily
        }
        if GlobalVariables.highestEducation != ""
        {
            self.highestEducationQualification.text = GlobalVariables.highestEducation
        }
        if GlobalVariables.fatherMobile != ""
        {
            self.fatherMobileNumber.text = GlobalVariables.fatherMobile
        }
        if GlobalVariables.motherMobile != ""
        {
            self.motherMobileNumber.text = GlobalVariables.motherMobile
        }
        if GlobalVariables.yearlyIncome != ""
        {
            self.yearlyIncome.text = GlobalVariables.yearlyIncome
        }
        if GlobalVariables.languagesKnown != ""
        {
            self.languageKnown.text = GlobalVariables.languagesKnown
        }
        if GlobalVariables.numberOfMembers != ""
        {
            self.numberOfMembersInFamily.text = GlobalVariables.numberOfMembers
        }
        if GlobalVariables.jobCard != ""
        {
            self.jobCard.text = GlobalVariables.jobCard
        }
        
//        if GlobalVariables.preferred_trade != ""
//        {
//            self.department.text = GlobalVariables.preferred_trade
//        }
        
//        let indexPostion  = [_id.index(of: GlobalVariables.preferred_trade!)]
        
        for i in 0..<(_id.count)
        {
            let tradenameObj = _id[i]
            if tradenameObj == GlobalVariables.preferred_trade!
            {
                self.department.text = tradename[i]
                print(self.department.text!)
            }
        }
        
        if GlobalVariables.student_pic != ""
        {
            studentImage.sd_setImage(with: URL(string: GlobalVariables.student_pic  ?? ""), placeholderImage: UIImage(named: "profile photo.png"))
            let url = URL(string:GlobalVariables.student_pic ?? "")
            if let data = try? Data(contentsOf: url!)
            {
                uploadedImage = UIImage(data: data)!
            }
            self.studentImage.layer.cornerRadius = studentImage.bounds.width/2
            self.studentImage.layer.borderWidth = 1
            self.studentImage.layer.borderColor = UIColor.lightGray.cgColor
            self.studentImage.clipsToBounds = true
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
            //religion.becomeFirstResponder()
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
            nationality.becomeFirstResponder()
            //self.pickStartDate(self.dob)
        }
        else if textField == nationality
        {
            caste.becomeFirstResponder()
            self.pickerforGender(self.caste)
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
            graduation.becomeFirstResponder()
            self.pickerforGender(self.graduation)
        }
        else if textField == graduation
        {
            degree.becomeFirstResponder()
        }
        else if textField == degree
        {
            qualifiedPromotion.becomeFirstResponder()
        }
        else if textField == qualifiedPromotion
        {
            lastStudied.becomeFirstResponder()
        }
        else if textField == lastStudied
        {
            yearOfEducation.becomeFirstResponder()
            self.pickerforGender(self.yearOfEducation)
        }
        else if textField == yearOfEducation
        {
            self.pickerforGender(self.yearOfEducation)
            yearOfPassing.becomeFirstResponder()
        }
        else if textField == yearOfPassing
        {
            self.pickerforGender(self.yearOfPassing)
            identificationMarksOne.becomeFirstResponder()
        }
        else if textField == identificationMarksOne
        {
            identificationMarksTwo.becomeFirstResponder()
        }
        else if textField == identificationMarksTwo
        {
            headOfFamily.becomeFirstResponder()
        }
        else if textField == headOfFamily
        {
            highestEducationQualification.becomeFirstResponder()
        }
        else if textField == highestEducationQualification
        {
            fatherMobileNumber.becomeFirstResponder()
        }
        else if textField == fatherMobileNumber
        {
            motherMobileNumber.becomeFirstResponder()
        }
        else if textField == motherMobileNumber
        {
            yearlyIncome.becomeFirstResponder()
        }
        else if textField == yearlyIncome
        {
            motherTonque.becomeFirstResponder()
        }
        else if textField == motherTonque
        {
            languageKnown.becomeFirstResponder()
        }
        else if textField == languageKnown
        {
            numberOfMembersInFamily.becomeFirstResponder()
        }
        else if textField == numberOfMembersInFamily
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
            department.becomeFirstResponder()
            self.pickerforGender(self.department)
        }
        else if textField == department
        {
            adharNumber.becomeFirstResponder()
        }
        else if textField == adharNumber
        {
            jobCard.becomeFirstResponder()
            self.pickerforGender(self.jobCard)

        }
        else if textField == jobCard
        {
            jobCard.resignFirstResponder()
            self.view.endEditing(true);
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == fullName
        {

            self.pickerforGender(self.gender)
        }
        else if textField == gender
        {
            self.pickerforGender(self.gender)
        }
        else if textField == bloodGroup
        {
            self.pickerforGender(self.bloodGroup)
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
        }
        else if textField == age
        {
            //self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
        }
        else if textField == religion
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
        }
        else if textField == casteName
        {
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
            self.pickerforGender(self.caste)
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
        else if textField == graduation
        {
            self.pickerforGender(self.graduation)
//          self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 400), animated: true)
        }
        else if textField == degree
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 400), animated: true)
        }
        else if textField == qualifiedPromotion
        {
            self.pickerforGender(self.qualifiedPromotion)
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 500), animated: true)
        }
        else if textField == lastStudied
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 500), animated: true)
        }
        else if textField == yearOfEducation
        {
            self.pickerforGender(self.yearOfEducation)
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 600), animated: true)
        }
        else if textField == yearOfPassing
        {
            self.pickerforGender(self.yearOfPassing)
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 600), animated: true)
        }
        else if textField == identificationMarksOne
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 800), animated: true)
        }
        else if textField == identificationMarksTwo
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 800), animated: true)
        }
        else if textField == headOfFamily
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 800), animated: true)
        }
        else if textField == highestEducationQualification
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1000), animated: true)
        }
        else if textField == fatherMobileNumber
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1000), animated: true)
        }
        else if textField == motherMobileNumber
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1000), animated: true)
        }
        else if textField == yearlyIncome
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1000), animated: true)
        }
        else if textField == motherTonque
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1200), animated: true)
        }
        else if textField == languageKnown
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1200), animated: true)
        }
        else if textField == numberOfMembersInFamily
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1200), animated: true)
        }
        else if textField == numberOfMembersInFamily
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1400), animated: true)
        }
        else if textField == state
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1400), animated: true)
        }
        else if textField == city
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1400), animated: true)
        }
        else if textField == addressLine1
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1400), animated: true)

        }
        else if textField == addressLine2
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1400), animated: true)

        }
//        else if textField == motherTonque
//        {
//            self.pickerforGender(self.department)
//            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1400), animated: true)
//
//        }
        else if textField == department
        {
            self.pickerforGender(self.department)
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1600), animated: true)
        }
        else if textField == adharNumber
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1600), animated: true)
        }
        else if textField == jobCard
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1600), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if touchesBegan == "0"
        {
            touchesBegan = "0"

            if textField == fullName
            {
                gender.becomeFirstResponder()
                self.pickerforGender(self.gender)
            }
            else if textField == gender
            {
                //age.becomeFirstResponder()
            }
            else if textField == bloodGroup
            {
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
            }
            else if textField == fatherName
            {
                nationality.becomeFirstResponder()
                //self.pickStartDate(self.dob)
            }
            else if textField == nationality
            {
                caste.becomeFirstResponder()
                self.pickerforGender(self.caste)
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
                graduation.becomeFirstResponder()
                self.pickerforGender(self.graduation)
            }
            else if textField == graduation
            {
                degree.becomeFirstResponder()
            }
            else if textField == degree
            {
                qualifiedPromotion.becomeFirstResponder()
            }
            else if textField == qualifiedPromotion
            {
                lastStudied.becomeFirstResponder()
            }
            else if textField == lastStudied
            {
                yearOfEducation.becomeFirstResponder()
            }
            else if textField == yearOfEducation
            {
                yearOfPassing.becomeFirstResponder()
            }
            else if textField == yearOfPassing
            {
               identificationMarksOne.becomeFirstResponder()
            }
            else if textField == identificationMarksOne
            {
                identificationMarksTwo.becomeFirstResponder()
            }
            
            else if textField == identificationMarksTwo
            {
                headOfFamily.becomeFirstResponder()
            }
            else if textField == headOfFamily
            {
                highestEducationQualification.becomeFirstResponder()
            }
            else if textField == highestEducationQualification
            {
                fatherMobileNumber.becomeFirstResponder()
            }
            else if textField == fatherMobileNumber
            {
                motherMobileNumber.becomeFirstResponder()
            }
            else if textField == motherMobileNumber
            {
                yearlyIncome.becomeFirstResponder()
            }
            else if textField == yearlyIncome
            {
               motherTonque.becomeFirstResponder()
            }
            else if textField == motherTonque
            {
                languageKnown.becomeFirstResponder()
            }
            else if textField == languageKnown
            {
                numberOfMembersInFamily.becomeFirstResponder()
            }
            else if textField == numberOfMembersInFamily
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
                department.becomeFirstResponder()
                self.pickerforGender(self.department)
            }
//            else if textField == motherTonque
//            {
//                department.becomeFirstResponder()
//                self.pickerforGender(self.department)
//            }
            else if textField == department
            {
                adharNumber.becomeFirstResponder()
            }
            else if textField == adharNumber
            {
                jobCard.becomeFirstResponder()
                self.pickerforGender(self.jobCard)

            }
            else if textField == jobCard
            {
                jobCard.resignFirstResponder()
                self.view.endEditing(true);
            }
        }
        else
        {
            textField.resignFirstResponder()
            
            touchesBegan = "1"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
      {
       if textField == mobileNumber
       {
           let currentCharacterCount = textField.text?.count ?? 0
           if range.length + range.location > currentCharacterCount
           {
               return false
           }
           let newLength = currentCharacterCount + string.count - range.length
           return newLength <= 10
       }
       else if textField == mobilenumberSecondary
       {
           let currentCharacterCount = textField.text?.count ?? 0
           if range.length + range.location > currentCharacterCount
           {
              return false
           }
           let newLength = currentCharacterCount + string.count - range.length
           return newLength <= 10
       }
        else if textField == fatherMobileNumber
        {
            let currentCharacterCount = textField.text?.count ?? 0
            if range.length + range.location > currentCharacterCount
            {
               return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 10
        }
        else if textField == motherMobileNumber
        {
            let currentCharacterCount = textField.text?.count ?? 0
            if range.length + range.location > currentCharacterCount
            {
               return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 10
        }
       else if textField == adharNumber
       {
            let currentCharacterCount = textField.text?.count ?? 0
            if range.length + range.location > currentCharacterCount
            {
               return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 12
        }
       else
       {
           let currentCharacterCount = textField.text?.count ?? 0
           if range.length + range.location > currentCharacterCount
           {
              return false
           }
              let newLength = currentCharacterCount + string.count - range.length
              return newLength <= 30
       }
     }
    
    func getAgeFromDOF(date: String) -> (Int) {

        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-MM-dd"
        let dateOfBirth = dateFormater.date(from: date)

        let calender = Calendar.current

        let dateComponent = calender.dateComponents([.year, .month, .day], from:
        dateOfBirth!, to: Date())

        return (dateComponent.year!)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "to_Documentation")
        {
            let vc = segue.destination as! Documentation
            vc.prospect_id = String(self.lastInsertedID)
        }
    }
}
