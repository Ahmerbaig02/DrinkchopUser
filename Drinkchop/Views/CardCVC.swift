////
//  CardCVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class CardCVC: UICollectionViewCell {

    @IBOutlet var enableBtn: UIButton!
    @IBOutlet var ownerLbl: UILabel!
    @IBOutlet var cardInfoLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.getRounded(cornerRaius: 2)
        self.giveShadow(cornerRaius: 2)
        
        self.enableBtn.getRounded(cornerRaius: 5)
        self.enableBtn.layer.borderWidth = 1.5
        self.enableBtn.layer.borderColor = appTintColor.cgColor
    }
    
    @IBAction func enableCardAction(_ sender: Any) {
        if self.enableBtn.currentImage == nil {
            self.enableBtn.setImage(#imageLiteral(resourceName: "ic_done_18pt"), for: .normal)
        } else {
            self.enableBtn.setImage(nil, for: .normal)
        }
    }
    
    deinit {
        print("card cvc deinit")
    }
}
