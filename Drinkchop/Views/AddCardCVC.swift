////
//  AddCardCVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class AddCardCVC: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.getRounded(cornerRaius: 2)
        self.giveShadow(cornerRaius: 2)
    }
    
    deinit {
        print("add card cvc deinit")
    }

}
