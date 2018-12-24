//
//  EX-UIButton.swift
//  YellowIsDad
//
//  Created by Jarukit Rungruang on 13/12/17.
//  Copyright © 2017 Jarukit Rungruang. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
}
extension UIButton {
    func YSDsetColorImage(_ color: UIColor = UIColor.white){
        let image = self.imageView?.image?.YSDChangeColor(color: color)
        self.setImage(image, for: .normal)
        
    }
    
    func YSDSet(color: Colorstyle = .text, backgroud: Colorstyle = .null ,
                bordercolor: Colorstyle = .null , borderWidth: CGFloat = 1){
        self.backgroundColor = AppGlobal.design.getColor(backgroud)
        self.borderColor = AppGlobal.design.getColor(bordercolor)
        self.borderWidth = borderWidth
        self.setTitleColor(AppGlobal.design.getColor(color), for: .normal)
    }
    
    func YSDSetMain(_ isEnabled: Bool = true){
        self.isEnabled = isEnabled
        if isEnabled {
            self.YSDSet(color: .white, backgroud: .main, 
                    bordercolor: .null, borderWidth: 0)
            self.YSDDropShadow()
        } else {
            self.YSDSet(color: .white, backgroud: .grey, 
                        bordercolor: .null, borderWidth: 0)
        }
        
    }
    
    func YSDSetClearMain(_ color: Colorstyle){
        self.YSDSet(color: color, backgroud: .null, 
                    bordercolor: color, borderWidth: 2)
        self.YSDDropShadow()
    }
    
    func YSDSetClearMain(_ color: String){
        let uicolor = UIColor(color)
        self.backgroundColor = .clear
        self.borderColor = uicolor
        self.borderWidth = 2
        self.setTitleColor(uicolor, for: .normal)
        
        self.YSDDropShadow()
    }
    
    
    func YSDSetSecondary(){
        self.YSDSet(color: .main, backgroud: .white, 
                    bordercolor: .null, borderWidth: 0)
        self.YSDDropShadow()
    }
    
    
    func YSDSetLang(){
        self.YSDSet(color: .white, backgroud: .null, 
                    bordercolor: .null, borderWidth: 0)
        self.alpha = 0.5
        self.YSDDropShadow()
    }
    
    func YSDSetLangHighlight(){
        self.YSDSet(color: .white, backgroud: .main, 
                    bordercolor: .null, borderWidth: 0)
        self.alpha = 1
        self.YSDDropShadow()
    }
    
//    func FMClear(color: Colorstyle = .main){
//        self.YSDSet(color: color, backgroud: .null, 
//                    bordercolor: color, borderWidth: 3, 
//                    style: .bold, size: .button)
//        self.YSDDropShadow()
//    }
    
}
