//
//  EX-UIImageView.swift
//  YellowIsDad
//
//  Created by Jarukit Rungruang on 13/12/17.
//  Copyright © 2017 Jarukit Rungruang. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
}

extension UIImageView {
    func YSDRotateImage(_ deg: CGFloat){
        let image = imageRotatedByDegrees(self.image!, deg: deg)
        self.image = image
    }
    
    func YSDsetColorImage(_ color: UIColor = UIColor.white){
        let image = self.image?.YSDChangeColor(color: color)
        self.image = image
    }
}
