//
//  DatabaseGobal.swift
//  JongYa
//
//  Created by Methawee Punkaew on 22/12/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//

import Foundation
import GRDB
class DatabaseGobal: NSObject {
    
    
    
    func checkInvoieDBStatus(){
        try! appDatabase.inDatabase { db in
            let invoieDBs = try InvoieDB.fetchAll(db)
            if invoieDBs.count > 0 {
                for i in 0...invoieDBs.count - 1 {
                    if invoieDBs[i].status == OrderStatus.watting.rawValue {
                        if !invoieDBs[i].enddate.mpToDate().mpTimeLeft().1 {
                            let invoice = invoieDBs[i]
                            let orders =  try OrderDB.filter(Column("invoiceId").like(invoice.id)).fetchAll(db) 
                            if orders.count > 0 {
                                for i in 0...orders.count - 1 {
                                    if let drug = try DrugDB.filter(Column("id").like(orders[i].productId)).fetchOne(db) {
                                        
                                        try db.execute(
                                            "UPDATE drug SET stock = :stock WHERE id = :id",
                                            arguments: ["stock": drug.stock + orders[i].amount, "id": drug.id])
                                        
                                        try db.execute(
                                            "UPDATE invoice SET status = :status WHERE id = :id",
                                            arguments: ["status": 1, "id": invoice.id])
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
