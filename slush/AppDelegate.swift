//
//  AppDelegate.swift
//  slush
//
//  Created by Kareem Benaissa on 8/6/23.
//

import UIKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }

    
    // ... other delegate methods, if you need them ...
//    func applicationWillResignActive(_ application: UIApplication) {
//        // Pause ongoing tasks, if needed.
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Save app data, invalidate timers, etc.
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Undo the changes made when entering the background.
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart paused (or not yet started) tasks.
//    }
//
//    func applicationWillTerminate(_ application: UIApplication) {
//        // Save data and perform clean-up.
//    }
}
