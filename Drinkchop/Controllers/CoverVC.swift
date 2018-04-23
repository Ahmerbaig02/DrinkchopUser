////
//  CoverVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class CoverVC: UIViewController {

    @IBOutlet var coverTableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    deinit {
        print("cover vc deinit")
    }
}

extension CoverVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CoverCellID, for: indexPath)
        
        cell.textLabel?.attributedText = getAttributedText(Titles: ["John Doe Club","02/11/18\tat\t1:50am"], Font: [UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold), UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)], Colors: [UIColor.darkGray, UIColor.lightGray], seperator: ["\n",""], Spacing: 4, atIndex: 0)
        cell.detailTextLabel?.attributedText = getAttributedText(Titles: ["","Expires in 5hrs 20min"], Font: [UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold), UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)], Colors: [UIColor.darkGray, UIColor.lightGray], seperator: ["\n",""], Spacing: 0, atIndex: -1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
