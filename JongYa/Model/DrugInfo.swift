//
//  DrugInfo.swift
//  JongYa
//
//  Created by Methawee Punkaew on 30/11/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//

import ObjectMapper


class DrugInfo : Mappable {
    var id : String = ""
    var name : String = ""
    var detail : String = ""
    var image : String = ""
    var price : Int = 0
    var stock : Int = 0
    //    var amount : Int = 0
    
    var sold : Int = 0
    var active = true
    var date : String = ""
    
    required init?(map: Map){}
    
    init(id: String, name: String, detail: String, image: String, price: Int, stock: Int, sold: Int, date: String, active: Bool) {
        self.id = id
        self.name = name
        self.detail = detail
        self.image = image
        self.price = price
        self.stock = stock
        
        self.sold = sold
        self.date = date 
        self.active = active
    }
    
    func toDB() -> DrugDB {
        return DrugDB(id: id, name: name, detail: detail, image: image, price: price, stock: stock, sold: sold, date: date, active: active)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        detail <- map["detail"]
        image <- map["image"]
        price <- map["price"]
        stock <- map["stock"]
        
        sold <- map["sold"]
        date <- map["date"]
        active <- map["active"]
        
    }
}


class CartInfo : Mappable {
    var items : [CartItem] = []
    
    required init?(map: Map){}
    
    init() {
    }
    
    func mapping(map: Map) {
        items <- map["items"]
        
    }
    
}

class CartItem : Mappable {
    var drug : DrugInfo!
    var amount : Int = 0
    var date : Date!
    
    required init?(map: Map){}
    
    init(drug: DrugInfo, amount: Int) {
        self.drug = drug
        self.amount = amount
        self.date = Date()
    }
    
    func resetItem(){
        
    }
    
    func mapping(map: Map) {
        drug <- map["drug"]
        amount <- map["amount"]
        date <- map["date"]
    }
    
    func totalPrice() -> Int{
        return drug.price * amount
    }
}
