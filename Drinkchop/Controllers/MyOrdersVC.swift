////
//  MyOrdersVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class MyOrdersVC: UIViewController {

    @IBOutlet var orderTableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        registerCell()
    }
    
    func registerCell() {
        let cellNib = UINib(nibName: "OrdersTVC", bundle: nil)
        self.orderTableView.register(cellNib, forCellReuseIdentifier: OrderCellID)
    }
    
    deinit {
        print("my order vc deinit")
    }
}

extension MyOrdersVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCellID, for: indexPath) as! OrdersTVC
        cell.infoLbl.attributedText = getAttributedText(Titles: ["John Doe","11/12/2018"], Font: [UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.semibold), UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.medium)], Colors: [UIColor.darkGray, UIColor.lightGray], seperator: ["\n",""], Spacing: 4, atIndex: 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.orderTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCellHeaderSize(Width: self.view.frame.width, aspectRatio: 300/35, padding: 20).height
    }
    
}
