//
//  UserInfo.swift
//  JongYa
//
//  Created by Methawee Punkaew on 19/12/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//

import Foundation
import ObjectMapper



class UserInfo : Mappable {
    
    var id : String = ""
    var name : String = ""
    var role : Int = 0
    var email : String = ""
    
    required init?(map: Map){}
    
    init(id: String, name: String, role: Int, email: String) {
        self.id = id
        self.name = name
        self.role = role
        self.email = email
    }
    
    init(name: String, role: Int, email: String) {
        self.id = NSUUID().uuidString
        self.name = name
        self.role = role
        self.email = email
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        role <- map["role"]
        email <- map["email"]
    }
    
}
