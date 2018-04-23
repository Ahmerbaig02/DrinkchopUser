////
//  HyveDrinkCVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class HyveDrinkCVC: UICollectionViewCell {

    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var drinkImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.drinkImgView.getRounded(cornerRaius: 5)
        self.priceLbl.getRounded(cornerRaius: 2)
    }

}
