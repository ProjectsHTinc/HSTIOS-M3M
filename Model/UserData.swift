//
//  UserData.swift
//  M3_Mobilizer
//
//  Created by Happy Sanz Tech on 10/01/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserData: Codable {
    
    var name, password_status, user_id, user_name, user_pic, user_type, user_type_name ,staffAddress, staffAge, staffCommunity, staffCommunity_class, staffEmail, staffName, staffNationality, staffPhone, pia_id, staffQualification, staffReligion, staffRole_type, staffSex, staffStaff_id  : String?
    
    init(json:JSON)
    {
        self.name = json["name"].stringValue
        self.password_status = json["password_status"].stringValue
        self.user_id = json["user_id"].stringValue
        self.user_name = json["user_name"].stringValue
        self.user_pic = json["user_pic"].stringValue
        self.user_type = json["user_type"].stringValue
        self.user_type_name = json["user_type_name"].stringValue
        
        self.staffNationality = json["nationality"].stringValue
        self.staffAddress = json["address"].stringValue
        self.staffCommunity_class = json["community_class"].stringValue
        self.staffCommunity = json["community"].stringValue
        self.staffName = json["name"].stringValue
        self.staffRole_type = json["role_type"].stringValue
        self.staffStaff_id = json["staff_id"].stringValue
        self.staffPhone = json["phone"].stringValue
        self.staffQualification = json["qualification"].stringValue
        self.staffSex = json["sex"].stringValue
        self.pia_id = json["pia_id"].stringValue
        self.staffReligion = json["religion"].stringValue
        self.staffEmail = json["email"].stringValue
        self.staffAge = json["age"].stringValue

    }

}
          
 
