////
//  AddCardVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class AddCardVC: UIViewController {

    @IBOutlet var cardNumberTF: UITextField!
    @IBOutlet var cardNameTF: UITextField!
    @IBOutlet var monthTF: UITextField!
    @IBOutlet var yearTF: UITextField!
    @IBOutlet var CvcTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func addCardFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        let subURL = "user_name=\(DrinkUser.iUser.userName ?? "")&user_id=\(DrinkUser.iUser.userId ?? "")&cvc=\(CvcTF.text!)&exp_month=\(monthTF.text!)&exp_year=\(yearTF.text!)&card_name=\(cardNameTF.text!)&card_number=\(cardNumberTF.text!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        Manager.addCardOnServer(subURL: subURL) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                _ = self!.navigationController?.popViewController(animated: true)
            } else {
                self!.showToast(message: "Error adding card. Please try again...")
                //err
            }
        }
    }
    
    @IBAction func submitAction(_ sender: Any) {
        addCardFromManager()
    }
    
    deinit {
        print("AddCardVC deinit")
    }
}
