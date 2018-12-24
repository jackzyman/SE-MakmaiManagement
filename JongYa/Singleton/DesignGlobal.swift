//
//  GlobalDesign.swift
//  JongYa
//
//  Created by Jarukit Rungruang on 15/10/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//

import Foundation
import UIKit

enum Viewstyle {
    case paging
    case statusbar
    case navbar
}

enum Textstyle {
    case bold
    case normal
}

enum Sizestyle {
    case normal
    case small
    case verysmall
    case large
    case toppic
    case detailToppic
    case nav
    case button
    case null
    case paging
}

enum DeviceModel {
    case iPhone5_5s_5c
    case iPhone6_6s_7_8
    case iPhone6_6s_7_8_Plus
    case iPhoneX
    case unknown
}

class DesignGlobal: NSObject {
    
    public let screenSize = UIScreen.main.bounds.size
    public let statusBarHeight = UIApplication.shared.statusBarFrame.height
    public let noUserImage = UIImage(named: "no-user-image")!
    public let noImage = UIImage(named: "no-image")!
    
    public func getBuildVersion() -> String {
        if let bundle = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String {
            return bundle
        } else {
            return ""
        }
    }
    
    public func getVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String {
            return version
        } else {
            return ""
        }
    }
    
    public func getDeviceModel() -> DeviceModel{
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                return .iPhone5_5s_5c
            case 1334:
                return .iPhone6_6s_7_8
            case 2208:
                return .iPhone6_6s_7_8_Plus
            case 2436:
                return .iPhoneX
            default:
                return .unknown
            }
        } else {
            return .unknown
        }
    }
    
    public func getSize(_ style: Sizestyle = .normal, size: CGFloat = 0) -> CGFloat{
        switch style {
        case .large:
            return 40
        case .normal:
            return 16
        case .small:
            return 12
        case .verysmall:
            return 10
        case .toppic:
            return 30
        case .detailToppic:
            return 20
        case .nav:
            return 20
        case .button: 
            return 18
        case .paging: 
            return 14
        default :
            return size
        }
    }
    
    public func getViewHeight(_ style: Viewstyle) -> CGFloat{
        switch style {
        case .paging:
            return 40
        case .navbar:
            return 40
        case .statusbar:
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    
    public func getColor(_ color: Colorstyle = .text) -> UIColor{
        switch color {
        case .facebook:
            return UIColor("#3b5998")
        case .coin:
            return UIColor("#edbe49")
        case .text:
            return UIColor("#2F2F2F")
        case .placeholder:
            return UIColor("#999999")
        case .textLight:
            return UIColor("#6C6C6C")
        case .main:
            return UIColor("#e15301") 
        case .secondary :
            return UIColor("#93c1fc") 
        case .green:
            return UIColor("#2BDD68")
        case .greenLight:
            return UIColor("#c4d558")
        case .orange:
            return UIColor("#f5b769")
        case .purple: 
            return UIColor("#7a64f6")
        case .red:
            return UIColor("#FA4343")
        case .blue:
            return UIColor("#6284f7")
        case .white:
            return UIColor.white
        case .backgroudLight:
            return UIColor("#CBC6BC")
        case .backgroudDarK:
            return UIColor("#66646F")
        case .table:
            return UIColor("#FAFAFA")
        case .startColor:
            return UIColor("#7FD6F7")
        case .endColor:
            return UIColor("#C2ECFC")
        case .highlight:
            return UIColor("#FFD916")
        case .yellow:
            return UIColor("#FFD916")
        case .grey:
            return UIColor("#E2E3E3")
        default :
            return UIColor.clear
        }
    }
    
}

enum Colorstyle {
    case backgroudLight
    case backgroudDarK
    case highlight
    case main
    case facebook
    case placeholder
    case text
    case textLight
    
    case white
    case blue
    case red
    case green
    case greenLight
    case orange
    case purple
    case table
    case secondary
    case null
    case yellow
    case grey
    case startColor
    case endColor
    case coin
}


