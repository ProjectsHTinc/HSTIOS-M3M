//
//  Dashboard.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 26/12/18.
//  Copyright © 2018 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SideMenu
import MapKit
import MBProgressHUD
import Alamofire
import CoreLocation
import Foundation
import ReachabilitySwift

class Dashboard: UIViewController,CLLocationManagerDelegate
{ 
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewThree: UIView!
    @IBOutlet weak var viewFour: UIView!
    @IBOutlet weak var viewFive: UIView!
    @IBOutlet weak var studentsLabel: UILabel!
    @IBOutlet weak var centerinfoLabel: UILabel!
    @IBOutlet weak var tradeLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var bell_Image: UIBarButtonItem!
    
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
    var stopLocation = String()
    let reachability = Reachability()
    var distanceBetweenLocations: CLLocationDistance?
    var networkConnectionFrom = String()
    var gps_status = String()
    var lastInsertedID = String()
    var databasePath = String()
    var rowCount = Int()
    var _id = [String]()
    var tradename = [String]()
    var str : String?
    var startTimeloc: Date?
    var tracking_status = String()

    @IBOutlet weak var startTrackingOutlet: UIButton!
    @IBOutlet weak var stopTrackingOutlet: UIButton!
    
    @IBAction func startTrackingAction(_ sender: Any)
    {
        if self.networkConnectionFrom == "WiFi" || self.networkConnectionFrom == "MobileData"
        {
            tracking_status = "Start"
            stopLocation = "No"
            self.startTrackingOutlet.isUserInteractionEnabled = true
            self.startTrackingOutlet.alpha = 0.5
            self.stopTrackingOutlet.isUserInteractionEnabled = true
            self.stopTrackingOutlet.alpha = 1.0
            self.startupdatinguserLocation ()
        }
        else
        {
            tracking_status = "Start"
            stopLocation = "No"
            self.startTrackingOutlet.isUserInteractionEnabled = true
            self.startTrackingOutlet.alpha = 0.5
            self.stopTrackingOutlet.isUserInteractionEnabled = true
            self.stopTrackingOutlet.alpha = 1.0
            self.startupdatinguserLocation ()
        }
    }
    
    @IBAction func stopTrackingAction(_ sender: Any)
    {
        if self.networkConnectionFrom == "WiFi" || self.networkConnectionFrom == "MobileData"
        {
            tracking_status = "Stop"
            stopLocation = "YES"
            self.startTrackingOutlet.isUserInteractionEnabled = true
            self.startTrackingOutlet.alpha = 1.0
            self.stopTrackingOutlet.isUserInteractionEnabled = true
            self.stopTrackingOutlet.alpha = 0.5
            self.locationManager.stopUpdatingLocation()
            self.locationManager.delegate = nil
        }
        else
        {
            tracking_status = "Stop"
            stopLocation = "YES"
            self.startTrackingOutlet.isUserInteractionEnabled = true
            self.startTrackingOutlet.alpha = 1.0
            self.stopTrackingOutlet.isUserInteractionEnabled = true
            self.stopTrackingOutlet.alpha = 0.5
            self.locationManager.stopUpdatingLocation()
            self.locationManager.delegate = nil
        }
        //self.stopTimerTest()
    }
    
    @IBAction func addCandidate(_ sender: Any)
    {
        UserDefaults.standard.set("YES", forKey: "fromDashboard")
        self.performSegue(withIdentifier: "addProspects", sender: self)
    }
    
