////
//  SplashVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

import swiftScan

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkIsUserLoggedIn()
    }
    
    func checkIsUserLoggedIn() {
        let loggedIn = UserDefaults.standard.bool(forKey: isLoggedInDefaultID)
        if loggedIn {
            if let data = UserDefaults.standard.data(forKey: UserProfileDefaultsID) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let userData = try? decoder.decode(DrinkUser.self, from: data) else {
                    self.performSegue(withIdentifier: loginSegueID, sender: nil)
                    return
                }
                DrinkUser.iUser = userData
                DrinkUser.iUser.userName = DrinkUser.iUser.userName?.removingPercentEncoding
                self.performSegue(withIdentifier: LoggedInSegueID, sender: nil)
            } else {
                self.performSegue(withIdentifier: loginSegueID, sender: nil)
            }
        } else {
            self.performSegue(withIdentifier: loginSegueID, sender: nil)
        }
    }
    
    deinit {
        print("splash vc deinit")
    }

}
