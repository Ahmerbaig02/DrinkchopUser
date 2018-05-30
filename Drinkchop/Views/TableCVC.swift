////
//  TableCVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class TableCVC: UICollectionViewCell {

    @IBOutlet var tableLbl: UILabel!
    @IBOutlet var tableImgView: UIImageView!
    
    override var bounds: CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.getRounded(cornerRaius: 10)
        self.giveShadow(cornerRaius: 10)
    }
    
    deinit {
        print("TableCVC deinit")
    }

}
