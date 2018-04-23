////
//  AllergyVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class AllergyVC: UIViewController {

    @IBOutlet var allergyTF: UITextField!
    @IBOutlet var saveBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        allergyTF.underline(appTintColor)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        saveBtn.getRounded(cornerRaius: saveBtn.frame.height/2)
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }

    deinit {
        print("deinit allergyVC")
    }

}
