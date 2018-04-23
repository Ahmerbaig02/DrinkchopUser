////
//  BudgetVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class BudgetVC: UIViewController {

    @IBOutlet var budgetLbl: UILabel!
    @IBOutlet var budgetTF: UITextField!
    @IBOutlet var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        budgetTF.underline(appTintColor)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        saveBtn.getRounded(cornerRaius: saveBtn.frame.height/2)
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        self.budgetLbl.text = "Current Budget($)\n\n\(budgetTF.text!)\n\nNew Budget($)"
        budgetTF.text = ""
    }
    
    
    deinit {
        print("deinit budgetVC")
    }


}
