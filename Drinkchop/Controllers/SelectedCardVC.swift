////
//  SelectedCardVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class SelectedCardVC: UIViewController {

    @IBOutlet var ownerLbl: UILabel!
    @IBOutlet var cardDetailsView: UIView!
    @IBOutlet var enableBtn: UIButton!
    @IBOutlet var saveBtn:UIButton!
    @IBOutlet var removeBtn:UIButton!
    @IBOutlet var cardInfoLbl:UILabel!
    
    var selectedCardData: DrinkCard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataInViews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.enableBtn.getRounded(cornerRaius: 5)
        self.enableBtn.layer.borderWidth = 1.5
        self.enableBtn.layer.borderColor = appTintColor.cgColor
        
        self.cardDetailsView.getRounded(cornerRaius: 2)
        self.cardDetailsView.giveShadow(cornerRaius: 2)
    }
    
    func setDataInViews() {
        self.cardInfoLbl.text = "*** *** *** \(selectedCardData.cardNumber?.suffix(4) ?? "-")\nExp: \(selectedCardData.expMonth ?? "")/\(selectedCardData.expYear ?? "")"
        self.ownerLbl.text = selectedCardData.userName?.removingPercentEncoding! ?? ""
        enableBtn.setImage(((selectedCardData.defaultStatus == "0") ? nil : #imageLiteral(resourceName: "ic_done_18pt") ), for: .normal)
    }
    
    func addCardStatusFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.addCardStatusFromServer(id: (DrinkUser.iUser.userId as NSString?)!.integerValue, cardId: (self.selectedCardData.cardId as NSString?)!.integerValue) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                self!.updateCardStatus()
                self!.showToast(message: "card status updated...")
            } else {
                self!.showToast(message: "Error updating card status...")
                //err
            }
        }
    }
    
    func deleteCardFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.deleteCardFromServer(id: (DrinkUser.iUser.userId as NSString?)!.integerValue, cardId: (self.selectedCardData.cardId as NSString?)!.integerValue) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                _ = self!.navigationController?.popViewController(animated: true)
            } else {
                self!.showToast(message: "Error deleting card...")
                //err
            }
        }
    }
    
    func updateCardStatus() {
        if self.enableBtn.currentImage == nil {
            self.enableBtn.setImage(#imageLiteral(resourceName: "ic_done_18pt"), for: .normal)
        } else {
            self.enableBtn.setImage(nil, for: .normal)
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func enableCardAction(_ sender: Any) {
        addCardStatusFromManager()
    }
    
    @IBAction func removeAction(_ sender: Any) {
        deleteCardFromManager()
    }

    deinit {
        print("selected card vc deinit")
    }
    
}
