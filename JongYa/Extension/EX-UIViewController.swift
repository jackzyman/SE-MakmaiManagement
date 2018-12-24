//
//  EX-UIViewController.swift
//  YellowIsDad
//
//  Created by Jarukit Rungruang on 13/12/17.
//  Copyright © 2017 Jarukit Rungruang. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
}

extension UIViewController: StoryboardInstantiable {
    static var storyboardIdentifier: String {
        // Get the name of current class
        let classString = NSStringFromClass(self)
        let components = classString.components(separatedBy: ".")
        assert(components.count > 0, "Failed extract class name from \(classString)")
        return components.last!
    }
    
    class func instantiateFromStoryboard(_ storyboard: UIStoryboard) -> Self {
        return instantiateFromStoryboard(storyboard, type: self)
    }
}

extension UIViewController {
    
    // Thanks to generics, return automatically the right type
    fileprivate class func instantiateFromStoryboard<T: UIViewController>(_ storyboard: UIStoryboard, type: T.Type) -> T {
        return storyboard.instantiateViewController(withIdentifier: self.storyboardIdentifier) as! T
    }
}


extension UIViewController {
//    func presentViewControllerFromLeft(_ controller: UIViewController) {
//        let transition: CATransition = CATransition()
//        transition.duration = 0.35
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.type = kCATransitionMoveIn
//        transition.subtype = kCATransitionFromRight
//        
//        let containerView: UIView = self.view.window!
//        containerView.layer.add(transition, forKey: nil)
//        present(controller, animated: false, completion: nil)
//    }
//    
//    func dismissViewControllerWithTransition(_ transitionType: String) {
//        let transition: CATransition = CATransition()
//        transition.duration = 0.35
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.type = transitionType
//        transition.subtype = kCATransitionFromLeft
//        
//        let containerView: UIView = self.view.window!
//        containerView.layer.add(transition, forKey: nil)
//        dismiss(animated: false, completion: nil)
//    }
//    
//    func dismissRightToLeft() {
//        let transition: CATransition = CATransition()
//        transition.duration = 0.35
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.type = kCATransitionMoveIn
//        transition.subtype = kCATransitionFromLeft
//        
//        let containerView: UIView = self.view.window!
//        containerView.layer.add(transition, forKey: nil)
//        dismiss(animated: false, completion: nil)
//    }
}


extension UIViewController {
//    , completion: @escaping (mediaResponseInfo) -> ()){
//
//    let alertController = UIAlertController(title: "คุณไม่ได้ใส่เหตุผล", message: "กรุณากรอกเหตุผลของการยกเลิกงานในครั้งนี้", preferredStyle: .alert)
//    let ok = UIAlertAction(title: "ตกลง", style: .default ) { (action) in  
//    }
//    alertController.addAction(ok)
    
    func YSDShowAlertOK(_ title: String, message: String?, action: String, completion: (() -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: action, style: .default) { (action) in 
            if action.isEnabled {
            completion?() 
            }
        }
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: completion)
    }
    
//    func YSDShowAlertOK(_ title: String, message: String?, action: String, completion: (() -> Void)? = nil){
//        let alertController = UIAlertController(title: "คุณไม่ได้ใส่เหตุผล", message: "กรุณากรอกเหตุผลของการยกเลิกงานในครั้งนี้", preferredStyle: .alert)
//        let ok = UIAlertAction(title: "ตกลง", style: .default ) { (action) in  
//            if action.isEnabled
//        }
//        alertController.addAction(ok)
//        
//        self.present(alertController, animated: true, completion: nil)
//    }
    
//    func showAlertCancel(_ title: String, message: String?, action: String, handler: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let ok = UIAlertAction(title: action, style: .default, handler: { (self) in
//            handler?()
//        })
//        alertController.addAction(ok)
//        
//        let cancel = UIAlertAction(title: "Cancel" , style: .cancel, handler: { (self) in
//            
//        })
//        alertController.addAction(cancel)
//        self.present(alertController, animated: true, completion: completion)
//    }
    
    
    func YSDShowAlertCancel(_ title: String, message: String?, action: String, canceltext: String = "ยกเลิก", submit: (() -> Void)? , cancel: (() -> Void)? ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: action, style: .default, handler: { (self) in
            submit?()
        })
        alertController.addAction(ok)
        
        let cancel = UIAlertAction(title: canceltext, style: .cancel, handler: { (self) in
            cancel?()
        })
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension UIViewController {    
    func dismissOrPop(){ // pop หน้าออกไป
        if let navigationController = navigationController {
            _ = navigationController.popViewController(animated: true);
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

