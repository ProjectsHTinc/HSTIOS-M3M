//
//  SyncController.swift
//  M3_Mobilizer
//
//  Created by Happy Sanz Tech on 01/02/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import ReachabilitySwift

class SyncController: UIViewController {
    
    let reachability = Reachability()
    var networkConnectionFrom = String()
    var databasePath = String()
    var locationrowCount = Int()
    var prospectRowCount = Int()
    var student_id = ""
    var userImage = [UIImage]()
    var imageName = String()
    
    var timer = Timer()
    var prospectTimer = Timer()
    
    var documentRowCount = Int()


    @IBOutlet weak var valueToShow: UILabel!
    @IBOutlet weak var prospectValueToShow: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getremainingDataToSync ()
        self.getRowCountForProspectsData ()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(getremainingDataToSync), userInfo: nil, repeats: true)
        prospectTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(getRowCountForProspectsData), userInfo: nil, repeats: true)

    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
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
    
    @objc func reachabilityChanged(note: Notification) {

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
    

    @IBAction func syncAction(_ sender: Any)
    {
        if networkConnectionFrom == "No Connection"
        {
            let alertController = UIAlertController(title: "M3", message: "Need network connection to sync", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            self.uplodaValuestoServer()
        }
    }
    
    @objc func getremainingDataToSync ()
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
            let rs = try database.executeQuery("select count(*) as count from Create_location_store_data WHERE sync_status = ?", values:["N"])
            while rs.next() {
              locationrowCount = Int(rs.int(forColumn: "Count"))
              self.valueToShow.text = String(locationrowCount)
              print(locationrowCount)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
        }

        database.close()
    }
    
    
    func uplodaValuestoServer ()
    {
        if locationrowCount != 0
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
                let rs = try database.executeQuery("SELECT ID, user_id, lat, lon, location, dateandtime, distance, pia_id, gps_status, server_id, sync_status FROM Create_location_store_data WHERE sync_status = '\("N")' ORDER BY ID LIMIT 1", values: nil)
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
                    print(gps_status as Any,server_id as Any)
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
                         let alertController = UIAlertController(title: "M3", message: "No Data to SYNC", preferredStyle: .alert)
                         let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                 print("You've pressed default");
                         }
                         alertController.addAction(action1)
                         self.present(alertController, animated: true, completion: nil)
                    }

                }
            } catch {
                print("failed: \(error.localizedDescription)")
            }

            database.close()
        }
        else
        {
           let alertController = UIAlertController(title: "M3", message: "No data to SYNC", preferredStyle: .alert)
           let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
               print("You've pressed default");
           }
           alertController.addAction(action1)
           self.present(alertController, animated: true, completion: nil)
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
            self.uplodaValuestoServer ()
        } catch {
            print("failed: \(error.localizedDescription)")
        }

        database.close()
    }
    
    @IBAction func prospectsAction(_ sender: Any)
    {
        if networkConnectionFrom == "No Connection"
        {
            let alertController = UIAlertController(title: "M3", message: "Need network connection to sync", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            self.uploadProspectDatatoServer()
        }
    }
    
    @objc func getRowCountForProspectsData ()
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
            let rs = try database.executeQuery("select count(*) as count from Prospects_data_storage WHERE sync_status = ?", values: ["N"])
            while rs.next() {
                prospectRowCount = Int(rs.int(forColumn: "Count"))
                self.prospectValueToShow.text = String(prospectRowCount)
                print(prospectRowCount)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
        }

        database.close()
    }
    
    func uploadProspectDatatoServer ()
    {
        if prospectRowCount != 0
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
                    let rs = try database.executeQuery("select ID, user_id, pia_id, name, sex, dob, age, nationality, religion, community_class, community, blood_group, father_name, mother_name, mobile, sec_mobile, email, qualification, degree, qualifiedPromotion, LastStudied, yearOfEducation, yearOfPassing, identificationMarkOne, identificationMarkTwo, headOfFamily, highestEducationQualification, fatherMobileNumber, motherMobileNumber, yearlyIncome, motherTonque, languagesKnown, numbOfFamilyMembers, state, city, addressOne, addressTwo, disability, preferred_trade, aadhaar_card_number, jobcard, admission_date, admission_location, admission_latitude, admission_longitude, status, created_at, created_by, prospectImage, gps_status, sync_status FROM Prospects_data_storage WHERE sync_status = '\("N")' ORDER BY ID LIMIT 1", values: nil)
                    
                    while rs.next() {
                    let primaryId = rs.string(forColumn: "ID")
                    let userid = rs.string(forColumn: "user_id")
                    let aadhaar_card_number = rs.string(forColumn: "aadhaar_card_number")
                    let name = rs.string(forColumn: "name")
                    let sex = rs.string(forColumn: "sex")
                    let nationality = rs.string(forColumn: "nationality")
                    let age = rs.string(forColumn: "age")
                    let dob = rs.string(forColumn: "dob")
                    let pia_id = rs.string(forColumn: "pia_id")
                    let religion = rs.string(forColumn: "religion")
                    let community_class = rs.string(forColumn: "community_class")
                    let community = rs.string(forColumn: "community")
                    let father_name = rs.string(forColumn: "father_name")
                    let mother_name = rs.string(forColumn: "mother_name")
                    let mobile = rs.string(forColumn: "mobile")
                    let sec_mobile = rs.string(forColumn: "sec_mobile")
                    let email = rs.string(forColumn: "email")
                    let state = rs.string(forColumn: "state")
                    let city = rs.string(forColumn: "city")
                    let address = rs.string(forColumn: "addressOne")
                    let mother_tongue = rs.string(forColumn: "motherTonque")
                    let disability = rs.string(forColumn: "disability")
                    let blood_group = rs.string(forColumn: "blood_group")
                    let admission_date = rs.string(forColumn: "admission_date")
                    let admission_location = rs.string(forColumn: "admission_location")
                    let preferred_trade = rs.string(forColumn: "preferred_trade")
                    let admission_latitude = rs.string(forColumn: "admission_latitude")
                    let admission_longitude = rs.string(forColumn: "admission_longitude")
//                  let transfer_certificate = rs.string(forColumn: "transfer_certificate")
                    let status = rs.string(forColumn: "status")
                    let created_at = rs.string(forColumn: "created_at")
                    let created_by = rs.string(forColumn: "created_by")
                    let gps_status = rs.string(forColumn: "gps_status")
                
                    let qualification = rs.string(forColumn: "qualification")
                    let degree = rs.string(forColumn: "degree")
                    let qualifiedPromotion = rs.string(forColumn: "qualifiedPromotion")
                    let LastStudied = rs.string(forColumn: "LastStudied")
                    let yearOfEducation = rs.string(forColumn: "yearOfEducation")
                    let yearOfPassing = rs.string(forColumn: "yearOfPassing")
                    let identificationMarkOne = rs.string(forColumn: "identificationMarkOne")
                    let identificationMarkTwo = rs.string(forColumn: "identificationMarkTwo")
                    let headOfFamily = rs.string(forColumn: "headOfFamily")
                    let highestEducationQualification = rs.string(forColumn: "highestEducationQualification")
                    let fatherMobileNumber = rs.string(forColumn: "fatherMobileNumber")
                    let motherMobileNumber = rs.string(forColumn: "motherMobileNumber")
                    let yearlyIncome = rs.string(forColumn: "yearlyIncome")
                    let languagesKnown = rs.string(forColumn: "languagesKnown")
                    let numbOfFamilyMembers = rs.string(forColumn: "numbOfFamilyMembers")
                    let jobcard = rs.string(forColumn: "jobcard")

                    let sync_status = rs.string(forColumn: "sync_status")
                    let strBase64 = rs.string(forColumn: "prospectImage") ?? ""
                        

                    print(gps_status as Any,sync_status as Any)
                    if sync_status == "N"
                    {
                        let functionName = "apimobilizer/add_student"
                        let baseUrl = Baseurl.baseUrl + functionName
                        let url = URL(string: baseUrl)!
                        let parameters: Parameters = ["user_id": userid!, "pia_id": pia_id!, "name": name!, "sex": sex!, "dob":dob!, "age": age!, "nationality": nationality!, "religion": religion!, "community_class": community_class!, "community": community!, "blood_group": blood_group!,  "father_name": father_name!, "mother_name": mother_name!, "mobile": mobile!, "sec_mobile": sec_mobile!, "email": email!, "qualification": qualification!, "qualification_details": degree!, "qualified_promotion": qualifiedPromotion!, "last_studied": LastStudied!,"year_of_edu": yearOfEducation!, "year_of_pass": yearOfPassing!, "identification_mark_1": identificationMarkOne!, "identification_mark_2": identificationMarkTwo!, "head_family_name": headOfFamily!, "head_family_edu": highestEducationQualification!, "no_family": numbOfFamilyMembers!, "mother_tongue": mother_tongue!, "lang_known": languagesKnown!, "yearly_income": yearlyIncome!, "father_mobile": fatherMobileNumber!, "mother_mobile": motherMobileNumber!, "jobcard_type": jobcard!, "state": state!, "city": city!, "address": address!, "disability": disability!, "aadhaar_card_number": aadhaar_card_number!, "admission_date": admission_date!, "admission_location": admission_location!, "preferred_trade": preferred_trade!, "admission_latitude": admission_latitude!, "admission_longitude": admission_longitude!, "status": status!, "created_at": created_at!,"created_by": created_by!]

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
                                    self.updateProspectPreviousValueinDb(primaryid: primaryId!)
                                    self.student_id = String(format: "%@",JSON?["admission_id"] as! CVarArg)
                                    if strBase64 != ""
                                    {
                                        self.webRequest_Image (imageData:strBase64, studentId: self.student_id, primaryID: primaryId!)
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
//                           else
//                           {
//                                let alertController = UIAlertController(title: "M3", message: "No Data to SYNC", preferredStyle: .alert)
//                                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
//                                        print("You've pressed default");
//                                }
//                                alertController.addAction(action1)
//                                self.present(alertController, animated: true, completion: nil)
//                           }
                        }
                    }
            catch {
                print("failed: \(error.localizedDescription)")
            }
            database.close()
        }
    }
    
    func webRequest_Image (imageData:String,studentId:String,primaryID:String)
    {
      let dataDecoded = NSData(base64Encoded: imageData, options: .ignoreUnknownCharacters)
      let decodedimage = UIImage(data: dataDecoded! as Data)
      let imgdata = decodedimage!.jpegData(compressionQuality: 0.50)
      if imgdata != nil
      {
        let functionName = "apimobilizer/student_picupload/"
        let baseUrl = Baseurl.baseUrl + functionName + studentId
        let url = URL(string: baseUrl)!
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgdata!, withName: "student_pic",fileName: "file.jpg", mimeType: "image/jpg")
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
                        self.getRowCountForDocuments(studentId: primaryID)
                        //self.performSegue(withIdentifier: "back_selectPage", sender: self)

                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
      }
    }
    
    func getRowCountForDocuments (studentId:String)
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
            let rs = try database.executeQuery("select count(*) as count from Documents_storage WHERE prospect_id = ? and sync_status = ?", values: [studentId,"N"])
            while rs.next() {
                documentRowCount = Int(rs.int(forColumn: "Count"))
                print(documentRowCount)
                if documentRowCount != 0
                {
                    self.updateDocumentsToServer(studentId:studentId)
                }
            }
        } catch {
            print("failed: \(error.localizedDescription)")
        }

        database.close()
    }
    
    func updateDocumentsToServer (studentId:String)
    {
        if documentRowCount != 0
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
                    let rs = try database.executeQuery("select ID, user_id, prospect_id, document_master_id, document_Data, proofNumber, sync_status FROM Documents_storage WHERE sync_status = '\("N")' and prospect_id = '\(studentId)' ORDER BY ID LIMIT 1", values: nil)
                    
                    while rs.next() {
                    let primaryId = rs.string(forColumn: "ID")
                    let user_id = rs.string(forColumn: "user_id")
                    let prospect_id = rs.string(forColumn: "prospect_id")
                    let document_master_id = rs.string(forColumn: "document_master_id")
                    let sync_status = rs.string(forColumn: "sync_status")
                    let strBase64 = rs.string(forColumn: "document_Data") ?? ""
                    print(sync_status as Any)
                    if sync_status == "N"
                    {
                        let dataDecoded = NSData(base64Encoded: strBase64, options: .ignoreUnknownCharacters)
                        self.updateDocumentMain(primaryId: primaryId!, user_id: user_id!, prospect_id: prospect_id!, document_master_id: document_master_id!, strBase64: dataDecoded! as Data)
                    }
                }
                    }
            catch {
                print("failed: \(error.localizedDescription)")
            }
            database.close()
        }
    }
    
    func updateDocumentMain (primaryId:String,user_id:String,prospect_id:String,document_master_id:String,strBase64:Data)
    {
        if !strBase64.isEmpty
        {
          let functionName = "apimobilizer/document_details_upload/"
          let baseUrl = Baseurl.baseUrl + functionName +  user_id + "/"
                         + document_master_id + "/" + self.student_id + "/" + document_master_id + "/" + document_master_id
          let url = URL(string: baseUrl)!
          
          Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(strBase64, withName: "upload_document",fileName: "test.pdf", mimeType: "application/pdf")
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
//                      self.updatePreviousDocumentValues (primaryid:primaryId)
                    self.updatePreviousDocumentValues (primaryid:primaryId, studentId: prospect_id)
                      if (response.result.value as? NSDictionary) != nil
                      {
//                        self.updatePreviousDocumentValues (primaryid:primaryId, studentId: prospect_id)
                          //self.performSegue(withIdentifier: "back_selectPage", sender: self)
                      }
                  }
                  
              case .failure(let encodingError):
                  print(encodingError)
              }
          }
        }
    }
    
    func updatePreviousDocumentValues (primaryid: String,studentId:String)
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
            let querySQL = "update Documents_storage set sync_status = ? where ID = ?"
            try database.executeUpdate(querySQL, values: ["S", primaryid])
            self.updateDocumentsToServer(studentId: studentId)
        } catch {
            print("failed: \(error.localizedDescription)")
        }

        database.close()
    }
    
    func updateProspectPreviousValueinDb (primaryid: String)
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
            let querySQL = "update Prospects_data_storage set sync_status = ? where ID = ?"
            try database.executeUpdate(querySQL, values: ["S", primaryid])
            self.uploadProspectDatatoServer()
        } catch {
            print("failed: \(error.localizedDescription)")
        }

        database.close()
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
