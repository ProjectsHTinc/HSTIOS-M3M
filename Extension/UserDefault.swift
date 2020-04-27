//
//  UserDefaults.swift
//  M3_Mobilizer
//
//  Created by Happy Sanz Tech on 10/01/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit

enum UserDefaultsKey : String
{
      case userSessionKey
      case userDeviceTokenKey
}

extension UserDefaults
{
    func saveUserdata(userdata: UserData)
    {
      let encoder = JSONEncoder()
      if let encoded = try? encoder.encode(userdata) {
          let defaults = UserDefaults.standard
          defaults.set(encoded, forKey: UserDefaultsKey.userSessionKey.rawValue)
      }
    }
          
    func getUserData()-> UserData?
    {
      
       if data(forKey: UserDefaultsKey.userSessionKey.rawValue) != nil
       {
          let decodedData = UserDefaults.standard.data(forKey: UserDefaultsKey.userSessionKey.rawValue)
          var Userdata: UserData?
          if decodedData != nil {
              Userdata = try! JSONDecoder().decode(UserData.self, from: decodedData!)
          }
          return Userdata
       }
      
          return nil
      }
    
//    func saveStaffProfile(staffprofile: StaffProfile)
//    {
//      let encoder = JSONEncoder()
//      if let encoded = try? encoder.encode(staffprofile) {
//          let defaults = UserDefaults.standard
//          defaults.set(encoded, forKey: UserDefaultsKey.userSessionKey.rawValue)
//      }
//    }
//
//    func getStaffProfile()-> StaffProfile?
//    {
//
//       if data(forKey: UserDefaultsKey.userSessionKey.rawValue) != nil
//       {
//          let decodedData = UserDefaults.standard.data(forKey: UserDefaultsKey.userSessionKey.rawValue)
//          var staffProfile: StaffProfile?
//          if decodedData != nil {
//              staffProfile = try! JSONDecoder().decode(StaffProfile.self, from: decodedData!)
//          }
//          return staffProfile
//       }
//
//          return nil
//      }
    
     func clearUserData()
     {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.userSessionKey.rawValue)
     }
}
