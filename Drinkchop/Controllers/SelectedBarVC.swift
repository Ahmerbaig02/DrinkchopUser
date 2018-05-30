////
//  SelectedBarVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit
import Stripe
import GoogleMaps
import GoogleMapsDirections

class SelectedBarVC: UIViewController {

    
    @IBOutlet var confirmNameLbl: UILabel!
    @IBOutlet var confirmCheckoutView: UIView!
    @IBOutlet var confirmNumberLbl: UILabel!
    @IBOutlet var cnfrmCheckoutBtn: UIButton!
    
    @IBOutlet var coverNameLbl: UILabel!
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
    
    @IBOutlet var saveBtn:UIButton!
    
    var selectedBarData:DrinkBar!
    
    fileprivate var API_KEY = "pk_test_S5TSQN4vRxoNw2vziRwJN7If"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCheckoutView(v: confirmCheckoutView)
        setupCheckoutView(v: coverCheckoutView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setDataInViews()
        checkFavFromManager()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? LocationVC {
            controller.barLat = (self.selectedBarData.lat as NSString?)!.doubleValue
            controller.barLng = (self.selectedBarData.lng as NSString?)!.doubleValue
        }
        if let controller = segue.destination as? EventsVC {
            controller.view.tag = sender as! Int
            controller.selectedBarData = self.selectedBarData
        }
        
        if let controller = segue.destination as? DrinksVC {
            controller.selectedBarData = self.selectedBarData
        }
        
        if let controller = segue.destination as? TableVC {
            controller.selectedBarData = self.selectedBarData
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.drinkImgView.getRounded(cornerRaius: 10)
        
        confirmCheckoutView.getRounded(cornerRaius: 0)
        confirmCheckoutView.giveShadow(cornerRaius: 0)
        
        confirmCheckoutView.layer.shadowOffset = CGSize(width: 5.0, height: 15.0)
        confirmCheckoutView.layer.shadowRadius = 10.0
        confirmCheckoutView.layer.shadowOpacity = 0.5
        
        confirmNumberLbl.getRounded(cornerRaius: 5)
        confirmNumberLbl.giveShadow(cornerRaius: 5)
        
        coverCheckoutView.getRounded(cornerRaius: 0)
        coverCheckoutView.giveShadow(cornerRaius: 0)
        
        coverCheckoutView.layer.shadowOffset = CGSize(width: 5.0, height: 15.0)
        coverCheckoutView.layer.shadowRadius = 10.0
        coverCheckoutView.layer.shadowOpacity = 0.5
    }
    
    func setDataInViews() {
        titleLbl.text = selectedBarData.name
        drinkImgView.pin_setImage(from: URL(string: selectedBarData.picture ?? ""))
        distanceLbl.text = "\(selectedBarData.barDistance ?? 0) miles away"
        timeLbl.text = "opens \(makeShortReadableTime(str: selectedBarData.openingTime ?? "")) - \(makeShortReadableTime(str: selectedBarData.closingTime ?? ""))"
        self.eventsBtn.setTitle("Events(\(self.selectedBarData.events ?? 0))", for: .normal)
        self.happyHrsBtn.setTitle("Happy Hours(\(self.selectedBarData.hours ?? 0))", for: .normal)
        self.aboutTV.text = self.selectedBarData.about ?? ""
        
        self.totalpriceLbl.text = "Total: $\(self.selectedBarData.entryRate ?? "0")"
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
    
    func createTokenStripeCard() {
        STPAPIClient.shared().publishableKey = API_KEY
        STPTheme.default().accentColor = .white
        STPTheme.default().primaryBackgroundColor = .darkGray
        let controller = STPAddCardViewController()
        controller.delegate = self
        let navController = UINavigationController(rootViewController: controller)
        navController.navigationBar.barTintColor = appTintColor
        navController.navigationBar.tintColor = .white
        navController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.present(navController, animated: true, completion: nil)
    }
    
    func checkForRoomFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.checkRoomsOnServer(barId: self.selectedBarData.barId!) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                print("success: \(success)\t\nAmount: \((self!.totalpriceLbl.text?.replacingOccurrences(of: "Total: $", with: "") as NSString?)!.integerValue)\t\nCurrency: USD\t\nCheck: No")
                self!.showHideCoverCheckoutView(show: false)
               //self!.showHideConfirmCheckoutView(show: true)
                self!.createTokenStripeCard()
            } else {
                self!.showHideCoverCheckoutView(show: false)
                self!.showToast(message: "Alert: Not Enough Room, Bar is Full!")
                print("Alert: Not Enough Room, Bar is Full!")
            }
        }
    }
    
    
    func checkFavFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.checkFavoritesOnServer(item: self.selectedBarData.barId!, barId: self.selectedBarData.barId!, type: "bar") { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                print(success)
                self!.saveBtn.tintColor = appTintColor
            } else {
                self!.saveBtn.tintColor = .darkGray
            }
            self!.saveBtn.setImage(#imageLiteral(resourceName: "ic_favorite"), for: .normal)
        }
    }
    
    func setFavFromManager(check: Int) {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.saveFavoritesOnServer(itemId: self.selectedBarData.barId!, check: check, barId: self.selectedBarData.barId!, type: "bar") { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                if check == 1 {
                    print(success)
                    self!.showToast(message: "Added to favourites...")
                    self!.saveBtn.tintColor = appTintColor
                } else {
                    self!.showToast(message: "Removed from favourites...")
                    self!.saveBtn.tintColor = .darkGray
                }
                self!.saveBtn.setImage(#imageLiteral(resourceName: "ic_favorite"), for: .normal)
            } else {
                self!.showToast(message: "Error saving favourites. Please try again...")
                print("error save favourite")
            }
        }
    }
    
    func saveConfirmationToken() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        let confirmationCode = UUID().uuidString
        Manager.saveConfirmationTokenOnServer(confirmation_token: confirmationCode, ppl_count: self.quantityLbl.text!, amount: self.totalpriceLbl.text!.replacingOccurrences(of: "Total: $", with: ""), barId: self.selectedBarData.barId!) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                print("token saved", success)
                self!.showToast(message: "token saved")
                self!.confirmNumberLbl.text = confirmationCode
                self!.showHideConfirmCheckoutView(show: true)
            } else {
                self!.showToast(message: "token saving failed...")
                print("token saved failed...")
            }
        }
    }
    
    func saveVisaPaymentOnManager(token: String) {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.saveVisaPaymentOnServer(secretKey: self.selectedBarData.secretKey!, instructions: "Do this drink", description: "iOS Cover", currency: "USD", token: token, ppl_count: self.quantityLbl.text!, amount: self.totalpriceLbl.text!.replacingOccurrences(of: "Total: $", with: ""), barId: self.selectedBarData.barId!) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                self!.showToast(message: "transaction order success...")
                print("transaction order success...")
            } else {
                self!.showToast(message: "transaction order failed...")
                print("transaction order failed...")
            }
        }
    }
    
    @IBAction func fbAction(_ sender: Any) {
        guard let fbURL = URL(string: "http://\(self.selectedBarData.facebook ?? "")") else {return}
        if UIApplication.shared.canOpenURL(fbURL) {
            UIApplication.shared.open(fbURL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func googlePlusAction(_ sender: Any) {
        guard let googleURL = URL(string: "http://www.facebook.com/\(self.selectedBarData.instagram ?? "")") else {return}
        if UIApplication.shared.canOpenURL(googleURL) {
            UIApplication.shared.open(googleURL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func twitterAction(_ sender: Any) {
        guard let twitterURL = URL(string: self.selectedBarData.twitter ?? "") else {return}
        if UIApplication.shared.canOpenURL(twitterURL) {
            UIApplication.shared.open(twitterURL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func favouriteAction(_ sender: Any) {
        setFavFromManager(check: (saveBtn.tintColor == appTintColor) ? 0 : 1)
    }
    
    @IBAction func eventsAction(_ sender: Any) {
        self.performSegue(withIdentifier: showEventSegueID, sender: 0)
    }
    
    @IBAction func happyHoursAction(_ sender: Any) {
        self.performSegue(withIdentifier: showEventSegueID, sender: 1)
    }
    
    @IBAction func locationAction(_ sender: Any) {
        self.performSegue(withIdentifier: LocationSegueID, sender: nil)
    }
    
    @IBAction func coverAction(_ sender: Any) {
        showHideCoverCheckoutView(show: true)
        
    }
    
    @IBAction func closeCoverAction(_ sender: Any) {
        self.showHideCoverCheckoutView(show: false)
    }
    
    @IBAction func closeConfirmAction(_ sender: Any) {
        self.showHideConfirmCheckoutView(show: false)
    }
    
    @IBAction func drinksAction(_ sender: Any) {
        self.performSegue(withIdentifier: DrinksSegueID, sender: nil)
    }
    //
    @IBAction func minusAction(_ sender: Any) {
        let rate = (self.selectedBarData.entryRate as NSString?)!.integerValue
        var count = (quantityLbl.text as NSString?)!.integerValue
        count = count - 1
        let quantity = count < 0 ? 0 : count
        quantityLbl.text = String(quantity)
        self.totalpriceLbl.text = "Total: $\(rate * quantity)"
    }
    
    @IBAction func plusAction(_ sender: Any) {
        let peopleInRoom = (self.selectedBarData.peopleInRoom as NSString?)!.integerValue
        let roomOccupancy = (self.selectedBarData.totalRoomOccupancy as NSString?)!.integerValue
        let accomodatedSpace = roomOccupancy - peopleInRoom
        let rate = (self.selectedBarData.entryRate as NSString?)!.integerValue
        var count = (quantityLbl.text as NSString?)!.integerValue
        count = count + 1
        let quantity = count > accomodatedSpace ? accomodatedSpace : count
        quantityLbl.text = String(quantity)
        self.totalpriceLbl.text = "Total: $\(rate * quantity)"
    }
    
    @IBAction func checkoutAction(_ sender: Any) {
        self.checkForRoomFromManager()
    }
    
    //
    @IBAction func confirmCheckoutAction(_ sender: Any) {
        showHideConfirmCheckoutView(show: false)
    }
    
    
    deinit {
        print("selected search bar vc")
    }
}


extension SelectedBarVC: STPAddCardViewControllerDelegate {
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        print("stripe card token create cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        completion(nil)
        print("Stripe Token: ",token.tokenId)
        dismiss(animated: true) {
            self.saveVisaPaymentOnManager(token: token.tokenId)
        }
    }
}
