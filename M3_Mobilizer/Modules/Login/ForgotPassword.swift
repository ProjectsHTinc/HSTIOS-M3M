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

class ForgotPassword: UIViewController,UITextFieldDelegate
{
    
    var activeField: UITextField?
    
    var lastOffset: CGPoint!
    
    var keyboardHeight: CGFloat!
    
    var oldpswrdeyeisClicked = true

    var newpswrdeyeisClicked = true


    @IBAction func backAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "M3_Login", bundle: nil)
        let login = storyboard.instantiateViewController(withIdentifier: "login") as! Login
        self.present(login, animated: true, completion: nil)
    }
    
    @IBOutlet var newPawrdOutlet: UIButton!
    
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
        else if name == password
        {
            let alertController = UIAlertController(title: "M3", message: "Old and new password are same", preferredStyle: .alert)
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
