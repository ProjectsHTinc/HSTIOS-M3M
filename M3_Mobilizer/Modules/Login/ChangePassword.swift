//
//  ChangePassword.swift
//  M3_Mobilizer
//
//  Created by Happy Sanz Tech on 07/01/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import ReachabilitySwift

class ChangePassword: UIViewController,UITextFieldDelegate {
    
    let reachability = Reachability()
    var networkConnectionFrom = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.userName.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
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
        switch reachability.currentReachabilityStatus
        {
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

    @IBOutlet weak var userName: UITextField!
    
    @IBAction func submitAction(_ sender: Any)
    {
        if self.userName.text == ""
        {
            AlertController.shared.showAlert(targetVC: self, title: "M3", message: "username cannot be empty" , complition: {

            })
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
            self.changePassword(username: self.userName.text!)
        }
    }
    
    func changePassword (username:String)
    {
        let functionName = "apimain/forgot_password/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_name": username]
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    print(response)
                    let JSON = response.result.value as? [String: Any]
                    let msg = JSON?["msg"] as? String
                    if (msg == "Password Updated")
                    {
                         AlertController.shared.showAlert(targetVC: self, title: "M3", message: msg!, complition: {
                            self.userName.text = ""
                         })
                    }
                    else
                    {
                        AlertController.shared.showAlert(targetVC: self, title: "M3", message: msg!, complition: {

                        })
                    }
                    break
                case .failure(let error):
                    print(error)
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
