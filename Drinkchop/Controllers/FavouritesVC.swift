////
//  FavouritesVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class FavouritesVC: UIViewController {
    
    @IBOutlet var favouritesCollectionView: UICollectionView!

    var titlesStr:[String] = ["Drinks","Drinks(Events)", "Happy Hours"]
    
    fileprivate var selectedSections:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
    }

    func registerCells() {
        let drinkCellNib = UINib(nibName: "DrinkCVC", bundle: nil)
        let headerNib = UINib(nibName: "FavouritesHeaderView", bundle: nil)
        let footerNib = UINib(nibName: "FavouritesFooterView", bundle: nil)
        
        favouritesCollectionView.register(drinkCellNib, forCellWithReuseIdentifier: DrinkCellID)
        favouritesCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: FavouritesHeaderID)
        favouritesCollectionView.register(footerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: FavouritesFooterID)
    }
    
    deinit {
        print("favourites vc deinit")
    }
}

extension FavouritesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return titlesStr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedSections.contains(section) {
            return 0
        }
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrinkCellID, for: indexPath) as! DrinkCVC
        
        cell.nameLbl.text = "Apple Orange"
        cell.priceLbl.attributedText = getAttributedText(Titles: ["10% alcohol","$20"], Font: [UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.semibold), UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.semibold)], Colors: [UIColor.lightGray, UIColor.orange], seperator: ["\t",""], Spacing: 0, atIndex: -1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellHeaderSize(Width: self.view.frame.width, aspectRatio: 300.0/30.0, padding: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FavouritesHeaderID, for: indexPath) as! FavouritesHeaderView
            header.infoLbl.text = titlesStr[indexPath.section]
            header.tag = indexPath.section
            if !header.isGestureAdded {
                let tapGest = UITapGestureRecognizer(target: self, action: #selector(didSelectHeaderAt(gesture:)))
                header.addGestureRecognizer(tapGest)
                header.isGestureAdded = true
            }
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FavouritesFooterID, for: indexPath) as! FavouritesFooterView
            footer.backgroundColor = UIColor.lightGray
            return footer
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width - 20, height: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return getCellHeaderSize(Width: self.view.frame.width, aspectRatio: 300.0/30.0, padding: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    @objc func didSelectHeaderAt(gesture: UITapGestureRecognizer) {
        let headerView = gesture.view!
        print(headerView.tag)
        if selectedSections.contains(headerView.tag) {
            self.selectedSections.remove(at: selectedSections.index(of: headerView.tag)!)
            self.favouritesCollectionView.reloadSections([headerView.tag])
        } else {
            self.selectedSections.append(headerView.tag)
            self.favouritesCollectionView.reloadSections(IndexSet(selectedSections))
        }
    }
    
}
