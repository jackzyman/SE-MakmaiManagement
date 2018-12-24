//
//  EX-String.swift
//  YellowIsDad
//
//  Created by Jarukit Rungruang on 13/12/17.
//  Copyright © 2017 Jarukit Rungruang. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
}

extension String {
    /*
    mutating func mpPopLast(){
        self =  self.substring(to: (self.index(before: self.endIndex)))
    }
    func mpPopLast() -> String{
        return  self.substring(to: (self.index(before: self.endIndex)))
    }
 */
    
    func YSDreplace(before: String, after: String) -> String{
        return  self.replacingOccurrences(of: before, with: after, options: .literal, range: nil)
    }
    
    func YSDCount() -> Int {
        //return self.characters.endIndex.encodedOffset
        return self.characters.endIndex.encodedOffset
    }
    
    func YSDFind(_ text: String) -> Bool {
        return (self.range(of:text) != nil)
    }
    
    func YSDFindIndex(_ text: Character) -> Int? {
        if let index = self.lowercased().characters.index(of: text) {
            //print("Index: \(index)")
            return index.encodedOffset
        }
       return nil
    }
    
    func YSDSplit(_ text: String) -> [String] {
        var data : [String] = []
        data = self.components(separatedBy: " ")
        return data
        
    }
    
    func mpToDate_envc() -> Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en-US")
        return formatter.date(from: self)
    }
    
    func mpToDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"
        formatter.locale = Locale(identifier: "en-US")
        //let sendDate = formatter.date(from: date)
        return formatter.date(from: self)!
    }
    func YSDsubstring(start: Int, end: Int, tail: String = "") -> String {
        if self.YSDCount() < end {
            return self
        } else {
            let start = self.index(self.startIndex, offsetBy: start)
            let end = self.index(self.startIndex, offsetBy: end)
            
            let range = start..<end
            return self.substring(with: range) + tail
        }
    }
    
//    subscript (i: Int) -> Character {
//        return self[index(startIndex, offsetBy: i)]
//    } 
//    
//    subscript (i: Int) -> String {
//        return String(self[i] as Character)
//    }
    
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        let range: Range<Index> = start..<end
        //return String(self[Range(start ..< end)])
        return String(self[range])
    }
}

extension String {
    
    func index(of aString: String, startingFrom position: Int = 0) -> String.Index? {
        let start = index(startIndex, offsetBy: position)
        return self[start...].range(of: aString, options: .literal)?.lowerBound
    }
    
    func YSDValidPhoneNumber() -> Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func YSDValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    private func matches(pattern: String) -> Bool {
        let regex = try! NSRegularExpression(
            pattern: pattern,
            options: [.caseInsensitive])
        return regex.firstMatch(
            in: self,
            options: [],
            range: NSRange(location: 0, length: utf16.count)) != nil
    }
    
    func isValidURL() -> Bool {
        guard let url = URL(string: self) else { return false }
        if !UIApplication.shared.canOpenURL(url) {
            return false
        }
        
        let urlPattern = "^(http|https|ftp)\\://([a-zA-Z0-9\\.\\-]+(\\:[a-zA-Z0-9\\.&amp;%\\$\\-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|localhost|([a-zA-Z0-9\\-]+\\.)*[a-zA-Z0-9\\-]+\\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(\\:[0-9]+)*(/($|[a-zA-Z0-9\\.\\,\\?\\'\\\\\\+&amp;%\\$#\\=~_\\-]+))*$"
        return self.matches(pattern: urlPattern)
    }
}
