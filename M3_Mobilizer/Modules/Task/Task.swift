//
//  Task.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 22/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire

class Task: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var task_title = [String]()
    
    var task_description  = [String]()
    
    var task_id = [String]()
    
    var task_date = [String]()

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NavigationBarTitleColor.navbar_TitleColor

        self.title = "Task"
        
        navigationLeftButton ()
        
        navigationRightButton ()
        
        let str = UserDefaults.standard.string(forKey: "fromDashboard")
        
        if str != "YES"
        {
            setupSideMenu()
        }

        webRequest ()
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableView.automaticDimension

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        webRequest ()
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
    
    func webRequest ()
    {
        let functionName = "apimobilizer/list_task/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!]
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
                        var taskDetails = JSON?["taskDetails"] as? [Any]
                        
                        for i in 0..<(taskDetails?.count ?? 0)
                        {
                            var dict = taskDetails?[i] as? [AnyHashable : Any]
                            let tasktitle = dict?["task_title"] as? String
                            let taskdescription = dict?["task_description"] as? String
                            let taskdate = dict?["task_date"] as? String
                            let taskid = String(format: "%@",dict?["id"] as! CVarArg)

                            self.task_description.append(taskdescription ?? "")
                            self.task_title.append(tasktitle ?? "")
                            self.task_id.append(taskid)
                            self.task_date.append(taskdate ?? "")


                        }
                        
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
        return task_title.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! TaskTableViewCell
        
        cell.tasktitle.text = task_title[indexPath.row]
        
        cell.taskDetails.text = task_description[indexPath.row]
        
        cell.dateLabel.text = task_date[indexPath.row]
        
        cell.subView.layer.cornerRadius = 6

        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        GlobalVariables.task_id = (task_id[indexPath.row] )
        UserDefaults.standard.set("fromList", forKey: "Task_View") //setObject
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
