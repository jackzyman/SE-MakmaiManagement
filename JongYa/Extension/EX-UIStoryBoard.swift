//
//  EX-UIStoryBoard.swift
//  YellowIsDad
//
//  Created by Jarukit Rungruang on 13/12/17.
//  Copyright © 2017 Jarukit Rungruang. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardInstantiable {
    static var storyboardIdentifier: String {get}
    static func instantiateFromStoryboard(_ storyboard: UIStoryboard) -> Self
}


extension UIStoryboard {
    
    class func mainStoryboard() -> UIStoryboard! {
        
        guard let mainStoryboardName = Bundle.main.infoDictionary?["UIMainStoryboardFile"] as? String else {
            assertionFailure("No UIMainStoryboardFile found in main bundle")
            return nil
        }
        
        return UIStoryboard(name: mainStoryboardName, bundle: Bundle.main)
    }
}
