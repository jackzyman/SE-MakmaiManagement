//
//  EX-UIColor.swift
//  YellowIsDad
//
//  Created by Jarukit Rungruang on 13/12/17.
//  Copyright © 2017 Jarukit Rungruang. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    // MARK: -
    convenience init(_ string: String) {
        var string = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if string.hasPrefix("#") {
            string = (string as NSString).substring(from: 1)
        }
        
        if string.count != 6 {
            fatalError()
        }
        
        let rString = (string as NSString).substring(to: 2)
        let gString = ((string as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((string as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    // MARK: -
    func isLight() -> Bool {
        let components = self.cgColor.components
        let componentColorX: CGFloat = components![0]
        let componentColorY: CGFloat = components![1]
        let componentColorZ: CGFloat = components![2]
        let brightness = ((componentColorX * 299.0) + (componentColorY * 587.0) + (componentColorZ * 114.0)) / 1000.0
        
        if brightness < 0.5 {
            return false
        } else {
            return true
        }
    }
}
