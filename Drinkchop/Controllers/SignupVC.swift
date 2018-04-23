////
//  SignupVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func signinAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("signup vc deinit")
    }
}
