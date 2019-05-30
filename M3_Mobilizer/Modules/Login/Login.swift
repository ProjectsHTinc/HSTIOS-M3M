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
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() == true {
            
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied ||  CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.activityType = .automotiveNavigation
            locationManager.delegate = self

        } else {
            print("PLease turn on location services or GPS")
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        locationManager.stopUpdatingLocation()
        
        locationManager.delegate = nil

        
        if locationFixAchieved == false
        {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            print(startLocation)
            userLive_Latitude = userLocation.coordinate.latitude
            userLive_Longitude = userLocation.coordinate.longitude
            startLocation = CLLocation(latitude: userLive_Latitude!, longitude: userLive_Longitude!)
            locationFixAchieved = true
            locationName ()
        }
        else
        {
            lastLocation = CLLocation(latitude:userLocation.coordinate.latitude , longitude: userLocation.coordinate.longitude)
            print(lastLocation)
            let distanceMeters: CLLocationDistance  = (startLocation.distance(from: lastLocation))
            print("distance = \(distanceMeters)")
            let decimalToInt = Int(distanceMeters)
            print("distance = \(decimalToInt)")
            if 30 < decimalToInt
            {
                userLive_Latitude = userLocation.coordinate.latitude
                userLive_Longitude = userLocation.coordinate.longitude
                startLocation = CLLocation(latitude:userLocation.coordinate.latitude , longitude: userLocation.coordinate.longitude)
                locationName ()
            }
            
//            self.locationManager.startUpdatingLocation()
//            self.locationManager.delegate = self
        }
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
        else
        {
            let functionName = "apimain/login/"
            let baseUrl = Baseurl.baseUrl + functionName
            let url = URL(string: baseUrl)!
            let parameters: Parameters = ["user_name": name!, "password": password!, "mobile_type": "2", "device_id": "23423423423"]
            Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
                {
                    response in
                    switch response.result
                    {
                    case .success:
                        print(response)
                        let JSON = response.result.value as? [String: Any]
                        let msg = JSON?["msg"] as? String
                        if (msg == "User loggedIn successfully")
                        {
                         
                            self.startupdatinguserLocation ()
                            // Mark : Parseing userData
                            let userData = JSON?["userData"] as? NSDictionary
                            GlobalVariables.user_id = (userData!["user_id"] as! String)
                            GlobalVariables.name = (userData!["name"] as! String)
                            GlobalVariables.user_name = (userData!["user_name"] as! String)
                            GlobalVariables.user_pic = (userData!["user_pic"] as! String)
                            GlobalVariables.user_type = (userData!["user_type"] as! String)
                            GlobalVariables.user_type_name = (userData!["user_type_name"] as! String)
                            
                            let staffProfile = JSON?["staffProfile"] as? NSDictionary
                            GlobalVariables.staff_address = (staffProfile!["address"] as! String)
                            GlobalVariables.staff_age = String(format: "%@",staffProfile!["age"] as! CVarArg)
                            GlobalVariables.staff_community = (staffProfile!["community"] as! String)
                            GlobalVariables.staff_name = (staffProfile!["community_class"] as! String)
                            GlobalVariables.staff_email = (staffProfile!["email"] as! String)
                            GlobalVariables.staff_name = (staffProfile!["name"] as! String)
                            GlobalVariables.staff_nationality = (staffProfile!["nationality"] as! String)
                            GlobalVariables.staff_phone = String(format: "%@",staffProfile!["phone"] as! CVarArg)
                            GlobalVariables.pia_id = String(format: "%@",staffProfile!["pia_id"] as! CVarArg)
                            GlobalVariables.staff_qualification = (staffProfile!["qualification"] as! String)
                            GlobalVariables.staff_religion = (staffProfile!["religion"] as! String)
                            GlobalVariables.staff_role_type = String(format: "%@",staffProfile!["role_type"] as! CVarArg)
                            GlobalVariables.staff_sex = (staffProfile!["sex"] as! String)
                            GlobalVariables.staff_staff_id = String(format: "%@",staffProfile!["staff_id"] as! CVarArg)
                            
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
                
//                // Location name
                if let locationName = placeMark.locality {
                    print(locationName)
                }
                // Street address
                if let street = placeMark.subLocality {
                    print(street)
                    
                   self.streetName = String(format: "%@",street)
                    
                   self.webReqLocation ()
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
}
