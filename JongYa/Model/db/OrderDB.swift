//
//  OrderDB.swift
//  JongYa
//
//  Created by Methawee Punkaew on 22/12/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//

import Foundation
import GRDB


//`productId`    TEXT,
//`id`    TEXT NOT NULL,
//`invoiceId`    TEXT,
//`amount`    INTEGER

struct OrderDB : FetchableRecord, TableRecord, PersistableRecord {
    
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["productId"] = productId
        container["invoiceId"] = invoiceId
        container["amount"] = amount
    }
    
    mutating func didInsert(with rowID: Int64, for column: String?) {
        self.id = UUID().uuidString
    }
    
    var id : String = ""
    var productId : String = ""
    var invoiceId : String = ""
    var amount : Int = 0 
    
    enum Columns {
        static let  id = Column("id")
        static let  productId = Column("productId")
        static let  invoiceId = Column("invoiceId")
        static let  amount = Column("amount")
    }
    
    init(row: Row) {
        id = row[Columns.id]
        productId = row[Columns.productId]
        invoiceId = row[Columns.invoiceId]
        amount = row[Columns.amount]
    }
    
    init(id: String, productId: String, invoiceId: String, amount: Int) {
        self.id = id
        self.productId = productId
        self.invoiceId = invoiceId
        self.amount = amount
    }
    
    init(productId: String, invoiceId: String, amount: Int) {
        self.id = NSUUID().uuidString
        self.productId = productId
        self.invoiceId = invoiceId
        self.amount = amount
    }
    
    
    //        func toMappable() -> UserInfo {
    //            return UserInfo(id: id, name: name, role: role, email: email)
    //        }
    
    static let databaseTableName = "order"
    static let databaseSelection: [SQLSelectable] = [Columns.id, 
                                                     Columns.productId, 
                                                     Columns.invoiceId, 
                                                     Columns.amount]
}


