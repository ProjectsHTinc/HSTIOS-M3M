//
//  ViewTask.swift
//  M3_Mobilizer
//
//  Created by Happy Sanz Tech on 30/03/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import MBProgressHUD

class ViewTask: UIViewController,UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var year_id = [String]()
    var month_id = [String]()
    var month_name = [String]()
    var monthID = String()
    var picker = UIPickerView()
    
    var taskTitle = [String]()
    var taskType = [String]()
    var taskAttendanceDate = [String]()
    var taskComments = [String]()
    var taskStatus = [String]()
    var task_ID = [String]()
    var attandence_ID = [String]()

    
    var titleText = String()
    var descripition = String()
    var date = String()
    var task_Type = String()
    var status = String()
    var taskID = String()
    var attandenceID = String()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Mobilizer Work Detail"
        NavigationBarTitleColor.navbar_TitleColor
        navigationLeftButton ()
//        navigationRightButton ()
        self.yearTextField.delegate = self
        self.monthTextField.delegate = self
        let str = UserDefaults.standard.string(forKey: "fromDashboard")
        if str != "YES"
        {
            setupSideMenu()
        }
        let myColor = UIColor.black
        yearTextField.layer.cornerRadius = 5.0
        yearTextField.layer.borderColor = myColor.cgColor
        yearTextField.layer.borderWidth = 2.0
        yearTextField.clipsToBounds = true
        
        monthTextField.layer.cornerRadius = 5.0
        monthTextField.layer.borderColor = myColor.cgColor
        monthTextField.layer.borderWidth = 2.0
        monthTextField.clipsToBounds = true
        
        self.tableView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        webRequestForYears ()
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
    
    func navigationLeftButton ()
    {
        let str = UserDefaults.standard.string(forKey: "fromDashboard")
        
        if GlobalVariables.user_type_name == "TNSRLM" || str == "YES"
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
        if GlobalVariables.user_type_name == "TNSRLM"
        {
            self.performSegue(withIdentifier: "user_TNSRLM_Dashboard", sender: self)
        }
        else
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
    }
    
    func navigationRightButton ()
    {
        let navigationRightButton = UIButton(type: .custom)
        navigationRightButton.setImage(UIImage(named: "add"), for: .normal)
        navigationRightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navigationRightButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        let navigationButton = UIBarButtonItem(customView: navigationRightButton)
        self.navigationItem.setRightBarButtonItems([navigationButton], animated: true)
    }
    
    @objc func clickButton()
    {
        UserDefaults.standard.set("fromAdd", forKey: "Task_View") //setObject
        self.performSegue(withIdentifier: "addTask", sender: self)
    }
        
    func webRequestForYears ()
    {
        let functionName = "apipia/get_year_list_attendance/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["mobilizer_id": GlobalVariables.user_id!,"user_id": GlobalVariables.user_id!]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    MBProgressHUD.hide(for: self.view, animated: true)
                    print(response)
                    let JSON = response.result.value as? [String: Any]
                    let msg = JSON?["msg"] as? String
                    let status = JSON?["status"] as? String
                    if (status == "success")
                    {
                        let year_id = JSON?["result"] as? [Any]
                        self.year_id.removeAll()
                        for i in 0..<(year_id?.count ?? 0)
                        {
                            let dict = year_id?[i] as? [AnyHashable : Any]
                            let _year_id = dict?["year_id"] as? String
                            
                            self.year_id.append(_year_id!)
                        }
                        
                        self.picker.reloadAllComponents()
                        
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                           // print("You've pressed default");
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
    
    func webRequestForMonths (yearId:String)
    {
        let functionName = "apipia/get_month_list_attendance/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["mobilizer_id": GlobalVariables.user_id!,"user_id": GlobalVariables.user_id!,"year_id": yearId]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    MBProgressHUD.hide(for: self.view, animated: true)
                    print(response)
                    let JSON = response.result.value as? [String: Any]
                    let msg = JSON?["msg"] as? String
                    let status = JSON?["status"] as? String
                    if (status == "success")
                    {
                        let result = JSON?["result"] as? [Any]
                        
                        self.month_id.removeAll()
                        self.month_name.removeAll()
                        
                        for i in 0..<(result?.count ?? 0)
                        {
                            let dict = result?[i] as? [AnyHashable : Any]
                            let monthId = dict?["month_id"] as? String
                            let monthName = dict?["month_name"] as? String

                            self.month_id.append(monthId!)
                            self.month_name.append(monthName!)
                        }
                        
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                           // print("You've pressed default");
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
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if yearTextField.isFirstResponder
        {
            self.pickerforYears(yearTextField)
        }
        else if monthTextField.isFirstResponder
        {
            if yearTextField.text == "Select Year"
            {
                let alertController = UIAlertController(title: "M3", message: "Select Year", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                   // print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                self.pickerforYears(monthTextField)
            }
        }
        
    }
    
    func pickerforYears(_ textField : UITextField)
    {
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        picker.backgroundColor = .white
        picker.setValue(UIColor.black, forKeyPath: "textColor")
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(yearpickerdoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:  #selector(yearpickercancelClick))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        yearTextField.inputView = picker
        yearTextField.inputAccessoryView = toolBar
        
        monthTextField.inputView = picker
        monthTextField.inputAccessoryView = toolBar
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if yearTextField.isFirstResponder
        {
            return year_id.count
        }
        else
        {
            return month_name.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if yearTextField.isFirstResponder
        {
            return year_id[row]
        }
        else
        {
            return month_name[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if yearTextField.isFirstResponder
        {
            self.yearTextField.text = year_id[row]
        }
        else
        {
            self.monthTextField.text = month_name[row]
        }
    }
    
    @objc func yearpickerdoneClick ()
    {
        if yearTextField.isFirstResponder
        {
            let selectedIndex = picker.selectedRow(inComponent: 0)
            yearTextField.text = year_id[selectedIndex]
            yearTextField.resignFirstResponder()
            if yearTextField.text != "Select Year"
            {
                webRequestForMonths (yearId:yearTextField.text!)
            }
        }
        else
        {
            let selectedIndex = picker.selectedRow(inComponent: 0)
            monthTextField.text = month_name[selectedIndex]
            self.monthID = month_id[selectedIndex]
            self.getAttendaceDetail(month_id: self.monthID, year_id: yearTextField.text!)
            monthTextField.resignFirstResponder()
        }
    }
    
    @objc func yearpickercancelClick ()
    {
        if yearTextField.isFirstResponder
        {
            yearTextField.resignFirstResponder()
        }
        else
        {
            monthTextField.resignFirstResponder()
        }
    }
    
    func getAttendaceDetail (month_id:String,year_id:String)
    {
        let functionName = "apipia/get_month_day_list_attendance/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["mobilizer_id": GlobalVariables.user_id!,"user_id": GlobalVariables.user_id!,"year_id": year_id,"month_id":month_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    MBProgressHUD.hide(for: self.view, animated: true)
                    print(response)
                    let JSON = response.result.value as? [String: Any]
                    let msg = JSON?["msg"] as? String
                    let status = JSON?["status"] as? String
                    if (status == "success")
                    {
                        let result = JSON?["result"] as? [Any]
                        
                        self.taskTitle.removeAll()
                        self.taskType.removeAll()
                        self.taskAttendanceDate.removeAll()
                        self.taskComments.removeAll()
                        self.taskStatus.removeAll()
                        self.task_ID.removeAll()

                        for i in 0..<(result?.count ?? 0)
                        {
                            let dict = result?[i] as? [AnyHashable : Any]
                            let task_comments = dict?["comments"] as? String
                            let task_attendance_date = dict?["attendance_date"] as? String
                            let task_status = dict?["status"] as? String
                            let task_title = dict?["title"] as? String
                            let task_work_type = dict?["work_type"] as? String
                            let taskID = dict?["mobilizer_id"] as? String
                            let attance_id = dict?["id"] as? String

                            self.taskTitle.append(task_title!)
                            self.taskType.append(task_work_type!)
                            self.taskAttendanceDate.append(task_attendance_date!)
                            self.taskComments.append(task_comments!)
                            self.taskStatus.append(task_status!)
                            self.task_ID.append(taskID!)
                            self.attandence_ID.append(attance_id!)
                        }
                        
                        self.tableView.isHidden = false
                        self.tableView.reloadData()

                    }
                    else
                    {
                        let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                           // print("You've pressed default");
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return taskType.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! TaskTableViewCell
        cell.assignedToLabel.text = taskType[indexPath.row]
        cell.tasktitle.text = taskAttendanceDate[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
            self.titleText = taskTitle[indexPath.row]
            self.descripition = taskComments[indexPath.row]
            self.date = taskAttendanceDate[indexPath.row]
            self.task_Type = taskType[indexPath.row]
            self.status = taskStatus[indexPath.row]
            self.taskID = task_ID[indexPath.row]
            self.attandenceID = attandence_ID [indexPath.row]
            self.performSegue(withIdentifier: "taskDetails", sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 84
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "taskDetails")
        {
            let vc = segue.destination as! TaskDetails
            vc.titleText = self.titleText
            vc.descripition = self.descripition
            vc.date = self.date
            vc._taskType = self.task_Type
            vc.status = self.status
            vc.taskID = self.taskID
            vc.attandenceID = self.attandenceID
        }
    }
    

}
