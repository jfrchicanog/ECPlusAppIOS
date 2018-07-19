//
//  AppDelegate.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 28/7/17.
//  Copyright © 2017 José Francisco Chicano García. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataController = DataController.dataController
    let daoPalabra: DAOPalabra = DAOFactory.getDAOPalabra()
    let preferences = UserDefaults.standard
    static let LANGUAGE = "language"
    static let RESOLUTION = "resolution"
    static let DEFAULT_LANGUAGE = "es"
    static let DEFAULT_RESOLUTION = Resolution.baja.rawValue
    static let SUPPORTED_LANGAUGES = ["es", "en", "nl", "de", "cat"]

    fileprivate func updateDatabase() {
        let databaseUpdate = DatabaseUpdate.getDatabaseUpdate()
        NSLog("Updating \(String(describing: preferences.string(forKey: AppDelegate.LANGUAGE)))")
        databaseUpdate.updateSindromes(language: preferences.string(forKey: AppDelegate.LANGUAGE)!)
        databaseUpdate.updatePalabras(language: preferences.string(forKey: AppDelegate.LANGUAGE)!, resolution: Resolution.baja)
    }
    
    fileprivate func computeDefaultLanguage() -> String {
        let preferred  = NSLocale.preferredLanguages.filter({AppDelegate.SUPPORTED_LANGAUGES.contains($0)})
        if preferred.isEmpty {
            return AppDelegate.DEFAULT_LANGUAGE
        } else {
            return preferred.first!
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if preferences.string(forKey: AppDelegate.LANGUAGE) == nil {
            preferences.set(computeDefaultLanguage(), forKey: AppDelegate.LANGUAGE)
            preferences.set(AppDelegate.DEFAULT_RESOLUTION, forKey: AppDelegate.RESOLUTION)
            
        }
        
        // Override point for customization after application launch.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: OperationQueue.main, using: {_ in
            NSLog("Updating")
            self.updateDatabase()
        })
        
        updateDatabase()
        
        return true
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        dataController.saveMainContext()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

