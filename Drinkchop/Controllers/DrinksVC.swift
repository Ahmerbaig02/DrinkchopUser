////
//  DrinksVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class DrinksVC: UIViewController {

    @IBOutlet var allergyView: UIView!
    @IBOutlet var drinksTableView: UITableView!
    @IBOutlet var allergySwitch: UISwitch!
    
    var selectedBarData: DrinkBar!
    
    var drinksData:[[Drink]] = []
    var drinksTypes:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNoDataView()
        
        getDrinksDataFromManager()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeNoDataView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? HyveVC {
            let indexPath = sender as! IndexPath
            controller.selectedDrinkData = self.drinksData[indexPath.section][indexPath.row]
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.allergyView.getRounded(cornerRaius: 5)
        self.allergyView.giveShadow(cornerRaius: 5)
    }
    
    func registerCell() {
        let cellNib = UINib(nibName: "DrinkTVC", bundle: nil)
        self.drinksTableView.register(cellNib, forCellReuseIdentifier: OrderCellID)
    }
    
    func getDrinksDataFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.getDrinksFromServer(id: (self.selectedBarData.barId as NSString?)!.integerValue) { [weak self] (drinksData, drinkTypes) in
            Manager.hideLoader()
            if let drinks = drinksData, let types = drinkTypes {
                self!.drinksTypes = types
                var newDrinks:[[Drink]] = []
                for type in types {
                    newDrinks.append(drinks.filter({ $0.drinkType == type }))
                }
                self!.drinksData = newDrinks
                self!.drinksTableView.reloadData()
            } else {
                self!.showToast(message: "Error fetching drinks. Please try again...")
                //err
            }
        }
    }
    
    @IBAction func allergyValueChanged(_ sender: Any) {
        print(self.allergySwitch.isOn)
        self.drinksTableView.reloadData()
    }
    
    deinit {
        print("my order vc deinit")
    }
}

extension DrinksVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return drinksTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinksData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCellID, for: indexPath) as! DrinkTVC
        let selectedDrink = self.drinksData[indexPath.section][indexPath.row]
        cell.nameLbl.text = selectedDrink.drinkName ?? ""
        cell.alcoholLbl.text = "\(selectedDrink.drinkAlcohal ?? "0")% alcohol"
        cell.warningImgView.isHidden = !(self.allergySwitch.isOn && DrinkUser.iUser.userAllergies!.contains(selectedDrink.drinkName!))
        cell.drinkImgView.pin_setImage(from: URL(string: selectedDrink.drinkPicture ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.drinksTableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: DrinkDetailsSegueID, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1))
        footer.backgroundColor = UIColor.lightGray
        return footer
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return drinksTypes[section]
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCellHeaderSize(Width: self.view.frame.width, aspectRatio: 320/60, padding: 0).height
    }
    
}
