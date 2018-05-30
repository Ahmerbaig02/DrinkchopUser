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
    
    var coversData:[DrinkCover] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? BarPaymentVC {
            controller.coverData = self.coversData[sender as! Int]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNoDataView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeNoDataView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getCoverDataFromManager()
    }
    
    func getCoverDataFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.getCoversFromServer(id: DrinkUser.iUser.userId!) { [weak self] (coversData) in
            Manager.hideLoader()
            if let covers = coversData {
                self!.coversData = covers
                self!.coverTableView.reloadData()
                self!.hideNoDataView()
            } else {
                self!.coversData = []
                self!.showDataView(text: "No Covers Data")
                self!.showToast(message: "Error fetching covers...")
                //err
            }
        }
    }

    deinit {
        print("cover vc deinit")
    }
}

extension CoverVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coversData.count
    }
    
    func configureCell(cell: UITableViewCell, index: Int) {
        let selectedCover = self.coversData[index]
        cell.textLabel?.attributedText = getAttributedText(Titles: [selectedCover.name ?? "",selectedCover.coverDate ?? ""], Font: [UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold), UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)], Colors: [UIColor.darkGray, UIColor.lightGray], seperator: ["\n",""], Spacing: 4, atIndex: 0)
        cell.detailTextLabel?.attributedText = getAttributedText(Titles: ["","Expires in 5hrs 20min"], Font: [UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold), UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)], Colors: [UIColor.darkGray, UIColor.lightGray], seperator: ["\n",""], Spacing: 0, atIndex: -1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CoverCellID, for: indexPath)
        
        configureCell(cell: cell, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SelectedCover", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
