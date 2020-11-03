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
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        FirebaseManager.shared.authAnonymous { (error) in
            if let error = error {
                print("DEBUG: AuthError \(error)")
            } else {
                guard let userUid = FirebaseManager.shared.getSingedUserUid() else {
                    print("DEBUG: UserUid alinamadi.")
                    return
                }
                
                if launchedBefore {
                    print("DEBUG: Daha once acildi userIUD: \(userUid)")
                } else {
                    print("DEBUG: Ilk defa acildi ve user document olsuturuldu")
                    
                    FirebaseManager.shared.firstLaunchOption(with: userUid) { error in
                        if let error = error {
                            print("DEBUG: Error first launc option \(error)")
                        } else {
                            print("DEBUG: All setup Complete and ready. Launced before setted true")
                            UserDefaults.standard.set(true, forKey: "launchedBefore")
                        }
                    }
                }
            }
        }
        

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
    
    
}

