////
//  SelectedCardVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class SelectedCardVC: UIViewController {

    @IBOutlet var cardDetailsView: UIView!
    @IBOutlet var enableBtn: UIButton!
    @IBOutlet var saveBtn:UIButton!
    @IBOutlet var removeBtn:UIButton!
    @IBOutlet var cardInfoLbl:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.enableBtn.getRounded(cornerRaius: 5)
        self.enableBtn.layer.borderWidth = 1.5
        self.enableBtn.layer.borderColor = appTintColor.cgColor
        
        self.cardDetailsView.getRounded(cornerRaius: 2)
        self.cardDetailsView.giveShadow(cornerRaius: 2)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func removeAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    deinit {
        print("selected card vc deinit")
    }
    
}
