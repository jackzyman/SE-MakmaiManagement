//
//  Invoie.swift
//  JongYa
//
//  Created by Methawee Punkaew on 22/12/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//

import Foundation
import GRDB

//`id`    TEXT NOT NULL,
//`userId`    TEXT,
//`date`    INTEGER,
//`priceTotal`    INTEGER

struct InvoieDB : FetchableRecord, TableRecord, PersistableRecord {
        
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["userId"] = userId
        container["priceTotal"] = priceTotal
        container["date"] = date
        container["status"] = status
        container["enddate"] = enddate
    }
    
    mutating func didInsert(with rowID: Int64, for column: String?) {
        self.id = UUID().uuidString
    }
    
        var id : String = ""
        var userId : String = ""
        var priceTotal : Int = 0
        var date : String = ""
        var status = 0
        var enddate = ""
    
        enum Columns {
            static let  id = Column("id")
            static let  userId = Column("userId")
            static let  priceTotal = Column("priceTotal")
            static let  date = Column("date")
            static let  status = Column("status")
            static let  enddate = Column("enddate")
        }
        
        init(row: Row) {
            id = row[Columns.id]
            userId = row[Columns.userId]
            date = row[Columns.date]
            priceTotal = row[Columns.priceTotal]
            status = row[Columns.status]
            enddate = row[Columns.enddate]
        }
    
    mutating func setStatus(_ status: Int) {
        self.status = status
    }
        
    init(id: String, userId: String, date: String, enddate: String , priceTotal: Int) {
            self.id = id
            self.userId = userId
            self.date = date
            self.priceTotal = priceTotal
            self.enddate = enddate

        }
        
//        init(userId: String, date: String, priceTotal: Int) {
//            self.id = NSUUID().uuidString
//            self.userId = userId
//            self.date = date
//            self.priceTotal = priceTotal
//        }
        
//        func toMappable() -> UserInfo {
//            return UserInfo(id: id, name: name, role: role, email: email)
//        }
        
        static let databaseTableName = "invoice"
        static let databaseSelection: [SQLSelectable] = [Columns.id, 
                                                         Columns.userId, 
                                                         Columns.date, 
                                                         Columns.priceTotal, 
                                                         Columns.status,
                                                         Columns.enddate]
}

