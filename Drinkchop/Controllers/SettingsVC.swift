////
//  SettingsVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet var wakeScreenBtn:UIButton!
    @IBOutlet var notificationsBtn:UIButton!
    @IBOutlet var flashScreenBtn:UIButton!
    @IBOutlet var blinkLEDBtn:UIButton!
    @IBOutlet var vibrateBtn:UIButton!
    @IBOutlet var SoundBtn:UIButton!
    
    var settings:[String] = [String](repeating: "0", count: 6)
    var settingData = Settings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSettingsFromManager()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupBtn(btn: blinkLEDBtn)
        setupBtn(btn: SoundBtn)
        setupBtn(btn: vibrateBtn)
        setupBtn(btn: flashScreenBtn)
        setupBtn(btn: wakeScreenBtn)
        setupBtn(btn: notificationsBtn)
    }
    
    func saveSettings() {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        guard let data = try? encoder.encode(self.settingData) else {return}
        UserDefaults.standard.set(data, forKey: settingsDefaultsID)
    }
    
    func getSettingsFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.getSettingsFromServer(id: (DrinkUser.iUser.userId as NSString?)!.integerValue) { [weak self] (settingsData) in
            Manager.hideLoader()
            if let settings = settingsData {
                let setting = settings[0]
                self!.settingData = setting
                self?.setDataInBtn(btn: self!.wakeScreenBtn, value: setting.settingsWakeScreen ?? "0")
                self?.setDataInBtn(btn: self!.blinkLEDBtn, value: setting.settingsLed ?? "0")
                self?.setDataInBtn(btn: self!.vibrateBtn, value: setting.settingsVibrate ?? "0")
                self?.setDataInBtn(btn: self!.SoundBtn, value: setting.settingsSound ?? "0")
                self?.setDataInBtn(btn: self!.flashScreenBtn, value: setting.settingsFlashScreen ?? "0")
                self?.setDataInBtn(btn: self!.notificationsBtn, value: setting.settingsNotification ?? "0")
                self!.saveSettings()
            } else {
                self!.showToast(message: "Error fetching settings...")
                //error
            }
        }
    }
    
    func setDataInBtn(btn: UIButton, value: String) {
        settings[btn.tag] = value
        if value == "1" {
            btn.setImage(#imageLiteral(resourceName: "ic_done_18pt"), for: .normal)
        } else {
            btn.setImage(nil, for: .normal)
        }
    }
    
    func saveSettingsFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.saveSettingsOnServer(id: (DrinkUser.iUser.userId as NSString?)!.integerValue, settings: settings) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                self!.saveSettings()
                _ = self!.navigationController?.popViewController(animated: true)
            } else {
                self!.showToast(message: "error updating settings...")
                //err
            }
        }
    }
    
    fileprivate func setupBtn(btn: UIButton) {
        btn.getRounded(cornerRaius: 5)
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = appTintColor.cgColor
    }
    
    func setSettings(btn: UIButton, status: String) {
        if btn == notificationsBtn {
            settingData.settingsNotification = status
        } else if btn == flashScreenBtn {
            settingData.settingsFlashScreen = status
        } else if btn == SoundBtn {
            settingData.settingsSound = status
        } else if btn == vibrateBtn {
            settingData.settingsVibrate = status
        } else if btn == wakeScreenBtn {
            settingData.settingsWakeScreen = status
        } else {
            settingData.settingsLed = status
        }
    }
    
    @IBAction func enableCardAction(_ sender: Any) {
        let btn = sender as! UIButton
        
        if btn.currentImage == nil {
            btn.setImage(#imageLiteral(resourceName: "ic_done_18pt"), for: .normal)
            settings[btn.tag] = "1"
            setSettings(btn: btn, status: "1")
        } else {
            btn.setImage(nil, for: .normal)
            settings[btn.tag] = "0"
            setSettings(btn: btn, status: "0")
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        saveSettingsFromManager()
    }
    
    deinit {
        print("settings vc deinit")
    }
}
