//
//  userDB.swift
//  JongYa
//
//  Created by Methawee Punkaew on 22/12/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//

import Foundation
import GRDB

//`id`    INTEGER NOT NULL,
//`name`    TEXT,
//`role`    INTEGER,
//`email`    INTEGER

struct UserDB : FetchableRecord, TableRecord, PersistableRecord {
    
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["name"] = name
        container["role"] = role
        container["email"] = email
    }
    
    mutating func didInsert(with rowID: Int64, for column: String?) {
        self.id = UUID().uuidString
    }
    
    var id : String = ""
    var name : String = ""
    var role : Int = 0
    var email : String = ""
    
    
    
    enum Columns {
        static let  id = Column("id")
        static let  name = Column("name")
        static let  role = Column("role")
        static let  email = Column("email")
    }
    
    init(row: Row) {
        id = row[Columns.id]
        name = row[Columns.name]
        role = row[Columns.role]
        email = row[Columns.email]
    }
    
    init(id: String, name: String, role: Int, email: String) {
        self.id = id
        self.name = name
        self.role = role
        self.email = email
    }
    
    init(name: String, role: Int, email: String) {
        self.id = UUID().uuidString
        self.name = name
        self.role = role
        self.email = email
    }
    
    func toMappable() -> UserInfo {
        return UserInfo(id: id, name: name, role: role, email: email)
    }
    
    static let databaseTableName = "user"
    static let databaseSelection: [SQLSelectable] = [Columns.id, 
                                                     Columns.name, 
                                                     Columns.role, 
                                                     Columns.email]
    
   
}

