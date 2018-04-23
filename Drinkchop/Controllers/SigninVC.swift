////
//  SigninVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class SigninVC: UIViewController {

    @IBOutlet var emailTF: TextFieldValidator!
    @IBOutlet var passwordTF: TextFieldValidator!
    @IBOutlet var facebookBtn: UIButton!
    @IBOutlet var googleBtn: UIButton!
    @IBOutlet var signinBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.emailTF.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                        attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        self.passwordTF.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])

        self.addValidatesTextFields()
        setPaddingInset(emailTF)
        setPaddingInset(passwordTF)
        self.emailTF.addTarget(self, action: #selector(self.validateFields(_:)), for: .valueChanged)
        self.passwordTF.addTarget(self, action: #selector(self.validateFields(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.googleBtn.getRounded(cornerRaius: self.googleBtn.frame.height/2)
        self.facebookBtn.getRounded(cornerRaius: self.facebookBtn.frame.height/2)
        self.signinBtn.getRounded(cornerRaius: self.signinBtn.frame.height/2)
        
        
        self.passwordTF.underline(UIColor.white)
        self.emailTF.underline(UIColor.white)
    }
    
    
    @objc func validateFields(_ sender: UITextField) {
        self.signinBtn.isEnabled = self.emailTF.validate() && self.passwordTF.validate()
    }
    
    func addValidatesTextFields() {
        emailTF.addRegx("[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}", withMsg:"Enter valid email.")
        passwordTF.addRegx("^.{4,20}$",withMsg:"Password should be 4-20 characters long")
        passwordTF.addRegx("[A-Za-z0-9]{4,20}",withMsg:"Only alpha numeric characters are allowed.")
    }
    
    func setPaddingInset(_ sender : UITextField) {
        sender.leftView =  UIView(frame: CGRect(x: 0, y: 0, width: 5, height: sender.frame.height))
        sender.leftViewMode = UITextFieldViewMode.always
    }
    
    @IBAction func signinAction(_ sender: Any) {
        self.performSegue(withIdentifier: LoggedInSegueID, sender: nil)
    }
    
    deinit {
        print("sign in vc deinit")
    }
}

extension SigninVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
