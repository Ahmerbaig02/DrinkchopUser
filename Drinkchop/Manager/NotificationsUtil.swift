//
//  NotificationsUtil.swift
//  Momentum
//
//  Created by Ahmer Baig on 22/11/2017.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Whisper
import AudioToolbox

class NotificationsUtil {
    
    static var currentNavController:UINavigationController!
    
    
    class func setSuperView(navController: UINavigationController) {
        self.currentNavController = navController
    }
    
    class func removeFromSuperView() {
        self.currentNavController = nil
    }
    
    class func fireNotification(data: [String:Any]) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let settingsData = UserDefaults.standard.data(forKey: settingsDefaultsID) else {
            allowNotificationFire(data: data)
            print("settings not found..")
            return
        }
        guard let settings = try? decoder.decode(Settings.self, from: settingsData) else {
            allowNotificationFire(data: data)
            return
        }
        performSettingsActions(settings: settings)
        if settings.settingsNotification == "1" {
            allowNotificationFire(data: data)
        }
    }
    
    class func allowNotificationFire(data: [String:Any]) {
        if let notification_id = data["title"] as? String {
            if data["isNotificationTapped"] as! Bool == true {
                self.performNotificationTypeAction(type: notification_id, jsonMessage: data)
                //do something on notification tappe, app in background state
            } else {
                guard let aps = data["aps"] as? [String:Any] else {return}
                guard let alert = aps["alert"] as? [String:Any] else {return}
                guard let Title = alert["title"] as? String else {return}
                let Body = alert["body"] as? String ?? Title
                let notificationShout = Announcement(title: Title, subtitle: Title, image: #imageLiteral(resourceName: "logo"), duration: TimeInterval(10), action: {
                    self.performNotificationTypeAction(type: notification_id, jsonMessage: data)
                    print("notification tapped")
                })
                Whisper.hide()
                Whisper.show(shout: notificationShout, to: self.currentNavController)
            }
        }
    }
    
    class func performSettingsActions(settings: Settings) {
        if settings.settingsSound == "1" {
            AudioServicesPlayAlertSound(SystemSoundID(1016))
        } else {
            print("no sound")
        }
        if settings.settingsVibrate == "1" {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        } else {
            print("no viberation")
        }
        if settings.settingsLed == "1" {
            
        } else {
            
        }
        if settings.settingsFlashScreen == "1" {
            blinkScreen()
        } else {
            print("no blink")
        }
    }
    
    class func blinkScreen(){
        if let wnd = UIApplication.shared.keyWindow {
            let v = UIView(frame: wnd.bounds)
            v.backgroundColor = UIColor.white
            v.alpha = 1
            wnd.addSubview(v)
            UIView.animate(withDuration: 1, animations: {
                v.alpha = 0.0
            }, completion: {(finished) in
                print("inside blink LED")
                v.removeFromSuperview()
            })
        }
    }
    
    class func performNotificationTypeAction(type: String, jsonMessage: [String:Any]) {
        //self.currentNavController.showToast(message: "notification fetched")
    }
    
    
}
