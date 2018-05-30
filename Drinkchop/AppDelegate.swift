////
//  AppDelegate.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

import GoogleMaps
import GooglePlaces
import GoogleMapsDirections
import UserNotifications
import Stripe

import IQKeyboardManagerSwift

import Alamofire

import Firebase
import FirebaseInstanceID
import FirebaseMessaging

import GoogleSignIn
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    fileprivate var dataWhenDeviceIsSuspended:Bool = false
    fileprivate var isNotificationTapped:Bool = false
    fileprivate var fcmUserInfo:[String:Any] = [:]
    
    var window: UIWindow?

    let googleClientID = "791927086780-mue5c4gcjm8ml6hu7qc51u5qe1prlb2b.apps.googleusercontent.com"
    
    let mapsKey = "AIzaSyDSiGUk3XbcaXjpq0C3IcG9I94NBzgRPvk"
    let directionsKey = "AIzaSyDvkMCRWfMr5y76ORRW2bFvHa-HJM8gJlg"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.sharedManager().enable = true
        
        
        GIDSignIn.sharedInstance().clientID = googleClientID
        GIDSignIn.sharedInstance().delegate = self
        
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        application.statusBarStyle = .lightContent
        
        GMSServices.provideAPIKey(mapsKey)
        GMSPlacesClient.provideAPIKey(mapsKey)
        GoogleMapsDirections.provide(apiKey: directionsKey)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .InstanceIDTokenRefresh,
                                               object: nil)
        registerForPushNotifications()
        if let notificationData = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String:Any] {
            fcmUserInfo = notificationData
            setupNotificationServices(userInfo: notificationData)
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let settingsData = UserDefaults.standard.data(forKey: settingsDefaultsID) else {
            print("settings not found..")
            return true
        }
        guard let settings = try? decoder.decode(Settings.self, from: settingsData) else {
            return true
        }
        Settings.iSettings = settings
        return true
    }
    
    private func application(application: UIApplication,
                     openURL url: URL, options: [String: AnyObject]) -> Bool {
        if url.absoluteString.contains("1736503889764137") {
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication.rawValue] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation.rawValue])
        }
         let GSigninHandle = GIDSignIn.sharedInstance().handle(url as URL?,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication.rawValue] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsKey.annotation.rawValue])
        return GSigninHandle
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
            
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                object: user,
                userInfo: ["statusText": "Signed in user:\n\(fullName ?? "")"])
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
    }
    
    func registerForPushNotifications() {
        
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func setupNotificationServices(userInfo: [String:Any]) {
        NotificationCenter.default.post(name: Notification.Name("RideRequestResponse"), object: userInfo)
        
    }

    
    let gcmMessageIDKey = "gcm.message_id"
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    // [START refresh_token]
    
    func saveFCMToken(token: String) {
        UserDefaults.standard.set(token, forKey: fcmTokenDefaultsID)
    }
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = InstanceID.instanceID().token() {
            saveFCMToken(token: refreshedToken)
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    
    // [START connect_to_fcm]
    func connectToFcm() {
        // Won't connect since there is no token
        guard InstanceID.instanceID().token() != nil else {
            return
        }
        let refreshedToken = InstanceID.instanceID().token()
        saveFCMToken(token: refreshedToken!)
        // Disconnect previous FCM connection if it exists.
        Messaging.messaging().shouldEstablishDirectChannel = false
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    // [END connect_to_fcm]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        //    FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.unknown)
    }
    
    // [START connect_on_active]
    func applicationDidBecomeActive(_ application: UIApplication) {
        if dataWhenDeviceIsSuspended {
            if let window = self.window {
                if let controller = window.rootViewController as? UINavigationController {
                    setupNotificationServices(userInfo: fcmUserInfo)
                    //print(controller.visibleViewController)
                }
            }
        }
        connectToFcm()
    }
    // [END connect_on_active]
    // [START disconnect_from_fcm]
    func applicationDidEnterBackground(_ application: UIApplication) {
        dataWhenDeviceIsSuspended = false
        Messaging.messaging().shouldEstablishDirectChannel = false
        print("Disconnected from FCM.")
    }
    // [END disconnect_from_fcm]
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}


// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func checkForNotificationFire(data: [String:Any]) {
        if let window = self.window {
            if let controller = window.rootViewController as? UINavigationController {
                setupNotificationServices(userInfo: fcmUserInfo)
                NotificationsUtil.fireNotification(data: fcmUserInfo)
            }
        }
    }
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        dataWhenDeviceIsSuspended = false
        fcmUserInfo = userInfo as! [String : Any]
        fcmUserInfo["isNotificationTapped"] = false
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        if UIApplication.shared.applicationState == .active {
            checkForNotificationFire(data: fcmUserInfo)
        } else if UIApplication.shared.applicationState == .background || UIApplication.shared.applicationState == .inactive  {
            
            
            // Print full message.
            print(userInfo)
            let notification = UILocalNotification()
            notification.alertBody = userInfo["subject"] as? String // text that will be displayed in the notification
            notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
            notification.fireDate = NSDate(timeIntervalSinceNow: 0) as Date // todo item due date (when notification will be fired). immediately here
            notification.soundName = UILocalNotificationDefaultSoundName // play default sound
            UIApplication.shared.scheduleLocalNotification(notification)
        }
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        dataWhenDeviceIsSuspended = true
        fcmUserInfo = userInfo as! [String:Any]
        fcmUserInfo["isNotificationTapped"] = true
        checkForNotificationFire(data: fcmUserInfo)
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        completionHandler()
    }
}
// [END ios_10_message_handling]
// [START ios_10_data_message_handling]
extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        saveFCMToken(token: fcmToken)
        print("InstanceID token: \(fcmToken)")
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
        setupNotificationServices(userInfo: remoteMessage.appData as! [String : Any])
    }
    
    // Receive data message on iOS 10 devices while app is in the foreground.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
        setupNotificationServices(userInfo: remoteMessage.appData as! [String : Any])
    }
}
// [END ios_10_data_message_handling]
