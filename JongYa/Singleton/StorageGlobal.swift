//
//  GlobalStorage.swift
//  JongYa
//
//  Created by Jarukit Rungruang on 15/10/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//

import Foundation

class StorageGlobal: NSObject {
    
    private let storage = UserDefaults.standard
    
    public func clearStorage() {
        let domain = Bundle.main.bundleIdentifier!
        storage.removePersistentDomain(forName: domain)
        storage.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
    }
    
    private let LOGIN_KEY = "LOGIN_KEY"
    public func logout(){
        clearStorage()
    }
    
    public func isLogin() -> Bool {
        return storage.bool(forKey: LOGIN_KEY)
    }
    
    private let USER_KEY = "USER_KEY"
    
    public func login(_ info: UserInfo){
        storage.set(true, forKey: LOGIN_KEY)
        storage.synchronize()
        
        let archiverData = NSKeyedArchiver.archivedData(withRootObject: info.toJSON() )
        storage.set(archiverData , forKey: USER_KEY)
        storage.synchronize()
    }
    
    
    public func getUser() -> UserInfo? {
        if let placesData = storage.object(forKey: USER_KEY) as? NSData {
            if let archiverData = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? [String: Any] {
                return UserInfo(JSON: archiverData)
            }
        }
        return nil
    }
    
    
    
    
    
    private let ADD_CART_KEY = "ADD_CART_KEY"
    
    public func addCart(_ info: DrugInfo, amount: Int){
        let data = getCart()
        if data.items.count > 0 {
            for i in 0...data.items.count - 1 {
                if data.items[i].drug.id == info.id {
                    data.items[i].amount = data.items[i].amount + amount
                    addCart(data)
                    return
                }
            }
        }
        
        data.items.append(CartItem(drug: info, amount: amount))
        addCart(data)
    }
    
    
    public func addCart(_ info: CartInfo){
        let archiverData = NSKeyedArchiver.archivedData(withRootObject: info.toJSON() )
        storage.set(archiverData , forKey: ADD_CART_KEY)
        storage.synchronize()
    }
    
    
    public func getCart() -> CartInfo {
        if let placesData = storage.object(forKey: ADD_CART_KEY) as? NSData {
            if let archiverData = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? [String: Any] {
                return CartInfo(JSON: archiverData)!
            } else {
                return CartInfo()
            }
        } else {
            return CartInfo()
        }
    }
    public func resetCart(){
        let data = getCart() // ลบ ข้อมูลในรถเข็น
        data.items.removeAll()
        addCart(data)
    }
}

