////
//  PasswordVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class PasswordVC: UIViewController {

    @IBOutlet var currentPswdTF: UITextField!
    @IBOutlet var newPswdTF: UITextField!
    @IBOutlet var confirmPswdTF: UITextField!
    @IBOutlet var pswdBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        currentPswdTF.underline(appTintColor)
        newPswdTF.underline(appTintColor)
        confirmPswdTF.underline(appTintColor)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        pswdBtn.getRounded(cornerRaius: pswdBtn.frame.height/2)
        
    }
    
    @IBAction func pswdBtnAction(_ sender: Any) {
    }
    
    deinit {
        print("deinit passwordVC")
    }
    

}
