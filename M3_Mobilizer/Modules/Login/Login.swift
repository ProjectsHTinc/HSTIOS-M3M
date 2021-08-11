//
//  ViewController.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 18/12/18.
//  Copyright © 2018 Happy Sanz Tech. All rights reserved.
//


import UIKit
import Alamofire
import CoreLocation
import MapKit
import Foundation
import MBProgressHUD
import SwiftyJSON
import ReachabilitySwift


class Login: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate
{
    var activeField: UITextField?
    var eyeisClicked = true
    let locationManager = CLLocationManager()
    var livelocTimer: Timer!
    var userLive_Latitude : Double?
    var userLive_Longitude : Double?
    var streetName = ""
    var distanceMiles : Double?
    var firstupload = "YES"
    var locationFixAchieved : Bool = false
    var startLocation = CLLocation()
    var lastLocation = CLLocation()
    private var startTime: Date?
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    let reachability = Reachability()
    var networkConnectionFrom = String()
    
    var doc_name = [String]()
    var doc_type = [String]()
    var doc_id = [String]()
    var doc_status = [String]()


    override func viewDidLoad()
    {
        super.viewDidLoad()
        NavigationBarTitleColor.navbar_TitleColor
        userName.delegate = self
        passWord.delegate = self
        LoginOutlet.layer.cornerRadius = 4
        eyeisClicked = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // For use when the app is open & in the background
//        locationManager.requestAlwaysAuthorization()
//        if CLLocationManager.locationServicesEnabled() == true
//        {
//            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied ||  CLLocationManager.authorizationStatus() == .notDetermined {
//                locationManager.requestWhenInUseAuthorization()
//            }
//
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.allowsBackgroundLocationUpdates = true
//            locationManager.pausesLocationUpdatesAutomatically = false
//            locationManager.activityType = .automotiveNavigation
//            locationManager.delegate = self
//        }
//        else
//        {
//            print("Please turn on location services or GPS")
//        }

    }
    
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
//    {
//        let userLocation:CLLocation = locations[0] as CLLocation
//        locationManager.stopUpdatingLocation()
//        locationManager.delegate = nil
//        if locationFixAchieved == false
//        {
//            locationManager.stopUpdatingLocation()
//            locationManager.delegate = nil
//            print(startLocation)
//            userLive_Latitude = userLocation.coordinate.latitude
//            userLive_Longitude = userLocation.coordinate.longitude
//            startLocation = CLLocation(latitude: userLive_Latitude!, longitude: userLive_Longitude!)
//            locationFixAchieved = true
//            locationName ()
//        }
//        else
//        {
//            lastLocation = CLLocation(latitude:userLocation.coordinate.latitude , longitude: userLocation.coordinate.longitude)
//            print(lastLocation)
//            let distanceMeters: CLLocationDistance  = (startLocation.distance(from: lastLocation))
//            print("distance = \(distanceMeters)")
//            let decimalToInt = Int(distanceMeters)
//            print("distance = \(decimalToInt)")
//            if 30 < decimalToInt
//            {
//                userLive_Latitude = userLocation.coordinate.latitude
//                userLive_Longitude = userLocation.coordinate.longitude
//                startLocation = CLLocation(latitude:userLocation.coordinate.latitude , longitude: userLocation.coordinate.longitude)
//                locationName ()
//            }
//
////              self.locationManager.startUpdatingLocation()
////              self.locationManager.delegate = self
//        }
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: ReachabilityChangedNotification,
                                               object: reachability)
        do{
            try reachability!.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification)
    {
          let reachability = note.object as! Reachability
          switch reachability.currentReachabilityStatus {
          case .notReachable:
          print("Network became unreachable")
          networkConnectionFrom = "No Connection"
          case .reachableViaWiFi:
          print("Network reachable through WiFi")
          networkConnectionFrom = "WiFi"
          case .reachableViaWWAN:
          print("Network reachable through Cellular Data")
          networkConnectionFrom = "MobileData"
      }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
        self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == userName
        {
            passWord.becomeFirstResponder()
        }
        else
        {
            passWord.resignFirstResponder()
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            self.view.endEditing(true);
        }
    }
 
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var LoginOutlet: UIButton!
    
    @IBAction func passwordEyeButton(_ sender: Any)
    {
        if (eyeisClicked == true)
        {
            let image = UIImage(named: "unhide.png") as UIImage?
            passwordEyeOutlet.setBackgroundImage(image, for: UIControl.State.normal)
            passWord.isSecureTextEntry = false
            eyeisClicked = false
        }
        else
        {
            let image = UIImage(named: "hide.png") as UIImage?
            passwordEyeOutlet.setBackgroundImage(image, for: UIControl.State.normal)
            passWord.isSecureTextEntry = true
            eyeisClicked = true
        }
    }
    
    @IBOutlet weak var passwordEyeOutlet: UIButton!
    
    @IBAction func loginAction(_ sender: Any)
    {
        let name = userName.text
        let password = passWord.text
        
        if (name!.isEmpty)
        {
            let alertController = UIAlertController(title: "M3", message: "Username is empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if(password!.isEmpty)
        {
            let alertController = UIAlertController(title: "M3", message: "Password is empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if networkConnectionFrom == "No Connection"
        {
            let alertController = UIAlertController(title: "M3", message: "Device is offline. Please check the network connection and try again.", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let functionName = "apimain/login/"
            let baseUrl = Baseurl.baseUrl + functionName
            let url = URL(string: baseUrl)!
            let parameters: Parameters = ["user_name": name!, "password": password!, "mobile_type": "2", "device_id": "gjhghjgjhg"]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
                {
                    response in
                    switch response.result
                    {
                    case .success(let value):
                        //print(value)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        //let JSON = response.result.value as? [String: Any]
                        let json = JSON(value)
                        print("JSON: \(json)")
                        let msg = json["msg"].stringValue
                        if (msg == "User loggedIn successfully")
                        {
                            //self.startupdatinguserLocation ()
                            // Mark : Parseing userData
                            let userdata = json["userData"].dictionary
                            print(userdata!)
                            let name = json["userData"]["name"].string
                            let password_status = json["userData"]["password_status"].string
                            let user_pic = json["userData"]["user_pic"].string
                            let user_name = json["userData"]["user_name"].string
                            let user_type = json["userData"]["user_type"].string
                            let user_type_name = json["userData"]["user_type_name"].string
                            let user_id = json["userData"]["user_id"].string
                            
                            UserDefaults.standard.set(name, forKey: "name")
                            UserDefaults.standard.set(password_status, forKey: "password_status")
                            UserDefaults.standard.set(user_pic, forKey: "user_pic")
                            UserDefaults.standard.set(user_name, forKey: "user_name")
                            UserDefaults.standard.set(user_type, forKey: "user_type")
                            UserDefaults.standard.set(user_type_name, forKey: "user_type_name")
                            UserDefaults.standard.set(user_id, forKey: "user_id")
                            
                            GlobalVariables.name = UserDefaults.standard.object(forKey: "name") as? String
                            GlobalVariables.user_name =  UserDefaults.standard.object(forKey: "user_name") as? String
                            GlobalVariables.user_pic =  UserDefaults.standard.object(forKey: "user_pic") as? String
                            GlobalVariables.user_type =  UserDefaults.standard.object(forKey: "user_type") as? String
                            GlobalVariables.user_type_name =  UserDefaults.standard.object(forKey: "user_type_name") as? String
                            GlobalVariables.user_id =  UserDefaults.standard.object(forKey: "user_id") as? String

                            
                            let staffProfile = json["staffProfile"].dictionary
//                            print(staffProfile!)
                            let nationality = json["staffProfile"]["nationality"].string
                            let sex = json["staffProfile"]["sex"].string
                            let staffName = json["staffProfile"]["name"].string
                            let role_type = json["staffProfile"]["role_type"].string
                            let phone = json["staffProfile"]["phone"].string
                            let religion = json["staffProfile"]["religion"].string
                            let age = json["staffProfile"]["age"].string
                            let address = json["staffProfile"]["address"].string
                            let community = json["staffProfile"]["community"].string
                            let qualification = json["staffProfile"]["qualification"].string
                            let staff_id = json["staffProfile"]["staff_id"].string
                            let email = json["staffProfile"]["email"].string
                            let community_class = json["staffProfile"]["community_class"].string
                            let pia_id = json["staffProfile"]["pia_id"].string
                            
                            UserDefaults.standard.set(nationality, forKey: "nationality")
                            UserDefaults.standard.set(sex, forKey: "sex")
                            UserDefaults.standard.set(staffName, forKey: "staffName")
                            UserDefaults.standard.set(role_type, forKey: "role_type")
                            UserDefaults.standard.set(phone, forKey: "phone")
                            UserDefaults.standard.set(religion, forKey: "religion")
                            UserDefaults.standard.set(age, forKey: "age")
                            UserDefaults.standard.set(address, forKey: "address")
                            UserDefaults.standard.set(community, forKey: "community")
                            UserDefaults.standard.set(qualification, forKey: "qualification")
                            UserDefaults.standard.set(staff_id, forKey: "staff_id")
                            UserDefaults.standard.set(email, forKey: "email")
                            UserDefaults.standard.set(community_class, forKey: "community_class")
                            UserDefaults.standard.set(pia_id, forKey: "pia_id")
                            
                            GlobalVariables.staff_address = UserDefaults.standard.object(forKey: "address") as? String
                            GlobalVariables.staff_age = UserDefaults.standard.object(forKey: "age") as? String
                            GlobalVariables.staff_community = UserDefaults.standard.object(forKey: "community") as? String
                            GlobalVariables.staff_community_class = UserDefaults.standard.object(forKey: "community_class") as? String
                            GlobalVariables.staff_email = UserDefaults.standard.object(forKey: "email") as? String
                            GlobalVariables.staff_name = UserDefaults.standard.object(forKey: "staffName") as? String
                            GlobalVariables.staff_nationality = UserDefaults.standard.object(forKey: "nationality") as? String
                            GlobalVariables.staff_phone = UserDefaults.standard.object(forKey: "phone") as? String
                            GlobalVariables.pia_id = UserDefaults.standard.object(forKey: "pia_id") as? String
                            GlobalVariables.staff_qualification = UserDefaults.standard.object(forKey: "qualification") as? String
                            GlobalVariables.staff_religion = UserDefaults.standard.object(forKey: "religion") as? String
                            GlobalVariables.staff_role_type = UserDefaults.standard.object(forKey: "role_type") as? String
                            GlobalVariables.staff_sex = UserDefaults.standard.object(forKey: "sex") as? String
                            GlobalVariables.staff_staff_id = UserDefaults.standard.object(forKey: "staff_id") as? String
                            self.documentMasterID(user_id:GlobalVariables.user_id!)
                            UserDefaults.standard.set("YES", forKey: "FstLoginKey")
                            self.performSegue(withIdentifier:"dashboard", sender: self)
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

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    
    func startupdatinguserLocation ()
    {
        self.locationManager.startUpdatingLocation()
    }
    
    func locationName ()
    {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude:userLive_Latitude!, longitude:userLive_Longitude!)
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
                   self.webReqLocation ()
                }
                // City
                if let city = placeMark.subAdministrativeArea
                {
                    print(city)
                }
                // Zip code
                if let zip = placeMark.isoCountryCode
                {
                    print(zip)
                }
                // Country
                if let country = placeMark.country
                {
                    print(country)
                }
        })
    }
    
    @objc func webReqLocation ()
    {
        let dateformatter4 = DateFormatter()
        dateformatter4.dateFormat = "yyyy-MM-dd h:mm:ss"
        let now = Date()
        let date_time = dateformatter4.string(from: now)
        
        let functionName = "apimobilizer/add_mobilocation/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "pia_id":GlobalVariables.pia_id!, "latitude":userLive_Latitude!, "longitude":userLive_Longitude!, "location":self.streetName, "miles":"625371","location_datetime": date_time]
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
                    if (status == "Sucess")
                    {
                        self.locationManager.stopUpdatingLocation()
                        self.locationManager.delegate = nil
                        self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
                        })
                        self.livelocTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.callLocation), userInfo: nil, repeats: true)
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
    
    @objc func callLocation ()
    {
        self.locationManager.startUpdatingLocation()
        self.locationManager.delegate = self
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "changePassword", sender: self)
    }
    
    func documentMasterID (user_id:String)
    {
        let functionName = "apimain/document_master_list/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": user_id]
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    print(response)
                    //let JSON = response.result.value as? [String: Any]
                    let json = JSON(response.result.value as Any)
                    let msg = json["msg"].string
                    let status = json["status"].string
                    if (status == "Sucess")
                    {
                        //let doc_data = json["doc_data"]
                        UserDefaults.standard.set("Aadhaar Card", forKey: "documentAdhar")
                        UserDefaults.standard.set("1", forKey: "adharId")
                        
                        UserDefaults.standard.set("Educational Document", forKey: "documentEducational")
                        UserDefaults.standard.set("2", forKey: "educationalId")
                        
                        UserDefaults.standard.set("Community Document", forKey: "documentCommunity")
                        UserDefaults.standard.set("3", forKey: "communityId")
                        
                        UserDefaults.standard.set("Ration Card", forKey: "documentRation")
                        UserDefaults.standard.set("4", forKey: "rationId")
                        
                        UserDefaults.standard.set("Voter ID", forKey: "documentVoter")
                        UserDefaults.standard.set("5", forKey: "voterId")
                        
                        UserDefaults.standard.set("Job Card", forKey: "documentJobcard")
                        UserDefaults.standard.set("6", forKey: "jobcardId")
                        
                        UserDefaults.standard.set("Differently Aabled Card", forKey: "documentDifferentlyAbled")
                        UserDefaults.standard.set("7", forKey: "differentlyAbledId")
                        
                        UserDefaults.standard.set("Bank Pass Book", forKey: "documentBankPassBook")
                        UserDefaults.standard.set("8", forKey: "bankPassBookId")

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
