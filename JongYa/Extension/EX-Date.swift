//
//  EX-Date.swift
//  YellowIsDad
//
//  Created by Jarukit Rungruang on 13/12/17.
//  Copyright © 2017 Jarukit Rungruang. All rights reserved.
//

import Foundation
import UIKit

extension Data {
    
}


extension Date {
    
    func toServerString() -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"
        return formatter.string(from: self)
    }
    
    func mpTimeLeft() -> (String, Bool){
        
        let now = Date()
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = NSTimeZone.local
        let units = Set([Calendar.Component.hour, Calendar.Component.minute])
        let difference = calendar.dateComponents(units, from: now , to: self)
        
        guard 
            let hour = difference.hour,
            let minute = difference.minute else{
                return ("", false)
        }
        

        if hour > 0 || minute > 0 {
            var text = ""
            if hour > 0 {
                text = text + "\(hour) ชม. "
            }
            if minute > 0 {
                text = text + "\(minute) นาที "
            }
            return (text, true)
        }
        else {
            return ("หมดเวลา", false)
        }
        
        
    }
    
//    func mpHourLeft(_ now: Date) -> String{
//        
//        var calendar = Calendar.autoupdatingCurrent
//        calendar.timeZone = NSTimeZone.local
//        let units = Set([Calendar.Component.year,
//                         Calendar.Component.month,
//                         Calendar.Component.day,
//                         Calendar.Component.hour,
//                         Calendar.Component.minute])
//        let difference = calendar.dateComponents(units, from: self, to: now)
//        guard 
//            let day = difference.day,
//            let hour = difference.hour,
//            let minute = difference.minute else{
//                return ""
//        }
//        
//        var strh = ""
//        var strm = ""
//        let _hour = (day*24) + hour
//                
//        if _hour > 0 {
//            strh = "\(_hour) \(AppGlobal.lang.getText(.hour))."
//        } 
//        if minute > 0 {
//            strm = "\(minute) \(AppGlobal.lang.getText(.minute))."
//        }
//        
//            return "\(strh) \(strm)"
//            
//        
//    }
    
//    func mpTimeAgo() -> String {
//        
//        let now = Date()
//        var calendar = Calendar.autoupdatingCurrent
//        calendar.timeZone = NSTimeZone.local
//        let units = Set([Calendar.Component.year,
//                         Calendar.Component.month,
//                         Calendar.Component.day,
//                         Calendar.Component.hour,
//                         Calendar.Component.minute])
//        let difference = calendar.dateComponents(units, from: self, to: now)
//        guard 
//            let day = difference.day,
//            let hour = difference.hour,
//            let minute = difference.minute else{
//                return ""
//        }
//        if day < 7 {
//            if day > 0 {
//                if hour > 12 {
//                    return "\(day + 1) วัน \(AppGlobal.lang.getText(.ago))"
//                } else {
//                    return "\(day) วัน \(AppGlobal.lang.getText(.ago))"
//                }
//            } 
//            else {
//                if hour > 0 {
//                    return "\(hour) \(AppGlobal.lang.getText(.hour)) \(AppGlobal.lang.getText(.ago))"
//                } else {
//                    return "\(minute) \(AppGlobal.lang.getText(.minute)) \(AppGlobal.lang.getText(.ago))"
//                }
//            }
//        } else {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd:MM:yyyy"
//            formatter.timeZone = NSTimeZone.local
//            return formatter.string(from: self)
//        }
//    }
    
    func mpCompareHour(_ _hour: Int) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        let compareHour = calendar.date(byAdding: .hour , value: _hour, to: self)
        if compareHour! < now {
            return true
        } else {
            return false
        }
        
    }
    
    func mpTranIDDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMdd"
        formatter.locale = Locale(identifier: "en_US")
        return UUID().uuidString + "-" + formatter.string(from: self)
    }
    
    
    func mpShotDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: self)
    }
    
    func mpMonthStr() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        formatter.locale = Locale(identifier: "th_TH")
        return formatter.string(from: self)
    }
    
    func mpYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: self)
    }
    
    func mpThaiDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM y"
        formatter.locale = Locale(identifier: "th_TH")
        return formatter.string(from: self)
    }
    
//    func mpToService() -> String {
//        let formatter = DateFormatter()
//        var mont = "\(self.month)"
//        if self.month < 10 {
//            mont = "0" + mont
//        }
//        formatter.dateFormat = "yyyy-\(mont)-dd HH:mm"
//        formatter.locale = Locale(identifier: "en_US")
//        return formatter.string(from: self)
//    }
//    
//    func mpToDate() -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd MMMM yyyy"
//        if AppGlobal.storage.getLanguage() {
//        formatter.locale = Locale(identifier: "en_US")
//        } else {
//            formatter.locale = Locale(identifier: "th_TH")
//        }
//        return formatter.string(from: self)
//    }
    
    func mpDayInt() -> Int {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        //formatter.locale = Locale(identifier: "th-TH")
        formatter.locale = Locale.current
        return Int(formatter.string(from: self))!
    }
    
    func mpMonthInt() -> Int {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        //formatter.locale = Locale(identifier: "th-TH")
        formatter.locale = Locale.current
        return Int(formatter.string(from: self))!
    }
    
    func mpTimeOnly() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = NSTimeZone.local
        return formatter.string(from: self)
    }
}



