////
//  SigninVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class SigninVC: UIViewController {

    @IBOutlet var emailTF: TextFieldValidator!
    @IBOutlet var passwordTF: TextFieldValidator!
    @IBOutlet var facebookBtn: UIButton!
    @IBOutlet var googleBtn: UIButton!
    @IBOutlet var signinBtn: UIButton!
    @IBOutlet var logoImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.passwordTF.isSecureTextEntry = true
        
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().uiDelegate = self

        
        self.emailTF.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                        attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        self.passwordTF.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])

        signinBtn.isEnabled = self.emailTF.validate() && self.passwordTF.validate()
        
        self.addValidatesTextFields()
        setPaddingInset(emailTF, image: #imageLiteral(resourceName: "ic_email"))
        setPaddingInset(passwordTF, image: #imageLiteral(resourceName: "ic_lock"))
        self.emailTF.addTarget(self, action: #selector(self.validateFields(_:)), for: .editingChanged)
        self.passwordTF.addTarget(self, action: #selector(self.validateFields(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.logoImgView.getRounded(cornerRaius: self.logoImgView.frame.height/2)
        self.googleBtn.getRounded(cornerRaius: self.googleBtn.frame.height/2)
        self.facebookBtn.getRounded(cornerRaius: self.facebookBtn.frame.height/2)
        self.signinBtn.getRounded(cornerRaius: self.signinBtn.frame.height/2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.passwordTF.underline(UIColor.white)
        self.emailTF.underline(UIColor.white)
    }
    
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
                print(userInfo["statusText"]!)
                guard let user = notification.object as? GIDGoogleUser else {return}
                self.checkUserFromManager(email: user.profile.email, name: user.profile.name)
//                self.performSegue(withIdentifier: LoggedInSegueID, sender: nil)
            }
        }
    }
    
    @objc func validateFields(_ sender: UITextField) {
        self.signinBtn.isEnabled = self.emailTF.validate() && self.passwordTF.validate()
    }
    
    func addValidatesTextFields() {
        emailTF.addRegx("[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}", withMsg:"Enter valid email.")
        passwordTF.addRegx("^.{4,20}$",withMsg:"Password should be 4-20 characters long")
        passwordTF.addRegx("[A-Za-z0-9]{4,20}",withMsg:"Only alpha numeric characters are allowed.")
    }
    
    func setPaddingInset(_ sender : UITextField, image: UIImage) {
        let imgView = UIImageView(image: image)
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.tintColor = UIColor.white
        imgView.frame = CGRect(x: 0, y: 0, width: sender.frame.height, height: sender.frame.height)
        sender.leftView = imgView
        sender.leftViewMode = UITextFieldViewMode.always
    }
    
    func saveUserDataAndLogin() {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(DrinkUser.iUser) else {return}
        
        UserDefaults.standard.set(data, forKey: UserProfileDefaultsID)
        UserDefaults.standard.set(true, forKey: isLoggedInDefaultID)
        self.performSegue(withIdentifier: LoggedInSegueID, sender: nil)
    }
    
    func signinUserFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.signinUserOnServer(email: self.emailTF.text!, password: self.passwordTF.text!) { [weak self] (usersData) in
            Manager.hideLoader()
            if let usersData = usersData {
                self!.emailTF.text! = ""
                self!.passwordTF.text! = ""
                DrinkUser.iUser = usersData[0]
                self!.saveUserDataAndLogin()
            } else {
                GIDSignIn.sharedInstance().signOut()
                FBSDKLoginManager().logOut()
                self!.showToast(message: "Username/Password is incorrect. Please try again...")
                //err
            }
        }
    }
    
    func checkUserFromManager(email: String, name: String) {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.checkUserOnServer(emailId: email, name: name) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                if success {
                    self!.emailTF.text = email
                    self!.passwordTF.text = "123123"
                    self!.signinUserFromManager()
                } else {
                    self!.createAccountFromManager(name: name, phone: "", email: email, password: "123123")
                }
            } else {
                print("Google Signin Error")
            }
        }
    }
    
    func createAccountFromManager(name: String, phone: String, email: String, password: String) {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        let token = UserDefaults.standard.string(forKey: fcmTokenDefaultsID) ?? ""
        Manager.createUserOnServer(name: name, phone: phone, email: email, password: password, Type: "0", token: token) { [weak self] (usersData) in
            Manager.hideLoader()
            if let usersData = usersData {
                DrinkUser.iUser = usersData[0]
                self!.saveUserDataAndLogin()
            } else {
                //err
            }
        }
    }
    
    @IBAction func signinAction(_ sender: Any) {
        self.signinUserFromManager()
    }
    
    @IBAction func googleSigninAction(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func facebookSigninAction(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
      //  loginManager.logOut()
        loginManager.logIn(withReadPermissions: ["public_profile","email"], from: self) { [weak self] (result, error) in
            if let error = error {
                loginManager.logOut()
                self!.showToast(message: error.localizedDescription)
            } else {
                if let res = result {
                    if res.isCancelled {
                        loginManager.logOut()
                        self!.showToast(message: "FB login cancelled.")
                    } else {
                        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, name, first_name, last_name, email,picture.type(large)"], tokenString: res.token.tokenString, version: nil, httpMethod: "GET")
                        Manager.showLoader(text: "Please Wait...", view: self!.view)
                        req?.start(completionHandler: { (connection, result, error) in
                            Manager.hideLoader()
                            if let profileResult = result as? [String:Any] {
                                print("Permissions: ",res.grantedPermissions)
                                print("Email: ", profileResult["email"] as? String ?? "")
                                print("FName: ", profileResult["first_name"] as? String ?? "")
                                print("LName: ", profileResult["last_name"] as? String ?? "")
                                let email = profileResult["email"] as? String ?? ""
                                let name = profileResult["name"] as? String ?? ""
                                self!.checkUserFromManager(email: email, name: name)
                            } else {
                                self!.showToast(message: error!.localizedDescription)
                            }
                        })
                    }
                } else {
                    loginManager.logOut()
                    self!.showToast(message: "FB login error.")
                }
            }
            
        }
    }
    
    deinit {
        print("sign in vc deinit")
    }
}

extension SigninVC: GIDSignInUIDelegate {
    
    
    // Implement these methods only if the GIDSignInUIDelegate is not a subclass of
    // UIViewController.
    
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    internal func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: LoggedInSegueID, sender: nil)
        })
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
