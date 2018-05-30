
////
//  EventsVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class EventsVC: UIViewController {

    @IBOutlet var showFilterBtn: UIButton!
    @IBOutlet var filterSlider: UISlider!
    @IBOutlet var milesLbl: UILabel!
    @IBOutlet var filterView: UIView!
    @IBOutlet var eventsCollectionView: UICollectionView!
    
    var lat: Double = 0.0
    var lng: Double = 0.0
    
    var selectedBarData: DrinkBar!
    
    var eventsData:[DrinkEvent] = []
    var hoursData:[DrinkHappyHour] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterView.isHidden = true
        
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if selectedBarData != nil {
            self.showFilterBtn.isHidden = true
            if self.view.tag == 0 {
            getEventsDataFromManager(barId: (self.selectedBarData.barId as NSString?)!.integerValue)
            } else {
                getHappyHoursDataFromManager(barId: (self.selectedBarData.barId as NSString?)!.integerValue)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.filterView.getRounded(cornerRaius: 0)
        self.filterView.giveShadow(cornerRaius: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? SelectedEventVC {
            let dict = sender as! [String:Any]
            controller.isEventView = dict["isEventView"] as! Bool
            if self.view.tag == 0 {
                controller.selectedEventData = self.eventsData[dict["index"] as! Int]
            } else {
                controller.selectedHourData = self.hoursData[dict["index"] as! Int]
            }
        }
    }
    
    func registerCell() {
        let cellNib = UINib(nibName: "EventsCVC", bundle: nil)
        eventsCollectionView.register(cellNib, forCellWithReuseIdentifier: EventCellID)
    }
    
    func getEventsDataFromManager(lat: Double, lng: Double, distance: Double) {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.getEventsDataFromServer(lat: lat, lng: lng, distance: distance) { [weak self] (drinkEvents) in
            Manager.hideLoader()
            if let events = drinkEvents {
                self!.eventsData.removeAll(keepingCapacity: false)
                self!.eventsData = events
                self!.eventsCollectionView.reloadData()
            } else {
                self!.showToast(message: "No events nearby...")
                //error
            }
        }
    }
    
    func getEventsDataFromManager(barId: Int) {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.getEventsDataFromServer(Id: barId) { [weak self] (drinkEvents) in
            Manager.hideLoader()
            if let events = drinkEvents {
                self!.eventsData.removeAll(keepingCapacity: false)
                self!.eventsData = events
                self!.eventsCollectionView.reloadData()
            } else {
                self!.showToast(message: "No events nearby...")
                //error
            }
        }
    }

    func getHappyHoursDataFromManager(barId: Int) {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.getHappyHoursDataFromServer(Id: barId) { [weak self] (drinkHours) in
            Manager.hideLoader()
            if let hours = drinkHours {
                self!.hoursData.removeAll(keepingCapacity: false)
                self!.hoursData = hours
                self!.eventsCollectionView.reloadData()
            } else {
                self!.showToast(message: "No happy hours nearby...")
                //error
            }
        }
    }
    
    func getHappyHoursDataFromManager(lat: Double, lng: Double, distance: Double) {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.getEventsHappyHoursDataFromServer() { [weak self] (drinkEvents, drinkHours) in
            Manager.hideLoader()
            if let drinkHours = drinkHours {
                self!.hoursData.removeAll(keepingCapacity: false)
                self!.hoursData = drinkHours
                self!.eventsCollectionView.reloadData()
            } else {
                self!.showToast(message: "No happy hours nearby...")
                //error
            }
        }
    }
    
    @IBAction func zipCodeAction(_ sender: Any) {
        let alertVC = UIAlertController(title: "Zip Code", message: "Type Zide Code below:", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            print(alertVC.textFields![0].text!)
            if alertVC.textFields![0].text!.count < 5 {
                self.zipCodeAction(sender)
            } else {
                if self.view.tag == 0 {
                    self.getEventsDataFromManager(lat: self.lat, lng: self.lng, distance: Double(self.filterSlider.value))
                } else {
                    self.getHappyHoursDataFromManager(lat: self.lat, lng: self.lng, distance: Double(self.filterSlider.value))
                }
            }
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertVC.addTextField { (field) in
            field.placeholder = "e.g.. 54000"
            field.keyboardType = .numberPad
        }
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func filterRadiusChangedAction(_ sender: Any) {
        let distance = Int(self.filterSlider.value)
        self.milesLbl.text = "\(distance) Miles"
        if self.view.tag == 0 {
            self.getEventsDataFromManager(lat: self.lat, lng: self.lng, distance: Double(self.filterSlider.value))
        } else {
            self.getHappyHoursDataFromManager(lat: self.lat, lng: self.lng, distance: Double(self.filterSlider.value))
        }
    }
    
    @IBAction func showHideFilterViewAction(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.filterView.isHidden = !self.filterView.isHidden
        }
    }
    
    deinit {
        print("deinit EventVC")
    }

}

extension EventsVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.view.tag == 0) ? self.eventsData.count : self.hoursData.count
    }
    
    func configureEventCell(cell: EventsCVC, index: Int) {
        let currentEvent = self.eventsData[index]
        cell.nameLbl.text = currentEvent.eventName ?? ""
        cell.eventImgView.pin_setImage(from: URL(string: currentEvent.eventImage ?? ""))
        cell.timingLbl.text = "\(makeShortReadableTime(str: currentEvent.eventStartTime ?? "")) - \(makeShortReadableTime(str: currentEvent.eventEndTime ?? ""))"
        cell.eventInfoLbl.text = currentEvent.eventAbout
    }
    
    func configureHourCell(cell: EventsCVC, index: Int) {
        let currentHour = self.hoursData[index]
        cell.nameLbl.text = currentHour.happyHourName ?? ""
        cell.eventImgView.pin_setImage(from: URL(string: currentHour.happyHourImage ?? ""))
        cell.timingLbl.text = "\(makeShortReadableTime(str: currentHour.happyHourStartTime ?? "")) - \(makeShortReadableTime(str: currentHour.happyHourEndTime ?? ""))"
        cell.eventInfoLbl.text = currentHour.happyHourAbout
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCellID, for: indexPath) as! EventsCVC
        if self.view.tag == 1 {
            configureHourCell(cell: cell, index: indexPath.row)
            return cell
        }
        configureEventCell(cell: cell, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellHeaderSize(Width: collectionView.frame.width, aspectRatio: 300/80, padding: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict:[String:Any] = ["isEventView": self.view.tag == 0,"index":indexPath.row]
        self.performSegue(withIdentifier: SelectedEventSegueID, sender: dict)
    }
    
}
