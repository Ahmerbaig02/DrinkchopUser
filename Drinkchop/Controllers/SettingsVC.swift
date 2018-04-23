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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
    
    
    fileprivate func setupBtn(btn: UIButton) {
        btn.getRounded(cornerRaius: 5)
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = appTintColor.cgColor
    }

    @IBAction func enableCardAction(_ sender: Any) {
        let btn = sender as! UIButton
        if btn.currentImage == nil {
            btn.setImage(#imageLiteral(resourceName: "ic_done_18pt"), for: .normal)
        } else {
            btn.setImage(nil, for: .normal)
        }
    }
    
    deinit {
        print("settings vc deinit")
    }
}