    @IBAction func prospectsButton(_ sender: Any)
    {
        if networkConnectionFrom == "No Connection"
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
            UserDefaults.standard.set("YES", forKey: "fromDashboard")
            self.performSegue(withIdentifier: "dashbaord_Prospects", sender: self)
        }
    }
    
    @IBAction func centerInfoButton(_ sender: Any)
    {
        if networkConnectionFrom == "No Connection"
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
            UserDefaults.standard.set("YES", forKey: "fromDashboard")
            self.performSegue(withIdentifier: "dashboard_Center", sender: self)
        }

    }
    
    @IBAction func tradeButton(_ sender: Any)
    {
        if networkConnectionFrom == "No Connection"
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
            UserDefaults.standard.set("false", forKey: "fromCenterDetail")
            UserDefaults.standard.set("YES", forKey: "fromDashboard")
            self.performSegue(withIdentifier: "dashboard_Trade", sender: self)
        }
    }
    
    @IBAction func taskButton(_ sender: Any)
    {
        if networkConnectionFrom == "No Connection"
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
            UserDefaults.standard.set("YES", forKey: "fromDashboard")
            self.performSegue(withIdentifier: "dashboard_task", sender: self)
        }

    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "DashBoard"
        NavigationBarTitleColor.navbar_TitleColor
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationLeftButton ()
        roundedCorners ()
        setupSideMenu()
        loadValues ()
        
        // For use when the app is open & in the background
        //locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() == true
        {
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied ||  CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = true
            locationManager.activityType = .automotiveNavigation
            locationManager.delegate = self
        }
        else
        {
            print("Please turn on location services or GPS")
        }
        
        self.stopTrackingOutlet.isUserInteractionEnabled = true
        self.stopTrackingOutlet.alpha = 0.5
        //self.livelocTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(webReqLocation), userInfo: nil, repeats: true)
        self.creatingTableForLocalDb ()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        let str = UserDefaults.standard.object(forKey: "FstLoginKey") as! String
        if str == "YES"
        {
            UserDefaults.standard.set("NO", forKey: "FstLoginKey")
            self.getTradeValues()
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
        
        GlobalVariables.name = UserDefaults.standard.object(forKey: "name") as? String
        GlobalVariables.user_name =  UserDefaults.standard.object(forKey: "user_name") as? String
        GlobalVariables.user_pic =  UserDefaults.standard.object(forKey: "user_pic") as? String
        GlobalVariables.user_type =  UserDefaults.standard.object(forKey: "user_type") as? String
        GlobalVariables.user_type_name =  UserDefaults.standard.object(forKey: "user_type_name") as? String
        GlobalVariables.user_id =  UserDefaults.standard.object(forKey: "user_id") as? String

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
    
    @objc func reachabilityChanged(note: Notification)
    {
          let reachability = note.object as! Reachability
          switch reachability.currentReachabilityStatus
          {
          case .notReachable:
          print("Network became unreachable")
          networkConnectionFrom = "No Connection"
          gps_status = "N"
          // self.stopTimerTest()
          case .reachableViaWiFi:
          print("Network reachable through WiFi")
          networkConnectionFrom = "WiFi"
          gps_status = "Y"
          // self.startTimerTest()
          case .reachableViaWWAN:
          print("Network reachable through Cellular Data")
          networkConnectionFrom = "MobileData"
          gps_status = "Y"
          // self.startTimerTest()
          }
    }
    
    func navigationLeftButton ()
    {
        if GlobalVariables.user_type_name == "TNSRLM"
        {
            let navigationLeftButton = UIButton(type: .custom)
            navigationLeftButton.setImage(UIImage(named: "back-01"), for: .normal)
            navigationLeftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            navigationLeftButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
            let navigationButton = UIBarButtonItem(customView: navigationLeftButton)
            self.navigationItem.setLeftBarButton(navigationButton, animated: true)
        }
        else
        {
            let navigationLeftButton = UIButton(type: .custom)
            navigationLeftButton.setImage(UIImage(named: "sidemenu_button"), for: .normal)
            navigationLeftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            navigationLeftButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
            let navigationButton = UIBarButtonItem(customView: navigationLeftButton)
            self.navigationItem.setLeftBarButton(navigationButton, animated: true)
        }
    }
    
    @objc func clickButton()
    {
        if GlobalVariables.user_type_name == "TNSRLM"
        {
            self.performSegue(withIdentifier: "deshbaord_PIAList", sender: self)
        }
        else
        {
            present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        }
    }
    
    func loadValues()
    {
//        mobiliserLabel.text = "Mobiliser" + " " + "-" +  " " + GlobalVariables.mobilizer_count!
//        centerinfoLabel.text = "Center Information" + " " + "-" +  " " + GlobalVariables.center_count!
//        studentsLabel.text = "Students" + " " + "-" +  " " + GlobalVariables.student_count!
//        taskLabel.text = "Task" + " " + "-" +  " " + GlobalVariables.task_count!
    }
    
    fileprivate func setupSideMenu()
    {
        // Define the menus
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
    }

    fileprivate func roundedCorners ()
    {
        
        viewOne.layer.cornerRadius = 4.0
        viewOne.layer.shadowColor = UIColor.gray.cgColor
        viewOne.layer.shadowOpacity = 2
        viewOne.layer.shadowOffset = CGSize(width: 2, height: 2)
        viewOne.layer.shadowRadius = 3

        viewTwo.layer.cornerRadius = 4.0
        viewTwo.layer.shadowColor = UIColor.gray.cgColor
        viewTwo.layer.shadowOpacity = 2
        viewTwo.layer.shadowOffset = CGSize(width: 2, height: 2)
        viewTwo.layer.shadowRadius = 3

        viewThree.layer.cornerRadius = 4.0
        viewThree.layer.shadowColor = UIColor.gray.cgColor
        viewThree.layer.shadowOpacity = 2
        viewThree.layer.shadowOffset = CGSize(width: 2, height: 2)
        viewThree.layer.shadowRadius = 3

        viewFour.layer.cornerRadius = 4.0
        viewFour.layer.shadowColor = UIColor.gray.cgColor
        viewFour.layer.shadowOpacity = 2
        viewFour.layer.shadowOffset = CGSize(width: 2, height: 2)
        viewFour.layer.shadowRadius = 3

        viewFive.layer.cornerRadius = 4.0
        viewFive.layer.shadowColor = UIColor.gray.cgColor
        viewFive.layer.shadowOpacity = 2
        viewFive.layer.shadowOffset = CGSize(width: 2, height: 2)
        viewFive.layer.shadowRadius = 3
    }
    
    func creatingTableForLocalDb ()
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
             let sql_stmt = "CREATE TABLE IF NOT EXISTS Create_location_store_data (ID INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT, lat TEXT, lon TEXT, location TEXT, dateandtime TEXT, distance TEXT, pia_id TEXT, tracking_status TEXT, gps_status TEXT, server_id TEXT, sync_status TEXT)"
            
           let prossqlstmt = "CREATE TABLE IF NOT EXISTS Prospects_data_storage (ID INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT, pia_id TEXT, name TEXT, sex TEXT , dob TEXT, age TEXT, nationality TEXT, religion TEXT, community_class TEXT, community TEXT, blood_group TEXT, father_name TEXT, mother_name TEXT, mobile TEXT, sec_mobile TEXT, email TEXT, qualification TEXT, degree TEXT, qualifiedPromotion TEXT, LastStudied TEXT, yearOfEducation TEXT, yearOfPassing TEXT, identificationMarkOne TEXT, identificationMarkTwo TEXT, headOfFamily TEXT, highestEducationQualification TEXT, fatherMobileNumber TEXT, motherMobileNumber TEXT, yearlyIncome TEXT, motherTonque TEXT, languagesKnown TEXT, numbOfFamilyMembers TEXT, state TEXT, city TEXT, addressOne TEXT, addressTwo TEXT, disability TEXT, preferred_trade TEXT, aadhaar_card_number TEXT, jobcard TEXT, admission_date TEXT, admission_location TEXT, admission_latitude TEXT, admission_longitude TEXT, status TEXT, created_at TEXT, created_by TEXT, prospectImage BOLB, gps_status TEXT, sync_status TEXT)"
            
           let documentsqlstmt = "CREATE TABLE IF NOT EXISTS Documents_storage (ID INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT, prospect_id TEXT, document_master_id TEXT, document_name TEXT, document_Data TEXT, proofNumber TEXT, gps_status TEXT, sync_status TEXT)"
            
            try database.executeUpdate(sql_stmt, values: nil)
            try database.executeUpdate(prossqlstmt, values: nil)
            try database.executeUpdate(documentsqlstmt, values: nil)

        }
        catch {
            print("failed: \(error.localizedDescription)")
        }

        database.close()
    }
        
    func insertValuestoTable ()
    {
        print(self.tracking_status)
        let dateformatter4 = DateFormatter()
        dateformatter4.dateFormat = "yyyy-MM-dd h:mm:ss"
        let now = Date()
        let date_time = dateformatter4.string(from: now)
        
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("test.sqlite")

        let database = FMDatabase(url: fileURL)

        guard database.open() else {
            print("Unable to open database")
            return
        }

        do {
            let insertSQL = "INSERT INTO Create_location_store_data (user_id, lat, lon, location, dateandtime, distance, pia_id, tracking_status, gps_status, server_id, sync_status) VALUES (?,?,?,?,?,?,?,?,?,?,?)"
            try database.executeUpdate(insertSQL, values: [GlobalVariables.user_id!, userLive_Latitude ?? "", userLive_Longitude ?? "", self.streetName, date_time, self.distanceBetweenLocations ?? "", GlobalVariables.pia_id!, self.tracking_status, self.gps_status, "SDE", "N"])
        } catch {
            print("failed: \(error.localizedDescription)")
        }

        database.close()
        
        if self.networkConnectionFrom == "WiFi" || self.networkConnectionFrom == "MobileData"
        {
            self.webReqLocation()
        }
    }
    
    func stopTimerTest() {
      livelocTimer?.invalidate()
      livelocTimer = nil
    }
    
    func startTimerTest ()
    {
        self.livelocTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(webReqLocation), userInfo: nil, repeats: true)
        livelocTimer.fire()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
        {
            let userLocation:CLLocation = locations.last! as CLLocation
//          let time = userLocation.timestamp
//          guard var startTime = startTime else {
//                self.startTime = time // Saving time of first location, so we could use it to compare later with second location time.
//                return //Returning from this function, as at this moment we don't have second location.
//           }
//           let elapsed = time.timeIntervalSince(startTime) // Calculating time interval between first and second (previously saved) locations timestamps.
            
            if stopLocation == "No"
            {
                if locationFixAchieved == false
                {

                    print(startLocation)
                    userLive_Latitude = userLocation.coordinate.latitude
                    userLive_Longitude = userLocation.coordinate.longitude
                    print(userLive_Latitude as Any,userLive_Longitude as Any)
                    startLocation = CLLocation(latitude: userLive_Latitude!, longitude: userLive_Longitude!)
                    self.distanceBetweenLocations = 0.0
                    locationFixAchieved = true
                    locationName ()
                    print(startLocation)
                }
                else
                {
                    lastLocation = CLLocation(latitude:userLocation.coordinate.latitude , longitude: userLocation.coordinate.longitude)
                    print(lastLocation)
                    let distanceMeters: CLLocationDistance  = (startLocation.distance(from: lastLocation))
                    self.distanceBetweenLocations =  distanceMeters
//                    print("distance = \(distanceMeters)")
                    let decimalToInt = Int(distanceMeters)
                    print("distance1 = \(decimalToInt)")
//                  if 35 < decimalToInt
//                  {
//                     if elapsed > 30 {
                       //If time interval is more than 30 seconds
                            if (50..<100).contains(decimalToInt)
                            {
                                print("Upload updated location to server")
//                              startTime = time //Changing our timestamp of previous location to timestamp of location we already uploaded.
                                self.distanceBetweenLocations =  distanceMeters
                                print("distance2 = \(decimalToInt)")
                                userLive_Latitude = userLocation.coordinate.latitude
                                userLive_Longitude = userLocation.coordinate.longitude
                                startLocation = CLLocation(latitude:userLocation.coordinate.latitude , longitude:userLocation.coordinate.longitude)
                                locationName ()
                            }
//                        }
//                    }
                }
            }
            else
            {
                tracking_status = "Stop"
                self.locationManager.stopUpdatingLocation()
                self.locationManager.delegate = nil
            }
        }
    
    func startupdatinguserLocation ()
    {
        self.locationManager.startUpdatingLocation()
    }
    
    func locationName ()
    {
        if networkConnectionFrom == "No Connection"
        {
            //self.storeValuesinLocalDatabase()
            self.insertValuestoTable ()
        }
        else
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
                        if self.networkConnectionFrom == "WiFi" || self.networkConnectionFrom == "MobileData"
                        {
                            self.streetName = String(format: "%@",street)
                            self.insertValuestoTable ()
                        }
                        else
                        {
                            self.insertValuestoTable ()
                        }
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
    }
    
    @objc func webReqLocation ()
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
            let rs = try database.executeQuery("select count(*) as count from Create_location_store_data WHERE sync_status = ?", values: ["N"])
            while rs.next() {
                rowCount = Int(rs.columnCount)
                print(rowCount)
            }
            if rowCount > 0
            {
                let rs = try database.executeQuery("SELECT ID, user_id, lat, lon, location, dateandtime, distance, pia_id, zdd, gps_status, server_id, sync_status FROM Create_location_store_data WHERE sync_status = '\("N")' ORDER BY ID LIMIT 1", values: nil)
                while rs.next() {
                let primaryId = rs.string(forColumn: "ID")
                let userid = rs.string(forColumn: "user_id")
                let pia_id = rs.string(forColumn: "pia_id")
                let latitude = rs.string(forColumn: "lat")
                let longitude = rs.string(forColumn: "lon")
                let location = rs.string(forColumn: "location")
                let miles = rs.string(forColumn: "distance")
                let location_datetime = rs.string(forColumn: "dateandtime")
                let gps_status = rs.string(forColumn: "gps_status")
                let sync_status = rs.string(forColumn: "sync_status")
                let server_id = rs.string(forColumn: "server_id")
                let trackStatus = rs.string(forColumn: "tracking_status")
                if trackStatus == "Start"
                {
                    tracking_status = ""
                    self.startStopAction(user_id: userid!, pia_id: pia_id!, latitude: latitude!, longitude: longitude!, location: location!, miles: miles!, location_datetime: location_datetime!, tracking_status: trackStatus!)
                }
                else if trackStatus == "Stop"
                {
                    tracking_status = ""
                    self.startStopAction(user_id: userid!, pia_id: pia_id!, latitude: latitude!, longitude: longitude!, location: location!, miles: miles!, location_datetime: location_datetime!, tracking_status: trackStatus!)
                }
                print(gps_status as Any,server_id as Any,trackStatus!)
                if sync_status == "N"
                {
                    let functionName = "apimobilizer/add_mobilocation/"
                    let baseUrl = Baseurl.baseUrl + functionName
                    let url = URL(string: baseUrl)!
                    let parameters: Parameters = ["user_id": userid!, "pia_id":pia_id!, "latitude":latitude!, "longitude":longitude!, "location":location!, "miles":miles!,"location_datetime": location_datetime!]
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
                                    self.updatePreviousValueinDB (primaryid:primaryId!)
                                    self.callLocation ()
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
        }
        catch {
            print("failed: \(error.localizedDescription)")
        }

        database.close()
    }
    
    func startStopAction (user_id:String,pia_id:String,latitude:String,longitude:String,location:String,miles:String,location_datetime:String,tracking_status:String)
    {
        let functionName = "apimobilizer/sart_and_stop_tracking/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": user_id, "pia_id":pia_id, "latitude":latitude, "longitude":longitude, "location":location, "miles":miles,"location_datetime": location_datetime, "tracking_status":tracking_status]
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
    
    func updatePreviousValueinDB (primaryid: String)
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
            let querySQL = "update Create_location_store_data set sync_status = ? where ID = ?"
            try database.executeUpdate(querySQL, values: ["S", primaryid])
        } catch {
            print("failed: \(error.localizedDescription)")
        }

        database.close()
        
    }
    
    func callLocation ()
    {
        if stopLocation == "No"
        {
            self.locationManager.startUpdatingLocation()
            self.locationManager.delegate = self
        }
        else
        {
            self.locationManager.stopUpdatingLocation()
            self.locationManager.delegate = nil
        }
       
    }
    
    func webRequestForAttendance ()
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
        
    func getTradeValues ()
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
                        let tradeList = JSON?["Trades"] as? [Any]
                        for i in 0..<(tradeList?.count ?? 0)
                        {
                            let dict = tradeList?[i] as? [AnyHashable : Any]
                            let trade_name = dict?["trade_name"] as? String
                            let trade_id = dict?["id"] as? String
                            
                            self.tradename.append(trade_name ?? "")
                            self._id.append(trade_id ?? "")
                        }
                        UserDefaults.standard.set(self.tradename, forKey: "tradenamesKey")
                        UserDefaults.standard.set(self._id, forKey: "tradeIDKey")
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

