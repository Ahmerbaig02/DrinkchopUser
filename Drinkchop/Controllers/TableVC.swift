////
//  TableVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class TableVC: UIViewController {

    @IBOutlet var tablesCollectionView: UICollectionView!
    
    var tablesData:[DrinkTable] = []
    var selectedBarData: DrinkBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getTablesFromServer()
    }
    
    
    func registerCells() {
        let cellNib = UINib(nibName: "TableCVC", bundle: nil)
        self.tablesCollectionView.register(cellNib, forCellWithReuseIdentifier: TableCellID)
    }
    
    func getTablesFromServer() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.getTablesFromServer(id: self.selectedBarData.barId!) { [weak self] (tables) in
            Manager.hideLoader()
            if let tablesData = tables {
                self!.tablesData.removeAll(keepingCapacity: false)
                self!.tablesData  = tablesData
                self!.tablesCollectionView.reloadData()
            } else {
                self!.showToast(message: "Error: No Tables Found")
            }
        }
    }
    
    func reserveTableOnServer(tableId: String) {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.reserveTablesFromServer(barId: self.selectedBarData.barId!, tableId: tableId) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                print("Success:",success)
                _ = self!.navigationController?.popViewController(animated: true)
            } else {
                self!.showToast(message: "Error: Table Not Registered...")
            }
        }
    }
    
    func showAlert(tableId: String) {
        let confirm = UIAlertController(title: "Reserve Table", message: "Are you sure you want to reserve this table?", preferredStyle: .alert)
        confirm.addAction(UIAlertAction(title: "Reserve", style: .default, handler: { [weak self] (action) in
            self!.reserveTableOnServer(tableId: tableId)
        }))
        
        confirm.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(confirm, animated: true, completion: nil)
    }
    
    deinit {
        print("tableVC deinit")
    }
}

extension TableVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tablesData.count
    }
    
    func configureCell(cell: TableCVC, index: Int) {
        cell.tableLbl.text = "Table \(self.tablesData[index].tableId!)"
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableCellID, for: indexPath) as! TableCVC
        configureCell(cell: cell, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellHeaderSize(Width: self.view.frame.width, aspectRatio: 300.0/100.0, padding: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showAlert(tableId: self.tablesData[indexPath.row].tableId!)
    }
}
