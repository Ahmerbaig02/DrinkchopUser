////
//  SearchDrinkCVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class SearchDrinkCVC: UICollectionViewCell {

    @IBOutlet var barImgView: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var locationLbl: UILabel!
    @IBOutlet var distanceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        barImgView.getRounded(cornerRaius: 10)
    }

}
