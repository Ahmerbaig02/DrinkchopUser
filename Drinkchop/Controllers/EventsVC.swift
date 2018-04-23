
////
//  EventsVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class EventsVC: UIViewController {

    @IBOutlet var filterSlider: UISlider!
    @IBOutlet var milesLbl: UILabel!
    @IBOutlet var filterView: UIView!
    @IBOutlet var eventsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
    }
    
    func registerCell() {
        let cellNib = UINib(nibName: "EventsCVC", bundle: nil)
        eventsCollectionView.register(cellNib, forCellWithReuseIdentifier: EventCellID)
    }
    
    @IBAction func zipCodeAction(_ sender: Any) {
        let alertVC = UIAlertController(title: "Zip Code", message: "Type Zide Code below:", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            print(alertVC.textFields![0].text!)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertVC.addTextField { (field) in
            field.placeholder = "e.g.. 54000"
        }
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func filterRadiusChangedAction(_ sender: Any) {
        self.milesLbl.text = "\(Int(self.filterSlider.value)) Miles"
    }
    deinit {
        print("deinit EventVC")
    }

}

extension EventsVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCellID, for: indexPath) as! EventsCVC
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellHeaderSize(Width: view.frame.width, aspectRatio: 300/80, padding: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            self.filterView.isHidden = !self.filterView.isHidden
        }
    }
    
}
