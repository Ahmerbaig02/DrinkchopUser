////
//  SelectedEventVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class SelectedEventVC: UIViewController {
    
    @IBOutlet var drinkImgView: UIImageView!
    @IBOutlet var titleLbl:UILabel!
    @IBOutlet var timeLbl:UILabel!
    @IBOutlet var expiryLbl:UILabel!
    @IBOutlet var distanceLbl:UILabel!
    @IBOutlet var aboutTV:UITextView!
    @IBOutlet var locationBtn:UIButton!
    
    var isEventView:Bool = true
    var isFavourites:Bool = false
    
    @IBOutlet var saveBtn:UIButton!
    
    var selectedEventData: DrinkEvent!
    var selectedHourData: DrinkHappyHour!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkFavFromManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isEventView {
            self.setEventDataInViews()
            self.locationBtn.isHidden = isFavourites
        } else {
            self.locationBtn.isHidden = true
            self.setHourDataInViews()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.drinkImgView.getRounded(cornerRaius: 10)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? LocationVC {
            controller.barLat = (self.selectedEventData.lat as NSString?)!.doubleValue
            controller.barLng = (self.selectedEventData.lng as NSString?)!.doubleValue
        }
    }
    
    func checkFavFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.checkFavoritesOnServer(item: (!isEventView) ? self.selectedHourData.happyHourId! : self.selectedEventData.eventId!, barId: (!isEventView) ? self.selectedHourData.barId! : self.selectedEventData.barId!, type: "event") { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                print(success)
                self!.saveBtn.tintColor = appTintColor
            } else {
                self!.saveBtn.tintColor = .darkGray
            }
            self!.saveBtn.setImage(#imageLiteral(resourceName: "ic_favorite"), for: .normal)
        }
    }
    
    func setFavFromManager(check: Int) {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.saveFavoritesOnServer(itemId: (!isEventView) ? self.selectedHourData.happyHourId! : self.selectedEventData.eventId! ,check: check, barId: (!isEventView) ? self.selectedHourData.barId! : self.selectedEventData.barId!, type: "event") { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                if check == 1 {
                    print(success)
                    self!.showToast(message: "Added to favourites...")
                    self!.saveBtn.tintColor = appTintColor
                } else {
                    self!.showToast(message: "Removed from favourites...")
                    self!.saveBtn.tintColor = .darkGray
                }
                self!.saveBtn.setImage(#imageLiteral(resourceName: "ic_favorite"), for: .normal)
            } else {
                self!.showToast(message: "Error saving favourites. Please try again...")
                print("error save favourite")
            }
        }
    }
    
    func setEventDataInViews() {
        titleLbl.text = selectedEventData.eventName
        drinkImgView.pin_setImage(from: URL(string: selectedEventData.eventImage ?? ""))
        //distanceLbl.text = "\(selectedEventData.lat ?? 0) miles away"
        timeLbl.text = "opens \(makeShortReadableTime(str: selectedEventData.eventStartTime ?? "")) - \(makeShortReadableTime(str: selectedEventData.eventEndTime ?? ""))"
        self.aboutTV.text = self.selectedEventData.eventAbout ?? ""
        self.expiryLbl.text = "Expires in \(timeDifference(t1: selectedEventData.eventEndTime ?? "", t2: selectedEventData.eventStartTime ?? ""))"
    }
    
    func setHourDataInViews() {
        titleLbl.text = selectedHourData.happyHourName ?? ""
        drinkImgView.pin_setImage(from: URL(string: selectedHourData.happyHourImage ?? ""))
        //distanceLbl.text = "\(selectedEventData.lat ?? 0) miles away"
        timeLbl.text = "opens \(makeShortReadableTime(str: selectedHourData.happyHourStartTime ?? "")) - \(makeShortReadableTime(str: selectedHourData.happyHourEndTime ?? ""))"
        self.aboutTV.text = self.selectedHourData.happyHourAbout ?? ""
        self.expiryLbl.text = "Expires in \(timeDifference(t1: selectedHourData.happyHourEndTime ?? "", t2: selectedHourData.happyHourStartTime ?? ""))"
    }
    
    @IBAction func fbAction(_ sender: Any) {
        
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
    }
    
    @IBAction func googlePlusAction(_ sender: Any) {
        
    }
    
    @IBAction func twitterAction(_ sender: Any) {
        
    }
    
    @IBAction func favouriteAction(_ sender: Any) {
        setFavFromManager(check: (saveBtn.tintColor == appTintColor) ? 0 : 1)
    }
    
    @IBAction func locationAction(_ sender: Any) {
        self.performSegue(withIdentifier: LocationSegueID, sender: nil)
    }
    
    
    deinit {
        print("selected event vc")
    }
}
