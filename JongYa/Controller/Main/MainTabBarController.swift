//
//  MainTabBarController.swift
//  JongYa
//
//  Created by Jarukit Rungruang Punkaew on 15/10/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//


import Foundation
import UIKit

extension UIViewController {
}


class MainTabBarController: UITabBarController { //RAMAnimatedTabBarController {
    
    func activeViewController() -> UIViewController?{
        if let viewControllers = viewControllers, selectedIndex >= 0 && selectedIndex < viewControllers.count {
            return viewControllers[selectedIndex]
        } else {
            return nil
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let vc = activeViewController() {
            return vc.preferredStatusBarStyle
        } else {
            return super.preferredStatusBarStyle
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        
        
        let tab1 = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "HomeViewController")
        let tab2 = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "ChatViewController")
        let tab3 = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "NewScanViewController")
        let tab4 = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "SettingViewController")
        
        let tabItem1 = UITabBarItem(title: nil,
                                    image: UIImage(named: "tabb_0")?.withRenderingMode(.alwaysOriginal),
                                    selectedImage: UIImage(named: "1tabb_0")?.withRenderingMode(.alwaysOriginal))
        let tabItem2 = UITabBarItem(title: nil,
                                     image: UIImage(named: "tabb_1")?.withRenderingMode(.alwaysOriginal),
                                     selectedImage: UIImage(named: "1tabb_1")?.withRenderingMode(.alwaysOriginal))
        let tabItem3 = UITabBarItem(title: nil,
                                         image: UIImage(named: "tabb_2")?.withRenderingMode(.alwaysOriginal),
                                         selectedImage: UIImage(named: "1tabb_2")?.withRenderingMode(.alwaysOriginal))
      
      let tabItem4 = UITabBarItem(title: nil,
                                  image: UIImage(named: "tabb_3")? .withRenderingMode(.alwaysOriginal),
                                  selectedImage: UIImage(named: "1tabb_3")?.withRenderingMode(.alwaysOriginal))
        
        tab1.tabBarItem = tabItem1
        tab2.tabBarItem = tabItem2
        tab3.tabBarItem = tabItem3
        tab4.tabBarItem = tabItem4
        
        if  AppGlobal.design.getDeviceModel()  == .iPhoneX{
            self.tabBar.frame.size.height = self.tabBar.frame.size.height + 40
        }
        
        tabBar.backgroundColor = UIColor.white
        
        
        //Set Tabbar Text
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppGlobal.design.getColor(.main)], for: .selected)
        
        setViewControllers([tab1, tab2, tab3, tab4], animated: false)
        
        super.viewDidLoad()
        
        
        AppGlobal.shared.tabBarController = self
        
        AppGlobal.shared.navigationController = self.navigationController
        //        self.navigationController?.navigationBar.isHidden = true
        //        if AppGlobal.shared.activeUserContext.user.info.userId == 0{
        //            AppGlobal.shared.appContext.signOut()
        //            AppGlobal.shared.appContext.appDelegate.createLoginView()
        //        }
    }
}

