//
//  EX-UIView.swift
//  YellowIsDad
//
//  Created by Jarukit Rungruang on 13/12/17.
//  Copyright © 2017 Jarukit Rungruang. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
//    func playBounceAnimation() {
//        
//        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
//        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
//        bounceAnimation.duration = TimeInterval(0.5)
//        bounceAnimation.calculationMode = kCAAnimationCubic
//        layer.add(bounceAnimation, forKey: "bounceAnimation")
//    }
    
    public class func fromNib(_ nibNameOrNil: String? = nil) -> Self {
        return fromNib(nibNameOrNil, type: self)
    }
    
    public class func fromNib<T: UIView>(_ nibNameOrNil: String? = nil, type: T.Type) -> T {
        let v: T? = fromNib(nibNameOrNil, type: T.self)
        return v!
    }
    
    public class func fromNib<T: UIView>(_ nibNameOrNil: String? = nil, type: T.Type) -> T? {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = nibName
        }
        let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        for v in nibViews! {
            if let tog = v as? T {
                view = tog
            }
        }
        return view
    }
    
    public class var nibName: String {
        let name = "\(self)".components(separatedBy: ".").first ?? ""
        return name
    }
    public class var nib: UINib? {
        if let _ = Bundle.main.path(forResource: nibName, ofType: "nib") {
            return UINib(nibName: nibName, bundle: nil)
        } else {
            return nil
        }
    }
}


extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func YSDborderRounded(_ size: CGFloat, side: UIRectCorner){
        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: side ,
                                     cornerRadii:CGSize(width: size, height: size))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPAth1.cgPath
        self.layer.mask = maskLayer1
    }
}


extension UIView{
//    func addBlurEffectView(){
//        addBlurEffectView(style: UIBlurEffectStyle.light)
//    }
//    
//    func addBlurEffectView(style: UIBlurEffectStyle){
//        let blurEffect = UIBlurEffect(style: style)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.bounds
//        
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
//        self.addSubview(blurEffectView)
//    }
}

extension UIView {
    func YSDDropShadow(){
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOpacity = 0.1
    self.layer.shadowOffset = CGSize.zero
    self.layer.shadowRadius = 5
    }
}

extension UIView{
    func mpsetgradient(startColor: UIColor, endColor: UIColor, toTop: Bool = true) {
        let colorTop =  startColor.cgColor
        let colorBottom = endColor.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        //        gradientLayer.locations = [ top, bottom]
        gradientLayer.frame = self.bounds
        //        gradientLayer.transform = 
        if toTop {
            gradientLayer.locations = [ 0, 1]
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        self.layer.addSublayer(gradientLayer)
    }
    
    func mpRenderPNG(_ scale: CGFloat = 3) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.layer.frame.size, false, scale)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            if let viewImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
               if let data = viewImage.pngData()  {
                    let image = UIImage(data: data)
                    return image
                }else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
        
    }
}






