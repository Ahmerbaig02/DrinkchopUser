//
//  BarPaymentVC.swift
//  DrinkChopAdmin
//
//  Created by Mahnoor Fatima on 5/6/18.
//  Copyright © 2018 Mahnoor Fatima. All rights reserved.
//

import UIKit

class BarPaymentVC: UIViewController {

    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var barNameLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var confirmCodeLbl: UILabel!
    @IBOutlet weak var paymentInfoLbl: UILabel!
    
    var coverData: DrinkCover!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userImgView.clipsToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setDataInViews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.userNameLbl.getRounded(cornerRaius: 5)
        self.userNameLbl.giveShadow(cornerRaius: 5)
        self.confirmCodeLbl.getRounded(cornerRaius: 5)
        self.confirmCodeLbl.giveShadow(cornerRaius: 5)
        
        self.userImgView.getRounded(cornerRaius: userImgView.frame.width/2)
    }
    
    fileprivate func setDataInViews() {
        self.userImgView.pin_setImage(from: URL(string: DrinkUser.iUser.userImage ?? ""))
        self.barNameLbl.text = self.coverData.userName?.removingPercentEncoding ?? ""
        self.userNameLbl.text = self.coverData.name?.removingPercentEncoding ?? ""
        self.confirmCodeLbl.text = "Confirmation Number:\n\(self.coverData.confirmationId ?? "")"
        self.paymentInfoLbl.text = "Paid For: \(self.coverData.entryCount ?? "0")\n\nTotal Amount: \(self.coverData.amount ?? "0")"
    }
    
    deinit {
        print("deinit bar payment VC")
    }
}
