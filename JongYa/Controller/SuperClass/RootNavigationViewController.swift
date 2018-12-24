//
//  RootNavigationViewController.swift
//  YellowIsDad
//
//  Created by Jarukit Rungruang on 17/12/17.
//  Copyright © 2017 Jarukit Rungruang. All rights reserved.
//

import UIKit
import SwiftMessages



class RootNavigationViewController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    public var massageBarEnable = true
    override func viewDidLoad() {
        self.navigationBar.isHidden = true
        AppGlobal.shared.navigationController = self
        
    }


    
}
