//
//  Trade.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 08/01/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire

class Trade: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var _id = [String]()
    var tradename = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func menuButton(_ sender: Any)
    {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Trade"
        
        let str = UserDefaults.standard.string(forKey: "fromDashboard")
        
        if str != "YES"
        {
            setupSideMenu()
        }

        let strCenter = UserDefaults.standard.string(forKey: "fromCenterDetail")
        
        if strCenter != "true"
        {
            navigationLeftButton ()
        }
        

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        let str = UserDefaults.standard.string(forKey: "fromCenterDetail")
        
        if str == "true"
        {
           webRequest ()
        }
        else
        {
            webRequest ()
        }
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
        
        let centerDet = UserDefaults.standard.string(forKey: "fromCenterDetail")

        if str == "YES"
        {
            let navigationLeftButton = UIButton(type: .custom)
            navigationLeftButton.setImage(UIImage(named: "back-01"), for: .normal)
            navigationLeftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            navigationLeftButton.addTarget(self, action: #selector(menuButtonclick), for: .touchUpInside)
            let navigationButton = UIBarButtonItem(customView: navigationLeftButton)
            self.navigationItem.setLeftBarButton(navigationButton, animated: true)
        }
        else if centerDet == "true"
        {
            let navigationLeftButton = UIButton(type: .custom)
            navigationLeftButton.setImage(UIImage(named: "back-01"), for: .normal)
            navigationLeftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            navigationLeftButton.addTarget(self, action: #selector(menuButtonclick), for: .touchUpInside)
            let navigationButton = UIBarButtonItem(customView: navigationLeftButton)
            self.navigationItem.setLeftBarButton(navigationButton, animated: true)
        }
        else if str == "NO"
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
        
        let centerDet = UserDefaults.standard.string(forKey: "fromCenterDetail")
        
        if str == "YES"
        {
            self.performSegue(withIdentifier: "to_Dashboard", sender: self)
        }
        else if centerDet == "true"
        {
            self.performSegue(withIdentifier: "center_Detail", sender: self)
        }
        else
        {
            present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
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
        self.performSegue(withIdentifier: "addTrade", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tradename.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView .dequeueReusableCell(withIdentifier: "cell") as! TradeTableViewCell
        
        cell.trade.text = tradename[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    func webRequest ()
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
                        var tradeList = JSON?["Trades"] as? [Any]
                        for i in 0..<(tradeList?.count ?? 0)
                        {
                            var dict = tradeList?[i] as? [AnyHashable : Any]
                            let trade_name = dict?["trade_name"] as? String
                            let trade_id = dict?["status"] as? String
                            
                            self.tradename.append(trade_name ?? "")
                            self._id.append(trade_id ?? "")
                        }
                            self.tableView.reloadData()
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
