////
//  CardsVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class CardsVC: UIViewController {

    @IBOutlet var cardsCollectionView:UICollectionView!
    
    var cardsData:[DrinkCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getCardsFromManager()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? SelectedCardVC {
            controller.selectedCardData = self.cardsData[sender as! Int]
        }
    }
    
    func registerCells() {
        let addCardCellNib = UINib(nibName: "AddCardCVC", bundle: nil)
        let cardCellNib = UINib(nibName: "CardCVC", bundle: nil)
        self.cardsCollectionView.register(cardCellNib, forCellWithReuseIdentifier: CardCellID)
        self.cardsCollectionView.register(addCardCellNib, forCellWithReuseIdentifier: AddCardCellID)
    }
    
    func getCardsFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.getCardsFromServer(id: (DrinkUser.iUser.userId as NSString?)!.integerValue) { [weak self] (cardsData) in
            Manager.hideLoader()
            if let cardsData = cardsData {
                self!.cardsData = cardsData
                self!.cardsCollectionView.reloadData()
            } else {
                self!.showToast(message: "Error fetching cards...")
                //error
            }
        }
    }
    
    func addCardStatusFromManager(cardId: Int, index: Int) {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.addCardStatusFromServer(id: (DrinkUser.iUser.userId as NSString?)!.integerValue, cardId: cardId) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                self!.updateCardStatus(index: index)
                self!.showToast(message: "card status updated...")
            } else {
                self!.showToast(message: "Error updating card status")
                //err
            }
        }
    }
    
    func updateCardStatus(index: Int) {
        guard let cell = self.cardsCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? CardCVC else {return}
        if cell.enableBtn.currentImage == nil {
            cell.enableBtn.setImage(#imageLiteral(resourceName: "ic_done_18pt"), for: .normal)
        } else {
            cell.enableBtn.setImage(nil, for: .normal)
        }
        self.cardsData[index].defaultStatus = self.cardsData[index].defaultStatus == "0" ? "1" : "0"
    }
    
    deinit {
        print("cards vc deinit")
    }

}

extension CardsVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cardsData.count + 1
    }
    
    func configureCell(cell: CardCVC, index: Int) {
        let currentCard = self.cardsData[index]
        cell.tag = index
        cell.delegate = self
        cell.cardInfoLbl.text = "*** *** *** \(currentCard.cardNumber?.suffix(4) ?? "-")\nExp: \(currentCard.expMonth ?? "")/\(currentCard.expYear ?? "")"
        cell.ownerLbl.text = currentCard.userName?.removingPercentEncoding! ?? ""
        cell.enableBtn.setImage(((currentCard.defaultStatus == "0") ? nil : #imageLiteral(resourceName: "ic_done_18pt") ), for: .normal)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == cardsData.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCardCellID, for: indexPath) as! AddCardCVC
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCellID, for: indexPath) as! CardCVC
        configureCell(cell: cell, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == cardsData.count {
        return getCellHeaderSize(Width: self.view.frame.width, aspectRatio: 300.0/50.0, padding: 20)
        }
        return getCellHeaderSize(Width: self.view.frame.width, aspectRatio: 300.0/84.0, padding: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < cardsData.count {
            self.performSegue(withIdentifier: SelectedCardSegueID, sender: indexPath.row)
        } else {
            if self.cardsData.count < 4 {
                self.performSegue(withIdentifier: addCardSegueID, sender: nil)
            } else {
                self.showToast(message: "You can't add more than 4 cards...")
                // show alert
            }
        }
    }
}

extension CardsVC: cardCVCDelegate {
    func changeCardStatus(index: Int) {
        self.addCardStatusFromManager(cardId: (self.cardsData[index].cardId as NSString?)!.integerValue, index: index)
    }
}
