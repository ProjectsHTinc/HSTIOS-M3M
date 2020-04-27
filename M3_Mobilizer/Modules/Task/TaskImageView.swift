//
//  TaskImageView.swift
//  M3_Mobilizer
//
//  Created by Happy Sanz Tech on 30/01/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import SDWebImage

class TaskImageView: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    var task_id = String()
    var task_Id = [String]()
    var task_image  = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Task Image"
        self.tableView.backgroundColor = UIColor.white
        self.getImages()
    }
    
    func getImages()
    {
        let functionName = "apimobilizer/list_taskpic/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["task_id": task_id]
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
                    if (status == "Sucess")
                    {
                       let taskDetails = JSON?["Taskpictures"] as? [Any]
                       
                       self.task_Id.removeAll()
                       self.task_image.removeAll()
                    
                       for i in 0..<(taskDetails?.count ?? 0)
                       {
                           let dict = taskDetails?[i] as? [AnyHashable : Any]
                           let taskid = dict?["task_id"] as? String
                           let task_Image = dict?["task_image"] as? String
                        
                           self.task_Id.append(taskid ?? "")
                           self.task_image.append(task_Image ?? "")
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
        return task_image.count
    }
       
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
   {
       let cell = self.tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! TaskImageViewCell
       let imgUrl = task_image[indexPath.row]
       cell.taskImageView.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "placeholder.png"))
       return cell
   }
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
   {
       return 191
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
