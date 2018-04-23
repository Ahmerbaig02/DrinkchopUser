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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
    }
    
    func registerCells() {
        let addCardCellNib = UINib(nibName: "AddCardCVC", bundle: nil)
        let cardCellNib = UINib(nibName: "CardCVC", bundle: nil)
        self.cardsCollectionView.register(cardCellNib, forCellWithReuseIdentifier: CardCellID)
        self.cardsCollectionView.register(addCardCellNib, forCellWithReuseIdentifier: AddCardCellID)
    }
    
    deinit {
        print("cards vc deinit")
    }

}

extension CardsVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCardCellID, for: indexPath) as! AddCardCVC
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCellID, for: indexPath) as! CardCVC
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 3 {
        return getCellHeaderSize(Width: self.view.frame.width, aspectRatio: 300.0/50.0, padding: 20)
        }
        return getCellHeaderSize(Width: self.view.frame.width, aspectRatio: 300.0/84.0, padding: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: SelectedCardSegueID, sender: nil)
    }
}

