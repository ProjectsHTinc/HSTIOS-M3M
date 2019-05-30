//
//  AddTask.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 22/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire

class AddTask: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    var name : NSMutableArray = NSMutableArray()
    
    var user_id : NSMutableArray = NSMutableArray()
    
    var picker = UIPickerView()
    
    var datePicker = UIDatePicker()
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var tasktitle: UITextField!
    
    @IBOutlet var taskdate: UITextField!
    
    @IBOutlet var taskDetails: UITextView!
    
    @IBOutlet var saveOutlet: UIButton!
    
    @IBAction func saveButton(_ sender: Any)
    {
        addVaues ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NavigationBarTitleColor.navbar_TitleColor

        self.title = "Add Task"
        
        tasktitle.delegate = self
        
        taskdate.delegate = self

        taskDetails.delegate = self

        
        saveOutlet.layer.cornerRadius = 4
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
       // webRequest ()
        
        let str = UserDefaults.standard.string(forKey: "Task_View")
        
        if str == "fromList"
        {
          //  ViewDetails ()
        }
    }
    
    @objc func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func pickStartDate(_ textField : UITextField)
    {
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = .date
        self.datePicker.minimumDate = NSDate() as Date
        taskdate.inputView = self.datePicker
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(startDateDoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        // add toolbar to textField
        taskdate.inputAccessoryView = toolbar
        // add datepicker to textField
        taskdate.inputView = datePicker
    }
    
    @objc func startDateDoneClick()
    {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        taskdate.text = dateFormatter1.string(from: datePicker.date)
        taskdate.resignFirstResponder()
        taskDetails.becomeFirstResponder()
    }
    
    @objc func cancelClick()
    {
        taskdate.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == tasktitle
        {
          taskdate.becomeFirstResponder()
          self.pickStartDate(taskdate)
        }
        else if textField == taskdate
        {
            taskDetails.becomeFirstResponder()
        }
        else if textField == taskDetails
        {
            taskDetails.resignFirstResponder()
        }
       
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == tasktitle
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 50), animated: true)

        }
        else if textField == taskDetails
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 100), animated: true)
        }
        else if textField == taskdate
        {
            self.pickStartDate(taskdate)
        }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == tasktitle
        {
             self.taskdate.becomeFirstResponder()
        }
        else if textField == taskDetails
        {
            taskDetails.resignFirstResponder()
        }
        else if textField == taskdate
        {
            self.taskDetails.becomeFirstResponder()
        }
       
    }
    /* Updated for Swift 4 */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /* Older versions of Swift */
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func addVaues ()
    {
        if self.tasktitle.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.taskdate.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.taskDetails.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
           // ActivityIndicator().showActivityIndicator(uiView: self.view)
            let functionName = "apimobilizer/add_task/"
            let baseUrl = Baseurl.baseUrl + functionName
            let url = URL(string: baseUrl)!
            let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "task_title": self.tasktitle.text as Any, "task_description": self.taskDetails.text as Any, "task_date": self.taskdate.text as Any,"pia_id":GlobalVariables.pia_id!, "status": "Active"]
            
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
                          //  ActivityIndicator().hideActivityIndicator(uiView: self.view)
                            let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                print("You've pressed default");
                                
                                self.tasktitle.text = ""
                                self.taskdate.text = ""
                                self.taskDetails.text = ""
                                self.performSegue(withIdentifier: "to_Task", sender: self)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
