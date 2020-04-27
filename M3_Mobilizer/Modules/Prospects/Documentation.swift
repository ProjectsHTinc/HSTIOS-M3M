//
//  Documentation.swift
//  M3_Mobilizer
//
//  Created by Happy Sanz Tech on 24/03/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import ReachabilitySwift
import MBProgressHUD
import Alamofire
import SwiftyJSON

class Documentation: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    var imagePicker = UIImagePickerController()
    var uploadedImage = UIImage()
    var gps_status = String()
    let reachability = Reachability()
    var networkConnectionFrom = String()
    var prospect_id = String()
    var document_master_id = String()
    var document_name = String()
    var proofNumber = String()
    var buttonName = String()
    var pdfData = String()
    var pdfDataOnline = Data()
    var fromViewController = String()
    var doucmentUpdateId = String()
    
    var documentnameArray = [String]()
    var documentMasterID = [String]()
    var updateId = [String]()
    
    var adharPdfData = String()
    var educationalPdfData = String()
    var communitydfData = String()
    var rationPdfData = String()
    var voterPdfData = String()
    var bplPdfData = String()
    var differentlyPdfData = String()
    var accountNumberPdfData = String()

    var documentsArray = [String]()
    var selectedArray = [String]()
    
    var documentUploadArray = [String]()
    var documentUpdateArra = [String]()
    
    var adharUpdatedId = String()
    var educationalUpdatedId = String()
    var communityUpdatedId = String()
    var rationUpdatedId = String()
    var voterUpdatedId = String()
    var bplUpdatedId = String()
    var differentlyUpdatedId = String()
    var accountNumberUpdatedId = String()
    
  
    @IBOutlet weak var adharBtnOutlet: UIButton!
    @IBOutlet weak var adharImgOutlet: UIButton!
    @IBOutlet weak var certificateBtnOutlet: UIButton!
    @IBOutlet weak var certificateImgOutlet: UIButton!
    @IBOutlet weak var communityBtnOutlet: UIButton!
    @IBOutlet weak var communityImgOutlet: UIButton!
    @IBOutlet weak var rationCardBtnOutlet: UIButton!
    @IBOutlet weak var rationCardImgOutlet: UIButton!
    @IBOutlet weak var voterIdBtnOutlet: UIButton!
    @IBOutlet weak var voterIdImgOutlet: UIButton!
    @IBOutlet weak var bplBtnOutlet: UIButton!
    @IBOutlet weak var bplImgOutlet: UIButton!
    @IBOutlet weak var diffrentlyAbledBtnOutlet: UIButton!
    @IBOutlet weak var diffrentlyAbledImgOutlet: UIButton!
    @IBOutlet weak var accountNumberBtnOutlet: UIButton!
    @IBOutlet weak var accountNumberImgOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Documentation"
        
        adharBtnOutlet.layer.cornerRadius = 5
        adharBtnOutlet.layer.borderWidth = 1
        adharBtnOutlet.layer.borderColor = UIColor.gray.cgColor
        
        certificateBtnOutlet.layer.cornerRadius = 5
        certificateBtnOutlet.layer.borderWidth = 1
        certificateBtnOutlet.layer.borderColor = UIColor.gray.cgColor
        
        communityBtnOutlet.layer.cornerRadius = 5
        communityBtnOutlet.layer.borderWidth = 1
        communityBtnOutlet.layer.borderColor = UIColor.gray.cgColor
        
        rationCardBtnOutlet.layer.cornerRadius = 5
        rationCardBtnOutlet.layer.borderWidth = 1
        rationCardBtnOutlet.layer.borderColor = UIColor.gray.cgColor
        
        voterIdBtnOutlet.layer.cornerRadius = 5
        voterIdBtnOutlet.layer.borderWidth = 1
        voterIdBtnOutlet.layer.borderColor = UIColor.gray.cgColor
        
        bplBtnOutlet.layer.cornerRadius = 5
        bplBtnOutlet.layer.borderWidth = 1
        bplBtnOutlet.layer.borderColor = UIColor.gray.cgColor
        
        diffrentlyAbledBtnOutlet.layer.cornerRadius = 5
        diffrentlyAbledBtnOutlet.layer.borderWidth = 1
        diffrentlyAbledBtnOutlet.layer.borderColor = UIColor.gray.cgColor
        
        accountNumberBtnOutlet.layer.cornerRadius = 5
        accountNumberBtnOutlet.layer.borderWidth = 1
        accountNumberBtnOutlet.layer.borderColor = UIColor.gray.cgColor
        
        self.documentnameArray.removeAll()
        
        fromViewController =  UserDefaults.standard.string(forKey: "View")!
         if fromViewController == "fromstudentView"
         {
            if networkConnectionFrom != "No Connection"
            {
                self.webRequestForDocuments ()
            }
         }
        
        self.navigationBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    func navigationBackButton ()
    {
        let navigationLeftButton = UIButton(type: .custom)
        navigationLeftButton.setImage(UIImage(named: "back-01"), for: .normal)
        navigationLeftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navigationLeftButton.addTarget(self, action: #selector(backButtonclick), for: .touchUpInside)
        let navigationButton = UIBarButtonItem(customView: navigationLeftButton)
        self.navigationItem.setLeftBarButton(navigationButton, animated: true)
    }
    
    @objc func backButtonclick()
    {
        self.performSegue(withIdentifier: "addPage", sender: self)
    }
    
    func webRequestForDocuments ()
    {
        let functionName = "apimain/prospects_document_status/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["prospect_id": GlobalVariables.studentid!]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    print(response)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let JSON = response.result.value as? [String: Any]
                    let msg = JSON?["msg"] as? String
                    let status = JSON?["status"] as? String
                    if (status == "success")
                    {
                        let doc_data = JSON?["doc_status"] as? [Any]
                                               
                        self.documentnameArray.removeAll()
                        self.updateId.removeAll()
                        self.selectedArray.removeAll()

                       for i in 0..<(doc_data?.count ?? 0)
                       {
                           let dict = doc_data?[i] as? [AnyHashable : Any]
                           let doc_name = dict?["doc_name"] as? String
                           let docid = dict?["id"] as? String
                           let selecctdId = dict?["selected"] as? String

                           self.documentnameArray.append(doc_name ?? "")
                           self.updateId.append(docid ?? "")
                           self.selectedArray.append(selecctdId ?? "")

                       }
                    
                        if self.documentnameArray.count != 0
                        {
                            for i in 0..<(self.documentnameArray.count)
                            {
                                let docname = self.documentnameArray[i]
                                let seltID = self.selectedArray[i]
                                
                                if docname == "Aadhaar Card" && seltID != "0"
                                {
                                    self.adharImgOutlet.setBackgroundImage(UIImage(named: "uploadsuccess.png"), for: .normal)
                                    self.adharUpdatedId = self.updateId[i]
                                }
                                else if docname == "Educational Document" && seltID != "0"
                                {
                                    self.certificateImgOutlet.setBackgroundImage(UIImage(named: "uploadsuccess.png"), for: .normal)
                                    self.educationalUpdatedId = self.updateId[i]
                                }
                                else if docname == "Community Document" && seltID != "0"
                                {
                                    self.communityImgOutlet.setBackgroundImage(UIImage(named: "uploadsuccess.png"), for: .normal)
                                    self.communityUpdatedId = self.updateId[i]
                                }
                                else if docname == "Ration Card" && seltID != "0"
                                {
                                    self.rationCardImgOutlet.setBackgroundImage(UIImage(named: "uploadsuccess.png"), for: .normal)
                                    self.rationUpdatedId = self.updateId[i]
                                }
                                else if docname == "Voter ID" && seltID != "0"
                                {
                                    self.voterIdImgOutlet.setBackgroundImage(UIImage(named: "uploadsuccess.png"), for: .normal)
                                    self.voterUpdatedId = self.updateId[i]
                                }
                                else if docname == "Job Card" && seltID != "0"
                                {
                                    self.bplImgOutlet.setBackgroundImage(UIImage(named: "uploadsuccess.png"), for: .normal)
                                    self.bplUpdatedId = self.updateId[i]
                                }
                                else if docname == "Differently Aabled Card" && seltID != "0"
                                {
                                    self.diffrentlyAbledImgOutlet.setBackgroundImage(UIImage(named: "uploadsuccess.png"), for: .normal)
                                    self.differentlyUpdatedId = self.updateId[i]
                                }
                                else if docname == "Bank Pass Book" && seltID != "0"
                                {
                                    self.accountNumberImgOutlet.setBackgroundImage(UIImage(named: "uploadsuccess.png"), for: .normal)
                                    self.accountNumberUpdatedId = self.updateId[i]
                                }
                            }
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
    
    @IBAction func adharImgBtn(_ sender: Any)
    {
        document_name = UserDefaults.standard.object(forKey: "documentAdhar") as! String
        document_master_id = UserDefaults.standard.object(forKey: "adharId") as! String
        self.openImagePicker(sender: adharImgBtn)
    }
    
    @IBAction func certImgBtn(_ sender: Any)
    {
        document_name = UserDefaults.standard.object(forKey: "documentEducational") as! String
        document_master_id = UserDefaults.standard.object(forKey: "educationalId") as! String
        self.openImagePicker(sender: certImgBtn)
    }
    
    @IBAction func communityCertImgBtn(_ sender: Any)
    {
        document_name = UserDefaults.standard.object(forKey: "documentCommunity") as! String
        document_master_id = UserDefaults.standard.object(forKey: "communityId") as! String
        self.openImagePicker(sender: communityCertImgBtn)
    }
    
    @IBAction func rationCardImgBtn(_ sender: Any)
    {
        document_name = UserDefaults.standard.object(forKey: "documentRation") as! String
        document_master_id = UserDefaults.standard.object(forKey: "rationId") as! String
        self.openImagePicker(sender: rationCardImgBtn)
    }
    
    @IBAction func voterIdImgBtn(_ sender: Any)
    {
        document_name = UserDefaults.standard.object(forKey: "documentVoter") as! String
        document_master_id = UserDefaults.standard.object(forKey: "voterId") as! String
        self.openImagePicker(sender: voterIdImgBtn)
    }
    
    @IBAction func bplImgBtn(_ sender: Any)
    {
        document_name = UserDefaults.standard.object(forKey: "documentJobcard") as! String
        document_master_id = UserDefaults.standard.object(forKey: "jobcardId") as! String
        self.openImagePicker(sender: bplImgBtn)
    }
    
    @IBAction func differentlyAbledImgBtn(_ sender: Any)
    {
        document_name = UserDefaults.standard.object(forKey: "documentDifferentlyAbled") as! String
        document_master_id = UserDefaults.standard.object(forKey: "differentlyAbledId") as! String
        self.openImagePicker(sender: differentlyAbledImgBtn)
    }
    
    @IBAction func accountNumberImgBtn(_ sender: Any)
    {
        document_name = UserDefaults.standard.object(forKey: "documentBankPassBook") as! String
        document_master_id = UserDefaults.standard.object(forKey: "bankPassBookId") as! String
        self.openImagePicker(sender: differentlyAbledImgBtn)
    }
    
    func openImagePicker (sender: Any)
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
        let ImageToPdf = self.createPDFDataFromImage(image: self.uploadedImage)

        if document_name == "Aadhaar Card"
        {
          self.adharPdfData = ImageToPdf.base64EncodedString(options: .lineLength64Characters)
          self.adharImgOutlet.setBackgroundImage(UIImage(named: "uploadsuccess.png"), for: .normal)
        }
        else if document_name == "Educational Document"
        {
          self.educationalPdfData = ImageToPdf.base64EncodedString(options: .lineLength64Characters)
          self.certificateImgOutlet.setBackgroundImage(UIImage(named: "uploadsuccess.png"), for: .normal)
        }
        else if document_name == "Community Document"
        {
          self.communitydfData = ImageToPdf.base64EncodedString(options: .lineLength64Characters)
          self.communityImgOutlet.setBackgroundImage(UIImage(named: "uploadsuccess.png"), for: .normal)
        }
        else if document_name == "Ration Card"
        {
          self.rationPdfData = ImageToPdf.base64EncodedString(options: .lineLength64Characters)
          self.rationCardImgOutlet.setBackgroundImage(UIImage(named: "uploadsuccess.png"), for: .normal)
        }
        else if document_name == "Voter ID"
        {
          self.voterPdfData = ImageToPdf.base64EncodedString(options: .lineLength64Characters)
          self.voterIdImgOutlet.setBackgroundImage(UIImage(named: "uploadsuccess.png"), for: .normal)
        }
        else if document_name == "Job Card"
        {
          self.bplPdfData = ImageToPdf.base64EncodedString(options: .lineLength64Characters)
          self.bplImgOutlet.setBackgroundImage(UIImage(named: "uploadsuccess.png"), for: .normal)
        }
        else if document_name == "Differently Aabled Card"
        {
          self.differentlyPdfData = ImageToPdf.base64EncodedString(options: .lineLength64Characters)
          self.diffrentlyAbledImgOutlet.setBackgroundImage(UIImage(named: "uploadsuccess.png"), for: .normal)
        }
        else if document_name == "Bank Pass Book"
        {
          self.accountNumberPdfData = ImageToPdf.base64EncodedString(options: .lineLength64Characters)
          self.accountNumberImgOutlet.setBackgroundImage(UIImage(named: "uploadsuccess.png"), for: .normal)
        }

        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
        
    func createPDFDataFromImage(image: UIImage) -> NSMutableData
    {
        let pdfData = NSMutableData()
        let imgView = UIImageView.init(image: image)
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIGraphicsBeginPDFContextToData(pdfData, imageRect, nil)
        UIGraphicsBeginPDFPage()
        let context = UIGraphicsGetCurrentContext()
        imgView.layer.render(in: context!)
        UIGraphicsEndPDFContext()

        //try saving in doc dir to confirm:
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let path = dir?.appendingPathComponent("file.pdf")

        do {
                try pdfData.write(to: path!, options: NSData.WritingOptions.atomic)
        } catch {
            print("error catched")
        }

        return pdfData
    }
    
    @IBAction func doneAction(_ sender: Any)
    {
        
        if adharPdfData.isEmpty
        {
            let alertController = UIAlertController(title: "M3", message: "Adhar card Document is mandatory", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if educationalPdfData.isEmpty
        {
            let alertController = UIAlertController(title: "M3", message: "Educational Document is mandatory", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if communitydfData.isEmpty
        {
            let alertController = UIAlertController(title: "M3", message: "Community Document is mandatory", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if rationPdfData.isEmpty
        {
            let alertController = UIAlertController(title: "M3", message: "Ration Document is mandatory", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if voterPdfData.isEmpty
        {
            let alertController = UIAlertController(title: "M3", message: "Voter Document is mandatory", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if bplPdfData.isEmpty
        {
            let alertController = UIAlertController(title: "M3", message: "Job Card Document is mandatoryy", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if differentlyPdfData.isEmpty
        {
            let alertController = UIAlertController(title: "M3", message: "Differently abled Document is mandatoryy", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if accountNumberPdfData.isEmpty
        {
            let alertController = UIAlertController(title: "M3", message: "Account Number Document is mandatory", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            if networkConnectionFrom == "No Connection"
            {
                if documentUploadArray.count == 0
                {
                    if !adharPdfData.isEmpty
                    {
                        document_master_id = UserDefaults.standard.object(forKey: "adharId") as! String
                        self.documentUploadArray.append(self.adharPdfData)
                        self.documentMasterID.append(document_master_id)
                    }
                    if !educationalPdfData.isEmpty
                    {
                      document_master_id = UserDefaults.standard.object(forKey: "educationalId") as! String
                      self.documentUploadArray.append(self.educationalPdfData)
                      self.documentMasterID.append(document_master_id)
                    }
                    if !communitydfData.isEmpty
                    {
                      document_master_id = UserDefaults.standard.object(forKey: "communityId") as! String
                      self.documentUploadArray.append(self.communitydfData)
                      self.documentMasterID.append(document_master_id)
                    }
                    if !rationPdfData.isEmpty
                    {
                      document_master_id = UserDefaults.standard.object(forKey: "rationId") as! String
                      self.documentUploadArray.append(self.rationPdfData)
                      self.documentMasterID.append(document_master_id)
                    }
                    if !voterPdfData.isEmpty
                    {
                      document_master_id = UserDefaults.standard.object(forKey: "voterId") as! String
                      self.documentUploadArray.append(self.voterPdfData)
                      self.documentMasterID.append(document_master_id)
                    }
                    if !bplPdfData.isEmpty
                    {
                      document_master_id = UserDefaults.standard.object(forKey: "jobcardId") as! String
                      self.documentUploadArray.append(self.bplPdfData)
                      self.documentMasterID.append(document_master_id)
                    }
                    if !differentlyPdfData.isEmpty
                    {
                      document_master_id = UserDefaults.standard.object(forKey: "differentlyAbledId") as! String
                      self.documentUploadArray.append(self.differentlyPdfData)
                      self.documentMasterID.append(document_master_id)
                    }
                    if !accountNumberPdfData.isEmpty
                    {
                      document_master_id = UserDefaults.standard.object(forKey: "bankPassBookId") as! String
                      self.documentUploadArray.append(self.accountNumberPdfData)
                      self.documentMasterID.append(document_master_id)
                    }
                }
                
                for i in 0..<(documentUploadArray.count)
                {
                    let PdfData = documentUploadArray[i]
                    let docMastId = documentMasterID[i]
                    self.inserDocumentDataToLocalDb (documnetData:PdfData,document_master_id:docMastId)
                }
            }
            else
            {
                if documentUploadArray.count == 0
                {
                    if !adharPdfData.isEmpty
                    {
                        document_master_id = UserDefaults.standard.object(forKey: "adharId") as! String
                        self.documentUploadArray.append(self.adharPdfData)
                        self.documentMasterID.append(document_master_id)
                    }
                    if !educationalPdfData.isEmpty
                    {
                      document_master_id = UserDefaults.standard.object(forKey: "educationalId") as! String
                      self.documentUploadArray.append(self.educationalPdfData)
                      self.documentMasterID.append(document_master_id)
                    }
                    if !communitydfData.isEmpty
                    {
                      document_master_id = UserDefaults.standard.object(forKey: "communityId") as! String
                      self.documentUploadArray.append(self.communitydfData)
                      self.documentMasterID.append(document_master_id)
                    }
                    if !rationPdfData.isEmpty
                    {
                      document_master_id = UserDefaults.standard.object(forKey: "rationId") as! String
                      self.documentUploadArray.append(self.rationPdfData)
                      self.documentMasterID.append(document_master_id)
                    }
                    if !voterPdfData.isEmpty
                    {
                      document_master_id = UserDefaults.standard.object(forKey: "voterId") as! String
                      self.documentUploadArray.append(self.voterPdfData)
                      self.documentMasterID.append(document_master_id)
                    }
                    if !bplPdfData.isEmpty
                    {
                      document_master_id = UserDefaults.standard.object(forKey: "jobcardId") as! String
                      self.documentUploadArray.append(self.bplPdfData)
                      self.documentMasterID.append(document_master_id)
                    }
                    if !differentlyPdfData.isEmpty
                    {
                      document_master_id = UserDefaults.standard.object(forKey: "differentlyAbledId") as! String
                      self.documentUploadArray.append(self.differentlyPdfData)
                      self.documentMasterID.append(document_master_id)
                    }
                    if !accountNumberPdfData.isEmpty
                    {
                      document_master_id = UserDefaults.standard.object(forKey: "bankPassBookId") as! String
                      self.documentUploadArray.append(self.accountNumberPdfData)
                      self.documentMasterID.append(document_master_id)
                    }
                }
                
                
                for i in 0..<(documentUploadArray.count)
                {
                    let pdafData = documentUploadArray[i]
                    let docMastId = documentMasterID[i]
                    if fromViewController == "fromstudentView"
                    {
                        let indexOfA = updateId.index(of: docMastId)
                        let valueOf = selectedArray[indexOfA!]
                        let dataDecoded = NSData(base64Encoded: pdafData, options: .ignoreUnknownCharacters)
                        if  valueOf == "0"
                        {
                           self.SendDataToServer(imgData: dataDecoded! as Data,document_master_id:docMastId)
                        }
                        else
                        {
                           self.updateDataToServer(imgData: dataDecoded! as Data, documentMasterId: docMastId)
                        }
                    }
                    else
                    {
                        let dataDecoded = NSData(base64Encoded: pdafData, options: .ignoreUnknownCharacters)
                        self.SendDataToServer(imgData: dataDecoded! as Data,document_master_id:docMastId)
                    }
                   
                }
                self.performSegue(withIdentifier: "addPage", sender: self)
            }
        }
    }
    
    func inserDocumentDataToLocalDb (documnetData:String,document_master_id:String)
    {
        print(prospect_id)
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("test.sqlite")
        let database = FMDatabase(url: fileURL)
        guard database.open() else {
            print("Unable to open database")
            return
        }
        do {
            
            let insertSQL = "insert into Documents_storage (user_id, prospect_id, document_master_id, document_name, document_Data, proofNumber, gps_status, sync_status) values (?,?,?,?,?,?,?,?)"
            
            try database.executeUpdate(insertSQL, values: [GlobalVariables.user_id!, prospect_id, document_master_id, document_name, documnetData, document_master_id, gps_status, "N"])
                                
            print("Value inserted")
            let alertController = UIAlertController(title: "M3", message: "Data Saved", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
                self.performSegue(withIdentifier: "addPage", sender: self)
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
            
           }
        catch {
             print("failed: \(error.localizedDescription)")
          }

          database.close()
    }
    
    func SendDataToServer (imgData:Data,document_master_id:String)
    {
        if imgData.isEmpty
        {
           print("empty")
        }
        else
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let functionName = "apimobilizer/document_details_upload/"
            let baseUrl = Baseurl.baseUrl + functionName + GlobalVariables.user_id! + "/"
                + document_master_id + "/" + GlobalVariables.studentid! + "/" + document_master_id + "/" + document_master_id
            let url = URL(string: baseUrl)!
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imgData, withName: "upload_document",fileName: "test.pdf", mimeType: "application/pdf")
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
                        //ActivityIndicator().hideActivityIndicator(uiView: self.view)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        if (response.result.value as? NSDictionary) != nil
                        {
                            //self.performSegue(withIdentifier: "to_Documentation", sender: self)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        }
    }
    
    func updateDataToServer (imgData:Data,documentMasterId:String)
    {
        if imgData.isEmpty
        {
           print("empty")
        }
        else
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let functionName = "apimobilizer/document_details_update/"
            let baseUrl = Baseurl.baseUrl + functionName + GlobalVariables.user_id! + "/"
                + documentMasterId + "/" + GlobalVariables.studentid! + "/" + documentMasterId + "/" + documentMasterId
            let url = URL(string: baseUrl)!
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imgData, withName: "upload_document",fileName: "file.jpg", mimeType: "image/jpg")
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
                            
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        }
    }
    
    func find(value searchValue: String, in array: [String]) -> Int?
    {
        for (index, value) in array.enumerated()
        {
            if value == searchValue {
                return index
            }
        }

        return nil
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
