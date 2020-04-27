//
//  ForgotPassword.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 26/12/18.
//  Copyright © 2018 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import SideMenu
import ReachabilitySwift

class ForgotPassword: UIViewController,UITextFieldDelegate
{
    var activeField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    var oldpswrdeyeisClicked = true
    var newpswrdeyeisClicked = true
    let reachability = Reachability()
    var networkConnectionFrom = String()
    
    @IBAction func backAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "M3_Login", bundle: nil)
        let login = storyboard.instantiateViewController(withIdentifier: "login") as! Login
        self.present(login, animated: true, completion: nil)
    }
    
    @IBOutlet var newPawrdOutlet: UIButton!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBAction func newpaswrdButton(_ sender: Any)
    {
        if (newpswrdeyeisClicked == true)
        {
            let image = UIImage(named: "unhide.png") as UIImage?
            newPawrdOutlet.setBackgroundImage(image, for: UIControl.State.normal)
            newPassword.isSecureTextEntry = false
            newpswrdeyeisClicked = false
        }
        else
        {
            let image = UIImage(named: "hide.png") as UIImage?
            newPawrdOutlet.setBackgroundImage(image, for: UIControl.State.normal)
            newPassword.isSecureTextEntry = true
            newpswrdeyeisClicked = true
        }
    }
    
    @IBOutlet var oldPaswrdEyeOulet: UIButton!
    @IBAction func oldPawwordEyeButton(_ sender: Any)
    {
        if (oldpswrdeyeisClicked == true)
        {
            let image = UIImage(named: "unhide.png") as UIImage?
            oldPaswrdEyeOulet.setBackgroundImage(image, for: UIControl.State.normal)
            oldPassword.isSecureTextEntry = false
            oldpswrdeyeisClicked = false
        }
        else
        {
            let image = UIImage(named: "hide.png") as UIImage?
            oldPaswrdEyeOulet.setBackgroundImage(image, for: UIControl.State.normal)
            oldPassword.isSecureTextEntry = true
            oldpswrdeyeisClicked = true
        }
    }
    
    @IBOutlet var newPassword: UITextField!
    @IBOutlet var oldPassword: UITextField!
    @IBOutlet weak var submitOutlet: UIButton!
    @IBAction func submitAction(_ sender: Any)
    {
        let name = oldPassword.text
        let password = newPassword.text
        let confirmPassword = self.confirmPassword.text
        if (name!.isEmpty)
        {
            let alertController = UIAlertController(title: "M3", message: "Username is empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
            
        }
        else if (name!.count < 6)
        {
            
        }
        else if(password!.isEmpty)
        {
            let alertController = UIAlertController(title: "M3", message: "Old Password cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if(password!.count < 6)
        {
             let alertController = UIAlertController(title: "M3", message: "Short passwords are easy to guess!\nTry one with atleast 6 characters", preferredStyle: .alert)
             let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                 print("You've pressed default");
             }
             alertController.addAction(action1)
             self.present(alertController, animated: true, completion: nil)
         }
        else if(confirmPassword!.isEmpty)
          {
              let alertController = UIAlertController(title: "M3", message: "Confirm Password cannot be empty", preferredStyle: .alert)
              let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                  print("You've pressed default");
              }
              alertController.addAction(action1)
              self.present(alertController, animated: true, completion: nil)
          }
        else if(confirmPassword!.count < 6)
          {
              let alertController = UIAlertController(title: "M3", message: "Short passwords are easy to guess!\nTry one with atleast 6 characters", preferredStyle: .alert)
              let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                  print("You've pressed default");
              }
              alertController.addAction(action1)
              self.present(alertController, animated: true, completion: nil)
          }
        else if confirmPassword != password
        {
            let alertController = UIAlertController(title: "M3", message: "Password mismatch", preferredStyle: .alert)
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
            let functionName = "apimain/change_password/"
            let baseUrl = Baseurl.baseUrl + functionName
            let url = URL(string: baseUrl)!
            let parameters: Parameters = ["user_id": GlobalVariables.user_id!,"old_password": name!,"new_password": password!]
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
                            let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                print("You've pressed default");
                                
                               self.oldPassword.text = ""
                               self.newPassword.text = ""
                            }
                            alertController.addAction(action1)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else
                        {
                            let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                print("You've pressed default");
                                
                                self.performSegue(withIdentifier: "dashboard", sender: self)
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
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Change Password"
        NavigationBarTitleColor.navbar_TitleColor
        oldPassword.delegate = self
        newPassword.delegate = self
        submitOutlet.layer.cornerRadius = 4
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        navigationLeftButton ()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
    
    func navigationLeftButton ()
    {
        let str = UserDefaults.standard.string(forKey: "fromDashboard")
        if str == "YES"
        {
            let navigationLeftButton = UIButton(type: .custom)
            navigationLeftButton.setImage(UIImage(named: "back-01"), for: .normal)
            navigationLeftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            navigationLeftButton.addTarget(self, action: #selector(menuButtonclick), for: .touchUpInside)
            let navigationButton = UIBarButtonItem(customView: navigationLeftButton)
            self.navigationItem.setLeftBarButton(navigationButton, animated: true)
        }
        else
        {
            let navigationLeftButton = UIButton(type: .custom)
            navigationLeftButton.setImage(UIImage(named: "sidemenu_button"), for: .normal)
            navigationLeftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            navigationLeftButton.addTarget(self, action: #selector(menuButtonclick), for: .touchUpInside)
            let navigationButton = UIBarButtonItem(customView: navigationLeftButton)
            self.navigationItem.setLeftBarButton(navigationButton, animated: true)
        }
    }
    
    @objc func menuButtonclick()
    {
        let str = UserDefaults.standard.string(forKey: "fromDashboard")
        if str == "YES"
        {
            self.performSegue(withIdentifier: "to_Dashboard", sender: self)
        }
        else
        {
            present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        }
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
        if textField == oldPassword
        {
            confirmPassword.becomeFirstResponder()
        }
        else if textField == confirmPassword
        {
            newPassword.becomeFirstResponder()
        }
        else
        {
            newPassword.resignFirstResponder()
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            self.view.endEditing(true);
        }
    }
    
}
