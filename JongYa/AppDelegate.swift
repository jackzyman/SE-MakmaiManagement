//
//  AppDelegate.swift
//  JongYa
//
//  Created by Jarukit Rungruang on 15/10/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

import GRDB
var appDatabase: DatabaseQueue!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    public func createMenuView() {
        let login = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "RootMenu")
        self.window?.rootViewController = login
        self.window?.makeKeyAndVisible()
    }
   
   public func createLoginView() {
      let login = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "RootLogin")
      self.window?.rootViewController = login
      self.window?.makeKeyAndVisible()
   }
   
   
    private func setupDatabase(_ application: UIApplication) throws {
        let fileManager = FileManager.default
        let dbPath = try fileManager
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("Jongya.db")
            .path
        if !fileManager.fileExists(atPath: dbPath) {
            let dbResourcePath = Bundle.main.path(forResource: "Jongya", ofType: "db")!
            try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
        }
        appDatabase = try DatabaseQueue(path: dbPath)
        appDatabase.setupMemoryManagement(in: application)
        
//         SELECT id, name FROM players
                 try! appDatabase.inDatabase { db in
                    let drug = try DrugDB.order(Column("sold").desc).fetchAll(db)
                    let order = try OrderDB.fetchAll(db)
                    let user = try UserDB.fetchAll(db)
                    let invoie = try InvoieDB.fetchAll(db)
                    
                    print(drug[0])
//                    let player2 = try ProvDB.fetchAll(db)
//                    print(player2[0])
                }
    }
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        print(Date().toServerString())
//        let stri = Date().toServerString()
//        let date = stri.mpToDate()
        // database config
        
        try! setupDatabase(application)
        
        if AppGlobal.storage.isLogin(){
        createMenuView()
            }
        return SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let appId: String = SDKSettings.appId
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEventsLogger.activate(application)
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

