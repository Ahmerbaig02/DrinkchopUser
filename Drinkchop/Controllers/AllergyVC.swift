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

        allergyTF.text = DrinkUser.iUser.userAllergies ?? ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        allergyTF.underline(appTintColor)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        saveBtn.getRounded(cornerRaius: saveBtn.frame.height/2)
    }
    
    func saveUserData() {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(DrinkUser.iUser) else {return}
        
        UserDefaults.standard.set(data, forKey: UserProfileDefaultsID)
    }
    
    func saveAllergyFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.saveAllergyOnServer(id: DrinkUser.iUser.userId ?? "", allergy: allergyTF.text!) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                DrinkUser.iUser.userAllergies = self!.allergyTF.text!
                self!.saveUserData()
                _ = self!.navigationController?.popViewController(animated: true)
                self!.showToast(message: "Allergies updated.")
            } else {
                self!.showToast(message: "Error updating allergies. Please try again...")
                //err
            }
        }
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        self.saveAllergyFromManager()
        
    }

    deinit {
        print("deinit allergyVC")
    }

}
