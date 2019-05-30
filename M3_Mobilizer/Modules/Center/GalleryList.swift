//
//  GalleryList.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 05/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class GalleryList: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    var centerPhoto = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Gallery"
        
       // navigationRightButton ()
        
        webRequest ()

    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      return centerPhoto.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! PhotoTableViewCell

        let imgUrl = centerPhoto[indexPath.row]

        cell.imgView.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "placeholder.png"))

        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 263
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
        self.performSegue(withIdentifier: "addImage", sender: self)
    }
    func webRequest ()
    {
        let functionName = "apimobilizer/view_centerimages/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "center_id": GlobalVariables.center_id!]
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
                    if (status == "Sucess")
                    {
                        var centerGallery = JSON?["Photo"] as? [Any]
                        for i in 0..<(centerGallery?.count ?? 0)
                        {
                            var dict = centerGallery?[i] as? [AnyHashable : Any]
                            let center_photo = dict?["center_photos"] as? String
                            
                            self.centerPhoto.append(center_photo ?? "")
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
