//
//  AppDelegate.swift
//  3Banko
//
//  Created by Murat Baykor on 27.10.2020.
//

import UIKit
import Firebase
import GoogleMobileAds




@main
class AppDelegate: UIResponder, UIApplicationDelegate {
//    var userUid: String? {
//        didSet {
//            let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
//            print("DEBUG: userUid setted as \(userUid!)")
//            print("DEBUG: launched before: \(launchedBefore)")
//            if launchedBefore == false {
//                FirebaseManager.shared.firstLaunchOption(with: userUid!) { error in
//                    if let error = error {
//                        print("DEBUG: error first launch option with \(error)")
//                    } else {
//                        print("DEBUG: first launch option success and firs launc as true")
//                        UserDefaults.standard.set(true, forKey: "launchedBefore")
//                    }
//                }
//            }
//        }
//    }
    let gcmMessageIDKey = "gcm.foytingo_ID"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        

        
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [ .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().subscribe(toTopic: "3banko")
        
        Messaging.messaging().delegate = self
        
        
        return true
    }
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        //if let messageID = userInfo[gcmMessageIDKey] {
        //    print("Message ID: \(messageID)")
        //}
        
        // Print full message.
        //print(userInfo)
    }
    
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        //if let messageID = userInfo[gcmMessageIDKey] {
        //    print("Message ID: \(messageID)")
        //}
        
        // Print full message.
        //print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    //    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    //        completionHandler([.banner, .badge, .sound])
    //    }
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        // if let messageID = userInfo[gcmMessageIDKey] {
        //    print("Message ID: \(messageID)")
        // }
        
        // Print full message.
        // print(userInfo)
        
        // Change this to your preferred presentation option
        
        if #available(iOS 14, *) {
            completionHandler([.sound])
        } else {
            completionHandler([.sound])
        }
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        //let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        //if let messageID = userInfo[gcmMessageIDKey] {
        //    print("Message ID: \(messageID)")
        //}
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        //print(userInfo)
        
        completionHandler()
    }
    
    
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        //print("Firebase registration token: \(String(describing: fcmToken))")
        let dataDict:[String: String] = ["token": fcmToken ]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
}
