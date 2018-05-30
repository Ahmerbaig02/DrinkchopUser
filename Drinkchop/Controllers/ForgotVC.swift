////
//  ForgotVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit
import DLRadioButton

class ForgotVC: UIViewController {

    
    @IBOutlet var submitBtn:UIButton!
    @IBOutlet var passwordForgotBtn: DLRadioButton!
    @IBOutlet var usernameForgotBtn: DLRadioButton!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var emailTF: TextFieldValidator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.emailTF.attributedPlaceholder = NSAttributedString(string: "Enter Email Address",
                                                                attributes: [NSAttributedStringKey.foregroundColor: appTintColor])
        self.usernameForgotBtn.isSelected = true
        self.setPaddingInset(self.emailTF)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.submitBtn.getRounded(cornerRaius: self.submitBtn.frame.height/2)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.emailTF.underline(appTintColor)
    }
    
    func setPaddingInset(_ sender : UITextField) {
        sender.leftView =  UIView(frame: CGRect(x: 0, y: 0, width: 5, height: sender.frame.height))
        sender.leftViewMode = UITextFieldViewMode.always
    }
    
    func forgotPasswordFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        let type = self.emailTF.isSelected ? "phone" : "password"
        Manager.forgotPasswordOnServer(email: emailTF.text!,type: type) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                print(success)
                self!.showToast(message: "Email sent")
                _ = self!.navigationController?.popViewController(animated: true)
            } else {
                self!.showToast(message: "Error sending email. Please try again...")
                print("error forgot password email sent..")
            }
        }
    }
    
    @IBAction func forgotUsernameAction(_ sender: Any) {
        self.passwordForgotBtn.isSelected = false
        self.titleLbl.text = "Your username will be sent to you via email"
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        self.usernameForgotBtn.isSelected = false
        self.titleLbl.text = "Your password will be sent to you via email"
    }
    
    @IBAction func submitAction(_ sender: Any) {
        self.forgotPasswordFromManager()
    }
    
    deinit {
        print("forgot vc deinit")
    }
}

extension ForgotVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
