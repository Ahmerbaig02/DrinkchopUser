////
//  HelpVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class HelpVC: UIViewController {

    @IBOutlet var problemTV: UITextView!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var emailTF: TextFieldValidator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTF.textColor = appTintColor
        emailTF.addRegx("[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}", withMsg:"Enter valid email.")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.submitBtn.getRounded(cornerRaius: self.submitBtn.frame.height/2)
    }
    
    
    func saveHelpFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.saveHelpOnServer(email: self.emailTF.text!,problem: problemTV.text!) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                print("success: \(success)")
                self!.showToast(message: "Help submitted...")
                self!.problemTV.text = ""
            } else {
                self!.showToast(message: "Error submitting help. Please try again...")
                print("save help failed error")
            }
        }
    }  
    
    @IBAction func saveHelpAction(_ sender: Any) {
        self.saveHelpFromManager()
    }
    
    
    deinit {
        print("help vc deinit")
    }
}

extension HelpVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
