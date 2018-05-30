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

    var titlesStr:[String] = ["Drinks","Drinks(Events)"]
    
    var drinksData:[Drink] = []
    var eventsData:[DrinkEvent] = []
    
    fileprivate var selectedSections:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        getFavoritesFromManager()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? SelectedEventVC {
            let index = sender as! Int
            controller.isEventView = true
            controller.isFavourites = true
            if self.view.tag == 0 {
                controller.selectedEventData = self.eventsData[index]
            }
        }
    }

    func registerCells() {
        let drinkCellNib = UINib(nibName: "DrinkCVC", bundle: nil)
        let headerNib = UINib(nibName: "FavouritesHeaderView", bundle: nil)
        let footerNib = UINib(nibName: "FavouritesFooterView", bundle: nil)
        let eventCellNib = UINib(nibName: "EventsCVC", bundle: nil)
        
        favouritesCollectionView.register(eventCellNib, forCellWithReuseIdentifier: EventCellID)
        favouritesCollectionView.register(drinkCellNib, forCellWithReuseIdentifier: DrinkCellID)
        favouritesCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: FavouritesHeaderID)
        favouritesCollectionView.register(footerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: FavouritesFooterID)
    }
    
    func getFavoritesFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.getFavoritesFromServer(id: (DrinkUser.iUser.userId as NSString?)!.integerValue) { [weak self] (drinkEvents, drinksData) in
            Manager.hideLoader()
            if drinkEvents != nil || drinksData != nil {
                self!.eventsData = drinkEvents ?? []
                self!.drinksData = drinksData ?? []
                self!.hideNoDataView()
                self!.favouritesCollectionView.reloadData()
            } else {
                self!.showDataView(text: "No Favourites Data")
                self!.showToast(message: "Error fetching favourites. Please try again...")
                //err
            }
        }
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
        if section == 0 {
            return drinksData.count
        } else if section == 1 {
            return eventsData.count
        }
        return 0
    }
    
    func configureEventCell(cell: EventsCVC, index: Int) {
        let currentEvent = self.eventsData[index]
        cell.nameLbl.text = currentEvent.eventName ?? ""
        cell.eventImgView.pin_setImage(from: URL(string: currentEvent.eventImage ?? ""))
        cell.timingLbl.text = "\(makeShortReadableTime(str: currentEvent.eventStartTime ?? "")) - \(makeShortReadableTime(str: currentEvent.eventEndTime ?? ""))"
        cell.eventInfoLbl.text = currentEvent.eventAbout
    }
    
    func configureDrinkCell(cell: DrinkCVC, index: Int) {
        let selectedDrink = self.drinksData[index]
        cell.nameLbl.text = selectedDrink.drinkName ?? ""
            cell.priceLbl.attributedText = getAttributedText(Titles: ["\(selectedDrink.drinkAlcohal ?? "0")% alcohol","$\(selectedDrink.drinkCost ?? "0")"], Font: [UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.semibold), UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.semibold)], Colors: [UIColor.lightGray, UIColor.orange], seperator: ["\t",""], Spacing: 0, atIndex: -1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrinkCellID, for: indexPath) as! DrinkCVC
            configureDrinkCell(cell: cell, index: indexPath.row)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCellID, for: indexPath) as! EventsCVC
        configureEventCell(cell: cell, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return getCellHeaderSize(Width: self.view.frame.width, aspectRatio: 300.0/30.0, padding: 20)
        }
        return getCellHeaderSize(Width: collectionView.frame.width, aspectRatio: 300/80, padding: 0)
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
        if indexPath.section == 1 {
            self.performSegue(withIdentifier: SelectedEventSegueID, sender: indexPath.row)
        }
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
