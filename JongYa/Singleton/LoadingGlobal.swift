//
//  LoadingGlobal.swift
//  JongYa
//
//  Created by Jarukit Rungruang on 15/10/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//


import Foundation
import PKHUD

class LoadingGlobal: NSObject {
    
    func waiting(){
        HUD.show(.progress)
    }
    
    func done(){
        HUD.hide()
    }
}
