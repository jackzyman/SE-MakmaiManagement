//
//  EX-UITextField.swift
//  YellowIsDad
//
//  Created by Jarukit Rungruang on 13/12/17.
//  Copyright © 2017 Jarukit Rungruang. All rights reserved.
//

import Foundation
import UIKit

enum TextFieldType {
    case text 
    case email
    case phone
}

extension UITextField {

//    func YSDSet(placeholder: String = "" ,
//                color: Colorstyle = .text, placeholderColor: Colorstyle = .placeholder , 
//                style: Textstyle = .normal, size: Sizestyle = .normal){
//        self.textColor = AppGlobal.design.getColor(color)
//        self.font = AppGlobal.design.getFont(size: size, style: style)
//        self.attributedPlaceholder = NSAttributedString(string: placeholder,
//                                                        attributes: [NSAttributedStringKey.foregroundColor: AppGlobal.design.getColor(placeholderColor)])
//    }
    
    func YSDEmptyCharator() -> Bool {
        if self.hasText {
            return false
        } else {
            return true
        }
        
    }
    
    func YSDSetDefault(){
        self.textColor = AppGlobal.design.getColor(.text)
    }
    
    func YSDSetDanger(){
        self.textColor = AppGlobal.design.getColor(.red)
    }
    
    func YSDSetDangerText(){
            if let placeholder = self.placeholder {
                self.text = "Please Enter " + placeholder
            }        
        self.YSDSetDanger()
    }
    
    func YSDCheckState(_ type: TextFieldType = .text, maxChar: Int = 0, setDanger: Bool = false) -> Bool{
        if let text = self.text , text != "" {
            switch type {
            case .text :
                if maxChar != 0 {
                    if !self.YSDMaxCharator(maxChar) {
                        self.YSDSetDefault()
                        return true
                    } else {
                        self.YSDSetDanger()
                        return false
                    }
                } else {
                    self.YSDSetDefault()
                    return true
                }
            case .email :
                if text.YSDValidEmail() {
                    self.YSDSetDefault()
                    return true
                } else {
                    self.YSDSetDanger()
                    return false
                }
            case .phone :
                if text.YSDValidPhoneNumber() {
                    self.YSDSetDefault()
                    return true
                } else {
                    self.YSDSetDanger()
                    return false
                }
            default:
                return false
            }
        } else {
            if setDanger {
                YSDSetDangerText()
            }
            return false
        }
    }
    
    func YSDMaxCharator(_ maxChar: Int) -> Bool {
        if let char = self.text {
            if char.YSDCount() > maxChar {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
        
    }
    
}

