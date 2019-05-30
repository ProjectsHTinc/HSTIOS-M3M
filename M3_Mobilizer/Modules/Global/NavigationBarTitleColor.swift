//
//  NavigationBarTitleColor.swift
//  M3_Mobilizer
//
//  Created by Happy Sanz Tech on 20/03/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class NavigationBarTitleColor: NSObject
{
    static let navbar_TitleColor : () =  UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white]
}
