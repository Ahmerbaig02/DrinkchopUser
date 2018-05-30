////
//  CartVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit
import Stripe


class CartVC: UIViewController {

    @IBOutlet var drinksTableView: UITableView!
    @IBOutlet var costLbl: UILabel!
    @IBOutlet var pickDrinkBtn: UIButton!
    @IBOutlet var tipsTF: UITextField!
    @IBOutlet var cardBtn: UIButton!
    @IBOutlet var cashBtn: UIButton!
    @IBOutlet var instructionsTF: UITextField!
    
    var drinksData: [Drink]!
    
    fileprivate var API_KEY = "pk_test_S5TSQN4vRxoNw2vziRwJN7If"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tipsTF.keyboardType = .decimalPad
        self.tipsTF.delegate = self
        
        registerCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DrinksVC {
            controller.selectedBarData = DrinkBar()
            controller.selectedBarData.barId = self.drinksData[0].barId
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.cardBtn.getRounded(cornerRaius: 10)
        self.cardBtn.giveShadow(cornerRaius: 10)
        self.cashBtn.getRounded(cornerRaius: 10)
        self.cashBtn.giveShadow(cornerRaius: 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationsUtil.setSuperView(navController: self.navigationController!)
        setDataInViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationsUtil.removeFromSuperView()
    }
    
    func makeOrderString(data: [[String:Any]]) -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) else {return ""}
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    func setDataInViews() {
        var cost = 0.0
        for amount in self.drinksData {
            cost+=((amount.quantity as NSString?)!.doubleValue * (amount.drinkCost as NSString?)!.doubleValue)
        }
        let tips = (self.tipsTF.text?.replacingOccurrences(of: "$", with: "") as NSString?)!.doubleValue
        cost+=tips
        let taxAmount = cost*0.16
        self.costLbl.attributedText = getAttributedText(Titles: ["Drinks Total: \(cost.getRounded(uptoPlaces: 2))$ + Tax: \(taxAmount.getRounded(uptoPlaces: 2))$ = ","\((cost+taxAmount).getRounded(uptoPlaces: 2))$"], Font: [UIFont.systemFont(ofSize: 14.0), UIFont.boldSystemFont(ofSize: 14.0)], Colors: [UIColor.black, UIColor.orange], seperator: ["",""], Spacing: 0, atIndex: -1)
    }
    
    func registerCell() {
        let cellNib = UINib(nibName: "OrdersTVC", bundle: nil)
        self.drinksTableView.register(cellNib, forCellReuseIdentifier: OrderCellID)
    }
    
    func getOrderStringData() -> String {
//        guard let drinksData = UserDefaults.standard.data(forKey: CartDefaultsID) else {
//            return ""
//        }
//        return String(data: drinksData, encoding: .utf8) ?? ""
//
        var dictArr: [[String:Any]] = []
        for item in self.drinksData {
            var newDict: [String:Any] = [:]
            newDict["drink_id"] = item.drinkId!
            newDict["drink_count"] = item.quantity ?? 0
            dictArr.append(newDict)
        }
        return convertJSONToString(json: dictArr) ?? ""
    }
    
    func deleteEntryFromCart() {
        var data = UserDefaults.standard.data(forKey: CartDefaultsID)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let drinks = try? decoder.decode([Drink].self, from: data) else {
            self.showToast(message: "Cart Entry Delete Error...!")
            return
        }
        var dbDrinksData = drinks
        for item in self.drinksData {
            dbDrinksData.remove(at: drinks.index(where: {$0.drinkId == item.drinkId})!)
        }
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let encodedData = try? encoder.encode(dbDrinksData) else {
            self.showToast(message: "Cart Entry Delete Error...!")
            return
        }
        UserDefaults.standard.set(encodedData, forKey: CartDefaultsID)
        UserDefaults.standard.synchronize()
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func saveOrderPaymentOnManager(token: String) {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        let amount = self.costLbl.text!.components(separatedBy: "=")[1].replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "$", with: "")
        let orderObj = getOrderStringData()
        
        Manager.saveOrderPaymentOnServer(object: orderObj, secretKey: stripeSecretKey, instructions: self.instructionsTF.text!, description: "iOS App Order", currency: "USD", token: token, tax: "0", tips: self.tipsTF.text!.replacingOccurrences(of: "$", with: ""), amount: amount, barId: self.drinksData[0].barId!) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                self!.showToast(message: "Pay Cash At Bar...")
                self!.deleteEntryFromCart()
                print("transaction order success...")
            } else {
                self!.showToast(message: "transaction order failed...")
                print("transaction order failed...")
            }
        }
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

    @IBAction func pickDrinkAction(_ sender: Any) {
        self.performSegue(withIdentifier: DrinksSegueID, sender: nil)
    }
    
    @IBAction func cardAction(_ sender: Any) {
        createTokenStripeCard()
    }
    
    @IBAction func cashAction(_ sender: Any) {
        createTokenStripeCard()
    }
    
    deinit {
        print("Cart VC deinit")
    }
}

extension CartVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tipsTF {
            setDataInViews()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tipsTF {
            setDataInViews()
        }
        return true
    }
}

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinksData.count
    }
    
    func configureCell(cell: OrdersTVC, index: Int) {
        cell.backgroundColor = .clear
        let selectedItem = self.drinksData[index]
        cell.infoLbl.text = selectedItem.drinkName ?? ""
        cell.drinkLbl.text = "\(selectedItem.drinkAlcohal ?? "")% Alcohol"
        let quantity = (selectedItem.quantity as NSString?)!.integerValue
        let drinkCost = (selectedItem.drinkCost as NSString?)!.integerValue
        cell.priceLbl.text = "$\(drinkCost * quantity)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCellID, for: indexPath) as! OrdersTVC
        configureCell(cell: cell, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.drinksTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCellHeaderSize(Width: tableView.frame.width, aspectRatio: 320/25, padding: 0).height
        //return UITableViewAutomaticDimension
    }
}

extension CartVC: STPAddCardViewControllerDelegate {
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        print("stripe card token create cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        completion(nil)
        print("Stripe Token: ",token.tokenId)
        dismiss(animated: true) {
            self.cardBtn.setTitle("**** **** **** \(token.card?.last4 ?? "****")", for: .normal)
            self.saveOrderPaymentOnManager(token: token.tokenId)
        }
    }
}
