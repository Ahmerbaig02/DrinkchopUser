////
//  SelectedBarVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class SelectedBarVC: UIViewController {

    
    @IBOutlet var confirmCheckoutView: UIView!
    @IBOutlet var confirmNumberTF: UITextField!
    @IBOutlet var cnfrmCheckoutBtn: UIButton!
    
    @IBOutlet var coverCheckoutView: UIView!
    @IBOutlet var minusBtn: UIButton!
    @IBOutlet var plusBtn: UIButton!
    @IBOutlet var quantityLbl: UILabel!
    @IBOutlet var totalpriceLbl: UILabel!
    @IBOutlet var checkoutBtn: UIButton!
    
    @IBOutlet var drinkImgView: UIImageView!
    @IBOutlet var titleLbl:UILabel!
    @IBOutlet var timeLbl:UILabel!
    @IBOutlet var distanceLbl:UILabel!
    @IBOutlet var aboutTV:UITextView!
    @IBOutlet var eventsBtn:UIButton!
    @IBOutlet var happyHrsBtn:UIButton!
    @IBOutlet var locationBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCheckoutView(v: confirmCheckoutView)
        setupCheckoutView(v: coverCheckoutView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.drinkImgView.getRounded(cornerRaius: 10)
        
        confirmCheckoutView.getRounded(cornerRaius: 0)
        confirmCheckoutView.giveShadow(cornerRaius: 0)
        
        confirmCheckoutView.layer.shadowOffset = CGSize(width: 5.0, height: 15.0)
        confirmCheckoutView.layer.shadowRadius = 10.0
        confirmCheckoutView.layer.shadowOpacity = 0.5
        
        coverCheckoutView.getRounded(cornerRaius: 0)
        coverCheckoutView.giveShadow(cornerRaius: 0)
        
        coverCheckoutView.layer.shadowOffset = CGSize(width: 5.0, height: 15.0)
        coverCheckoutView.layer.shadowRadius = 10.0
        coverCheckoutView.layer.shadowOpacity = 0.5
    }
    
    func showHideCoverCheckoutView(show: Bool) {
        UIView.animate(withDuration: 0.5) {
            if show == true {
                self.coverCheckoutView.alpha = 1
            } else {
                self.coverCheckoutView.alpha = 0
            }
            
        }
    }

    func showHideConfirmCheckoutView(show: Bool) {
        UIView.animate(withDuration: 0.5) {
            if show == true {
                self.confirmCheckoutView.alpha = 1
            } else {
                self.confirmCheckoutView.alpha = 0
            }
            
        }
    }
    
    func setupCheckoutView(v: UIView) {
        self.view.addSubview(v)
        v.center = view.center
        v.center.y = view.center.y - 30
        v.alpha = 0
    }
    
    @IBAction func fbAction(_ sender: Any) {
        
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
    }
    
    @IBAction func googlePlusAction(_ sender: Any) {
        
    }
    
    @IBAction func twitterAction(_ sender: Any) {
        
    }
    
    @IBAction func favouriteAction(_ sender: Any) {
        
    }
    
    @IBAction func eventsAction(_ sender: Any) {
        
    }
    
    @IBAction func happyHoursAction(_ sender: Any) {
        
    }
    
    @IBAction func locationAction(_ sender: Any) {
        
    }
    
    @IBAction func coverAction(_ sender: Any) {
        showHideCoverCheckoutView(show: true)
        
    }
    
    @IBAction func drinksAction(_ sender: Any) {
        
    }
    //
    @IBAction func minusAction(_ sender: Any) {
        var count = (quantityLbl.text as NSString?)!.integerValue
        count = count - 1
        quantityLbl.text = String(count < 0 ? 0 : count)
        
    }
    
    @IBAction func plusAction(_ sender: Any) {
        var count = (quantityLbl.text as NSString?)!.integerValue
        count = count + 1
        quantityLbl.text = String(count < 0 ? 0 : count)
    }
    
    @IBAction func checkoutAction(_ sender: Any) {
        showHideCoverCheckoutView(show: false)
        showHideConfirmCheckoutView(show: true)
    }
    
    //
    @IBAction func confirmCheckoutAction(_ sender: Any) {
        showHideConfirmCheckoutView(show: false)
    }
    
    
    deinit {
        print("selected search bar vc")
    }

}
