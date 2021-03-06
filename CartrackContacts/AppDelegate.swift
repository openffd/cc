//
//  AppDelegate.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initializeSharedDatabase()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

private extension AppDelegate {
    func initializeSharedDatabase() {
        let sharedDatabase = SQLite.Database.shared
        print("[SQLite3] Successfully opened connection to shared database.")
        do {
            try sharedDatabase.createUserTable()
            print("[SQLite3] The `user` table has been created.")
            
            let key = "SampleUserInserted"
            if !UserDefaults.standard.bool(forKey: key) {
                try sharedDatabase.insert(username: "cartrack", digest: "123".sha256Digest, country: "Philippines")
                UserDefaults.standard.set(true, forKey: key)
            }
        } catch {
            print("[SQLite3] " + error.localizedDescription)
        }
    }
}
