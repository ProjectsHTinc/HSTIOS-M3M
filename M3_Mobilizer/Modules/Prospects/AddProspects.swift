//
//  AddProspects.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 12/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import ReachabilitySwift


class AddProspects: UIViewController {
    
    let reachability = Reachability()
    var networkConnectionFrom = String()

    @IBOutlet weak var adharOulet: UIButton!
    
    @IBOutlet weak var candidateOutlet: UIButton!
    
    @IBAction func adharButton(_ sender: Any)
    {
        if networkConnectionFrom == ""
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
            UserDefaults.standard.set("fromadharView", forKey: "View") //setObject
            self.performSegue(withIdentifier: "qrScanner", sender: self)
        }
    }
    
    @IBAction func candidateButton(_ sender: Any)
    {
        GlobalVariables.studentname = ""
        GlobalVariables.dob = ""
        GlobalVariables.aadhaar_card_number = ""
        GlobalVariables.father_name = ""
        GlobalVariables.sex = ""
        GlobalVariables.address = ""
        GlobalVariables.state = ""
        GlobalVariables.city = ""
        GlobalVariables.pincode = ""
        UserDefaults.standard.set("fromaddprospectView", forKey: "View") //setObject
        self.performSegue(withIdentifier: "candidateform", sender: self)
    }
    
    @IBAction func backButton(_ sender: Any)
    {
       self.performSegue(withIdentifier: "to_Dashboard", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        adharOulet.layer.cornerRadius = 4
        
        candidateOutlet.layer.cornerRadius = 4
        
        self.title = "Add Candidate"
        
        self.view.backgroundColor = UIColor.white
      //  navigationLetfButton ()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    
    
    
//    func navigationLetfButton ()
//    {
//        let navigationLetfButton = UIButton(type: .custom)
//        navigationLetfButton.setImage(UIImage(named: "back-01"), for: .normal)
//        navigationLetfButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        navigationLetfButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
//        let navigationButton = UIBarButtonItem(customView: navigationLetfButton)
//        self.navigationItem.setLeftBarButton(navigationButton, animated: true)
//    }
//     @objc func clickButton()
//    {
//      //self.performSegue(withIdentifier: "back_List", sender: self)
//        self.dismiss(animated: true, completion: nil)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
