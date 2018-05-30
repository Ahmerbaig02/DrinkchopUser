////
//  HyveVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class HyveVC: UIViewController {

    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var readyDrinkView: UIView!
    @IBOutlet var readyDrinkImgView: UIImageView!
    @IBOutlet var readyDrinkBtn: UIButton!
    @IBOutlet var readyDrinkInfoLbl: UILabel!
    
    @IBOutlet var drinkWillReadyView: UIView!
    @IBOutlet var drinkWillReadyImgView: UIImageView!
    @IBOutlet var willReadyInfoLbl: UILabel!
    
    @IBOutlet var drinkNameLbl: UILabel!
    @IBOutlet var descriptionTV: UITextView!
    @IBOutlet var ingredientsLbl: UILabel!
    @IBOutlet var quantityLbl: UILabel!
    @IBOutlet var percentAlcoholLbl: UILabel!
    @IBOutlet var hyveImgView: UIImageView!
    @IBOutlet var priceCollectionView: UICollectionView!
    
    @IBOutlet var saveBtn: UIButton!
    
    var selectedDrinkData:Drink!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        
        setupDrinkView(v: drinkWillReadyView)
        setupDrinkView(v: readyDrinkView)
        
        setDataInViews()
        
        checkFavFromManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let quantity = (self.quantityLbl.text as NSString?)!.integerValue
        let cost = (self.selectedDrinkData.drinkCost as NSString?)!.integerValue
        priceLbl.text = "Price: $\(cost*quantity)"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        hyveImgView.getRounded(cornerRaius: 10)
        readyDrinkImgView.getRounded(cornerRaius: 10)
        drinkWillReadyImgView.getRounded(cornerRaius: 10)
        quantityLbl.getRounded(cornerRaius: 5)
        readyDrinkView.getRounded(cornerRaius: 0)
        readyDrinkView.giveShadow(cornerRaius: 0)
        
        readyDrinkView.layer.shadowOffset = CGSize(width: 5.0, height: 15.0)
        readyDrinkView.layer.shadowRadius = 10.0
        readyDrinkView.layer.shadowOpacity = 0.5
        
        drinkWillReadyView.getRounded(cornerRaius: 0)
        drinkWillReadyView.giveShadow(cornerRaius: 0)
        
        drinkWillReadyView.layer.shadowOffset = CGSize(width: 5.0, height: 15.0)
        drinkWillReadyView.layer.shadowRadius = 10.0
        drinkWillReadyView.layer.shadowOpacity = 0.5
    }
    
    func setDataInViews() {
        self.drinkNameLbl.text = self.selectedDrinkData.drinkName ?? ""
        self.hyveImgView.pin_setImage(from: URL(string: self.selectedDrinkData.drinkPicture ?? ""))
        self.descriptionTV.text = self.selectedDrinkData.drinkDescription ?? ""
        self.ingredientsLbl.text = self.selectedDrinkData.drinkIngredients ?? ""
        self.percentAlcoholLbl.text = "\(self.selectedDrinkData.drinkAlcohal ?? "0")% Alcohol"
        self.priceCollectionView.reloadData()
    }
    
    func registerCells() {
        let cellNib = UINib(nibName: "HyveDrinkCVC", bundle: nil)
        priceCollectionView.register(cellNib, forCellWithReuseIdentifier: HyveDrinkCellID)
    }
    
    func showHideReadyDrinkView(show: Bool) {
        UIView.animate(withDuration: 0.5) {
            if show == true {
                self.readyDrinkView.alpha = 1
            } else {
                self.readyDrinkView.alpha = 0
            }
            
        }
    }
    
    func showHideWillReadyDrinkView(show: Bool) {
        UIView.animate(withDuration: 0.5) {
            if show == true {
                self.drinkWillReadyView.alpha = 1
            } else {
                self.drinkWillReadyView.alpha = 0
            }
        }
    }
    
    func setupDrinkView(v: UIView) {
        self.view.addSubview(v)
        v.center = view.center
        v.center.y = view.center.y - 30
        v.alpha = 0
    }
    
    func checkFavFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.checkFavoritesOnServer(item: self.selectedDrinkData.drinkId! ,barId: self.selectedDrinkData.barId!, type: "drink") { [weak self] (success) in
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
        Manager.saveFavoritesOnServer(itemId: self.selectedDrinkData.drinkId!, check: check, barId: self.selectedDrinkData.barId!, type: "drink") { [weak self] (success) in
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
    
    func addNewDrinkToCart(drinksData: [Drink]) {
        var drinks = drinksData
        self.selectedDrinkData.userId = DrinkUser.iUser.userId
        self.selectedDrinkData.quantity = self.quantityLbl.text!
        drinks.append(self.selectedDrinkData)
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(drinks) else {
            self.showToast(message: "Alert: Not Checked In, Please Checkin to confirm!")
            return
        }
        UserDefaults.standard.set(data, forKey: CartDefaultsID)
        UserDefaults.standard.synchronize()
        self.showToast(message: "Drink Added To Cart...")
    }
    
    func saveOrderData() {
        guard let drinksData = UserDefaults.standard.data(forKey: CartDefaultsID) else {
            addNewDrinkToCart(drinksData: [])
            return
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let drinks = try? decoder.decode([Drink].self, from: drinksData) else {
            addNewDrinkToCart(drinksData: [])
            return
        }
        addNewDrinkToCart(drinksData: drinks)
    }
    
    func checkForCheckinFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.checkforCheckinOnServer(userId: "1", barId: self.selectedDrinkData.barId!) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                print("success: ", success)
                self!.saveOrderData()
            } else {
                self!.showToast(message: "Alert: Not Checked In, Please Checkin to confirm!")
                print("Alert: Not Enough Room, Bar is Full!")
            }
        }
    }
    
    @IBAction func buyAction(_ sender: Any) {
//        if arc4random()%2 == 0 {
//            showHideReadyDrinkView(show: true)
//        } else {
//            showHideWillReadyDrinkView(show: true)
//        }
        checkForCheckinFromManager()
    }
    
    @IBAction func minusAction(_ sender: Any) {
        var count = (quantityLbl.text as NSString?)!.integerValue
        count = count - 1
        quantityLbl.text = String(count < 0 ? 0 : count)
        let quantity = (count < 0) ? 0 : count
        let cost = (self.selectedDrinkData.drinkCost as NSString?)!.integerValue
        priceLbl.text = "Price: $\(cost*quantity)"
    }
    
    @IBAction func plusAction(_ sender: Any) {
        var count = (quantityLbl.text as NSString?)!.integerValue
        count = count + 1
        quantityLbl.text = String(count)
        let cost = (self.selectedDrinkData.drinkCost as NSString?)!.integerValue
        priceLbl.text = "Price: $\(cost*count)"
    }
    
    @IBAction func favAction(_ sender: Any) {
        setFavFromManager(check: (saveBtn.tintColor == appTintColor) ? 0 : 1)
    }
    
    //
    @IBAction func readyDrinkAction(_ sender: Any) {
        showHideReadyDrinkView(show: false)
    }
   
    @IBAction func closeAction(_ sender: Any) {
        showHideReadyDrinkView(show: false)
    }
    //
    @IBAction func drinkWillReadyAction(_ sender: Any) {
        showHideWillReadyDrinkView(show: false)
    }
    
    @IBAction func closeWillReadyAction(_ sender: Any) {
        showHideWillReadyDrinkView(show: false)
    }
    
    deinit {
        print("hyve deinit")
    }
}

extension HyveVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedDrinkData.extras?.count ?? 0
    }
    
    func configureCell(cell: HyveDrinkCVC, index: Int) {
        let selectedExtra = self.selectedDrinkData.extras![index]
        cell.nameLbl.text = selectedExtra.extraName ?? ""
        cell.priceLbl.text = "+$\(selectedExtra.extraCost ?? "0")"
        cell.selectedImgView.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HyveDrinkCellID, for: indexPath) as! HyveDrinkCVC
        configureCell(cell: cell, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellHeaderSize(Width: self.view.frame.width/4, aspectRatio: 75/100, padding: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
