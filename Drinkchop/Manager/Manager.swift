//
//  Manager.swift
//  Momentum
//
//  Created by Mac on 19/07/2017.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import JHSpinner


class Manager {
    
    
    static var getData:AlamofireRequestFetch = AlamofireRequestFetch(baseUrl: DrinkChopBaseURL)
    
    static var textLabel:UILabel!
    
    static var spinner:JHSpinnerView!
    
    static var access_token:String!
    
    class func getaccess_token() {
        self.access_token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    class func saveaccess_token(token: String?) {
        self.access_token = token ?? ""
        UserDefaults.standard.set(token, forKey: "token")
    }
    
    class func showLoader(text: String, view: UIView) {
        spinner = JHSpinnerView.showOnView(view, spinnerColor: appTintColor, overlay:.custom(CGSize(width: 150, height: 150), 20), overlayColor:UIColor.black.withAlphaComponent(0.6), fullCycleTime:4.0, text: text)
    }
    
    class func hideLoader() {
        spinner.dismiss()
    }
    
    
}
