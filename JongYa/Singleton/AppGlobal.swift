//
//  AppGlobal.swift
//  JongYa
//
//  Created by Jarukit Rungruang on 15/10/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//

import UIKit
import Foundation
//import Toaster

final class AppGlobal {
    
    static let shared = AppGlobal()
    static let design = DesignGlobal()
    static let db = DatabaseGobal()
    static let load = LoadingGlobal()
    static let storyboard = StoryboardGlobal()
    static let storage = StorageGlobal()
   
    private var _navigationController: UINavigationController?
    private var _tabBarController: UITabBarController?
    
    private let _appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var appDelegate: AppDelegate {
        return _appDelegate
    }
    
    class var navigationController: UINavigationController? {
        return AppGlobal.shared.navigationController
    }
    
    var navigationController: UINavigationController? {
        didSet {
        }
    }
    
    class var tabBarController: UITabBarController? {
        return AppGlobal.shared.tabBarController
    }
    
    var tabBarController: UITabBarController? {
        didSet {
        }
    }
    
}

