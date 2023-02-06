//
//  AppDelegate.swift
//  FleekSpaces
//
//  Created by Mayur P on 31/05/22.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {


    var chatUser: ChatUser?
 

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        FirebaseApp.configure()
        FirebaseManager.shared
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
//        IQKeyboardManager.shared.enableDebugging = true
//        IQKeyboardManager.shared.overrideKeyboardAppearance = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(RegisterVC.self)
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(ChatUIViewController.self)
        IQKeyboardManager.shared.keyboardAppearance = .dark
//        IQKeyboardManager.shared.keyboardDistanceFromTextField = 9.0


        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(ChatUIViewController.self)
////
//        IQKeyboardManager.shared.disabledToolbarClasses.append(ChatsViewController.self)
        IQKeyboardManager.shared.toolbarTintColor = UIColor(named: "BtnGreenColor")
        
     
        // Override point for customization after application launch.
        return true
    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        
//        
//    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            
            guard let thisToken = token else {
                print("no token")
                return
            }

            print("TOKENS here:\(thisToken)")
            let defaults = UserDefaults.standard
            defaults.set(thisToken, forKey: "userFCMtoken")
           
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

