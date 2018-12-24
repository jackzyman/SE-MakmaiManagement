//
//  DrugDB.swift
//  JongYa
//
//  Created by Methawee Punkaew on 19/12/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//

import Foundation
import GRDB


struct DrugDB : FetchableRecord, TableRecord, PersistableRecord  {
    
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["name"] = name
        container["detail"] = detail
        container["image"] = image
        container["price"] = price
        container["stock"] = stock
        
        container["sold"] = sold
        container["active"] = active
        container["date"] = date
    }
    
    mutating func didInsert(with rowID: Int64, for column: String?) {
        self.id = UUID().uuidString
    }
    
    var id : String = ""
    var name : String = ""
    var detail : String = ""
    var image : String = ""
    var price : Int = 0
    var stock : Int = 0
    var sold : Int = 0
    var active = true
    var date : String = ""

    enum Columns {
        static let  id = Column("id")
        static let  name = Column("name")
        static let  detail = Column("detail")
        static let  image = Column("image")
        static let  price = Column("price")
        static let  stock = Column("stock")
        
        static let  sold = Column("sold")
        static let  active = Column("active")
        static let  date = Column("date")
    }
    
    init(row: Row) {
        id = row[Columns.id]
        name = row[Columns.name]
        detail = row[Columns.detail]
        image = row[Columns.image]
        price = row[Columns.price]
        stock = row[Columns.stock]
        
        sold = row[Columns.sold]
        active = row[Columns.active]
        date = row[Columns.date]
    }
    
    init(id: String, name: String, detail: String, image: String, price: Int, stock: Int, sold: Int? = nil, date: String? = nil, active: Bool? = nil) {
        self.id = id
        self.name = name
        self.detail = detail
        self.image = image
        self.price = price
        self.stock = stock
        
        self.sold = sold ?? 0
        self.date = date ?? Date().toServerString()
        self.active = active ?? true
    }
    
//    init(name: String, detail: String, image: String, price: Int, stock: Int, sold: Int, date: String, active: Bool) {
//        self.id = UUID().uuidString
//        self.name = name
//        self.detail = detail
//        self.image = image
//        self.price = price
//        self.stock = stock
//    }
    
    mutating func setActive(isactive: Bool) { //}-> DrugDB {
        active = isactive
        date = Date().toServerString()
//        return self
    }
    
    mutating func upDateStock(_ num: Int) { //}-> DrugDB {
        stock = stock + num
//        return self
    }
    
    
    
    func toMappable() -> DrugInfo {
        return DrugInfo(id: id, name: name, detail: detail, image: image, price: price, stock: stock, sold: sold, date: date, active: active)
    }
    
    static let databaseTableName = "drug"
    static let databaseSelection: [SQLSelectable] = [Columns.id, 
                                                     Columns.name, 
                                                     Columns.detail, 
                                                     Columns.image, 
                                                     Columns.price, 
                                                     Columns.stock,  
                                                     Columns.sold, 
                                                     Columns.active,
                                                     Columns.date]
}
