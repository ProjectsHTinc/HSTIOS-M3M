//
//  CenterDetail.swift
//  M3_Mobilizer
//
//  Created by Happy Sanz Tech on 03/04/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire

class CenterDetail: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource
{

    var name : NSMutableArray = NSMutableArray()

    var tradeArr : NSMutableArray = NSMutableArray()

    @IBOutlet var canterName: UILabel!
    
    @IBOutlet var centerDetailText: UITextView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var Descripition: UIView!
    
    @IBAction func photoButton(_ sender: Any)
    {
        self.performSegue(withIdentifier: "gallery", sender: self)
    }
    
    @IBAction func videoButton(_ sender: Any)
    {
        self.performSegue(withIdentifier: "videos", sender: self)
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var storiesTexview: UITextView!
    
    @IBAction func storiesPhoto(_ sender: Any)
    {
        
    }
    
    @IBAction func storiesVideo(_ sender: Any)
    {
        
    }
    
    @IBAction func tradeButton(_ sender: Any)
    {
        if tradeArr.count != 0
        {
            UserDefaults.standard.set(tradeArr, forKey: "tradeArry")
            UserDefaults.standard.set("true", forKey: "fromCenterDetail")
            self.performSegue(withIdentifier: "centerDetail_trade", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Center Detail"
        let str = UserDefaults.standard.string(forKey: "fromDashboard")
        if str != "YES"
        {
            setupSideMenu()
        }
        self.centerDetailText.backgroundColor =  UIColor.clear
        self.storiesTexview.backgroundColor =  UIColor.clear
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
    
    func webRequest ()
    {
        let functionName = "apimobilizer/view_centerdetails/"
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
                    self.name.removeAllObjects()
                    self.tradeArr.removeAllObjects()
                    if  (status == "Sucess")
                    {
                        let centerData = JSON?["centerData"] as? NSDictionary
                        GlobalVariables.center_id = centerData?["center_id"] as? String
                        self.centerDetailText.text = centerData?["center_info"] as? String
                        self.canterName.text = centerData?["center_name"] as? String
                        
                        let trainer = JSON?["trainer"] as? [Any]
                        for i in 0..<(trainer?.count ?? 0)
                        {
                            let dict = trainer?[i] as? [AnyHashable : Any]
                            let trainerName = dict?["name"] as? String
                            self.name.add(trainerName!)
                        }
                        
                        let trade = JSON?["trade"] as? [Any]
                        for i in 0..<(trade?.count ?? 0)
                        {
                            let dict = trade?[i] as? [AnyHashable : Any]
                            let trade_name = dict?["trade_name"] as? String
                            self.tradeArr.add(trade_name!)
                        }
                        self.collectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return name.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! TrainerCollectionViewCell
        cell.nameLabel.text = (name[indexPath.row] as! String)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 120, height: 94)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 20
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
