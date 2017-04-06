//
//  AppDelegate.swift
//  GeoFence
//
//  Created by netNORIMINGCONCEPTION on 2017/03/31.
//  Copyright © 2017年 flatLevel56. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

//        UIApplication.shared.cancelAllLocalNotifications();
//        let notificationSetting = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
//        application.registerUserNotificationSettings(notificationSetting)
        
//        let notif = UILocalNotification()
//        notif.fireDate = NSDate(timeIntervalSinceNow: 5) as Date //5秒後
//        notif.timeZone = NSTimeZone.default
//        notif.alertBody = "通知のメッセージだよ"
//        notif.alertAction = "OK"
//        notif.soundName = UILocalNotificationDefaultSoundName
//        UIApplication.shared.scheduleLocalNotification(notif)
        
//        UNUserNotificationCenter.Current.RequestAuthorization (UNAuthorizationOptions.Alert, (approved, err) => {
//            // Handle approval
//            });

        
        
//        let notificationTypes: UIUserNotificationType
//        
//        notificationTypes = [.alert , .sound]
//        
//        
//        
//        let newNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
//        
//        UIApplication.shared.registerUserNotificationSettings(newNotificationSettings)
        
        if #available(iOS 10.0, *) {
            // iOS 10
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                if error != nil {
                    return
                }
                
                if granted {
                    debugPrint("通知許可")
                } else {
                    debugPrint("通知拒否")
                }
            })
            
        } else {
            // iOS 9
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        
       
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
    }


}

