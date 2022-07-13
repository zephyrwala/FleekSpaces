//
//  AppDelegate.swift
//  FleekSpaces
//
//  Created by Mayur P on 31/05/22.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
import UserNotifications


@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {


    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, _ in
            
            guard success else {
                
                return
            }
            print("Success in APNs registery")
        }
            application.registerForRemoteNotifications()
            
//            return true
            
    
        
      
        
        
//        FirebaseApp.configure()
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableDebugging = true
        IQKeyboardManager.shared.overrideKeyboardAppearance = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.keyboardAppearance = .dark
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10.0
//
//        IQKeyboardManager.shared.toolb

//        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(ChatViewController.self)
////
//        IQKeyboardManager.shared.disabledToolbarClasses.append(ChatViewController.self)
        IQKeyboardManager.shared.toolbarTintColor = UIColor(named: "BtnGreenColor")
        
     
        // Override point for customization after application launch.
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            
            guard let thisToken = token else {
                print("no token")
                return
            }

            print("TOKENS here:\(thisToken)")
        }
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

