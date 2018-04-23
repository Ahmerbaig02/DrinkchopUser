////
//  HyveVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class HyveVC: UIViewController {

    @IBOutlet var readyDrinkView: UIView!
    @IBOutlet var readyDrinkImgView: UIImageView!
    @IBOutlet var readyDrinkBtn: UIButton!
    @IBOutlet var readyDrinkInfoLbl: UILabel!
    
    @IBOutlet var drinkWillReadyView: UIView!
    @IBOutlet var drinkWillReadyImgView: UIImageView!
    @IBOutlet var willReadyInfoLbl: UILabel!
    
    @IBOutlet var descriptionTV: UITextView!
    @IBOutlet var ingredientsLbl: UILabel!
    @IBOutlet var quantityLbl: UILabel!
    @IBOutlet var hyveImgView: UIImageView!
    @IBOutlet var priceCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setupDrinkView(v: drinkWillReadyView)
        setupDrinkView(v: readyDrinkView)
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
    
    @IBAction func buyAction(_ sender: Any) {
        if arc4random()%2 == 0 {
            showHideReadyDrinkView(show: true)
        } else {
            showHideWillReadyDrinkView(show: true)
        }
    }
    
    @IBAction func minusAction(_ sender: Any) {
        var count = (quantityLbl.text as NSString?)!.integerValue
        count = count - 1
        quantityLbl.text = String(count < 0 ? 0 : count)
    }
    
    @IBAction func plusAction(_ sender: Any) {
        var count = (quantityLbl.text as NSString?)!.integerValue
        count = count + 1
        quantityLbl.text = String(count)
    }
    
    
    @IBAction func fbAction(_ sender: Any) {
        
    }
    
    @IBAction func twitterAction(_ sender: Any) {
        
    }
    
    @IBAction func googleAction(_ sender: Any) {
        
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
    }
    
    @IBAction func favAction(_ sender: Any) {
        
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HyveDrinkCellID, for: indexPath) as! HyveDrinkCVC
        cell.priceLbl.text = "+$\(arc4random() % 100)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellHeaderSize(Width: self.view.frame.width/4, aspectRatio: 75/75, padding: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
