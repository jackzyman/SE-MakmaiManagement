//
//  EX-Int.swift
//  YellowIsDad
//
//  Created by Jarukit Rungruang on 13/12/17.
//  Copyright © 2017 Jarukit Rungruang. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func mpInt() -> Int? {
        return Int(self)
    }
}
extension Int {
    func mpFloat() -> CGFloat {
        return CGFloat(self)
    }
    
    func mpDouble() -> Double {
        return Double(self)
    }
}

extension Double {
    func mpInt() -> Int {
        return Int(self)
    }
    
    func mpCMNumber(_ digits: Int = 2) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.maximumFractionDigits = digits
        numberFormatter.minimumFractionDigits = digits
        //        return "\(String(format: "%.2f", self))"
        return numberFormatter.string(from: NSNumber(value:self))!
    }
    
    @available(*, renamed: "formatUsingAbbrevation")
    func mpRDNumber() -> String {
        if self > 999 {
            let sum = self / 1000
            if sum > 999 {
                let mil = sum / 1000
                return "\(String(format: "%.1f", mil))m"
            } else {
                return "\(String(format: "%.1f", sum))k"
            }
        } else {
            return "\(self)" 
        }
        
    }
}

extension Int {
    func mpCMNumber() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
    
    func mpRDNumber() -> String {
        if self > 999 {
            let sum = Double(self) / 1000
            if sum > 999 {
                let mil = Double(sum) / 1000
                return "\(String(format: "%.1f", mil))m"
            } else {
                return "\(String(format: "%.1f", sum))k"
            }
        } else {
            return "\(self)" 
        }
        
    }
}
