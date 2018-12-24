//
//  EX-UILabel.swift
//  YellowIsDad
//
//  Created by Jarukit Rungruang on 13/12/17.
//  Copyright © 2017 Jarukit Rungruang. All rights reserved.
//

import Foundation
import UIKit
import UIColor_Hex_Swift

extension UILabel {
    
}



extension UILabel {
    func YSDSet(size: CGFloat, color: Colorstyle = .text , style: Textstyle = .normal) {
        self.textColor = AppGlobal.design.getColor(color)
        if style == .normal {
            self.font = UIFont.systemFont(ofSize: size)
        } else {
        self.font = UIFont.boldSystemFont(ofSize: size)
        }

    }
//    
//    func YSDSet(size: CGFloat, color: Colorstyle = .text, uicolor : UIColor? = nil , style: Textstyle = .normal) {
//        if let color = uicolor {
//            self.textColor = color
//        } else {
//        self.textColor = AppGlobal.design.getColor(color)
//        }
//        self.font = AppGlobal.design.getFont(size: size, style: style)
//    }
    
//    func YSDSet(size: CGFloat, color: UIColor , style: Textstyle = .normal) {
//        self.textColor = color
//        self.font = AppGlobal.design.getFont(size: size, style: style)
//    }
}


extension String {
    
    var attributedString: NSAttributedString? {
        do {
            
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
        
        return nil
    }
    func YSDattributedStringWithFont(_ font: UIFont, color: UIColor) -> NSAttributedString? {
        let modifiedFont = NSString(format:"<span style=\"color:\(color.hexString()); font-family: Helvetica Neue; font-size: \(font.pointSize)\">%@</span>" as NSString, self) as String
        
        do {
            return try NSAttributedString(data: modifiedFont.data(using: String.Encoding.utf8)!, 
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}

extension UILabel {
    func YSDsetHmlText(_ text: String) {
        if let attrStr = text.YSDattributedStringWithFont(self.font, color: self.textColor) {
            self.attributedText = attrStr
        }
    }
    func YSDsetHmlTextWithStyle(text: String, font: UIFont, color: UIColor) {
        if let attrStr = text.YSDattributedStringWithFont(font, color: color) {
            self.attributedText = attrStr
        }
    }
    
//    func YSDsetHmlText(_ text: String) {
//        if let attrStr = text.attributedString {
//            self.attributedText = attrStr
//        }
//    }
}
