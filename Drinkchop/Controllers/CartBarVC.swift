////
//  CartBarVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class CartBarVC: UIViewController {
    
    @IBOutlet var orderTableView:UITableView!
    
    var ordersData:[[Drink]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getMyOrdersDataFromDB()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? CartVC {
            controller.drinksData = self.ordersData[sender as! Int]
        }
    }
    
    func getMyOrdersDataFromDB() {
        guard let data = UserDefaults.standard.data(forKey: CartDefaultsID) else {
            self.ordersData = []
            self.orderTableView.reloadData()
            return
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let drinks = try? decoder.decode([Drink].self, from: data) else {
            self.ordersData = []
            self.orderTableView.reloadData()
            return
        }
        var drinksData = drinks.filter({ $0.userId == DrinkUser.iUser.userId })
        
        
        let uniqueBars = Array(Set(drinks.map({$0.barId!})))
        self.ordersData.removeAll(keepingCapacity: false)
        for (index,bar) in uniqueBars.enumerated() {
            let barDrinks = drinks.filter({ $0.barId == bar })
            self.ordersData.append(barDrinks)
            print("Bar Drinks at Index: \(index)", barDrinks)
        }
        self.orderTableView.reloadData()
    }
    
    deinit {
        print("my order vc deinit")
    }
}

extension CartBarVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCellID, for: indexPath)
        let selectedOrder = self.ordersData[indexPath.row]
        cell.textLabel?.text = "Bar ID:\t\(selectedOrder[0].barId!)"
        var cost = 0.0
        for amount in selectedOrder {
            cost+=((amount.quantity as NSString?)!.doubleValue * (amount.drinkCost as NSString?)!.doubleValue)
        }
        cell.detailTextLabel?.text = "Total Cost:\t$\(cost.getRounded(uptoPlaces: 2))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.orderTableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: CartDataSegueID, sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        //return getCellHeaderSize(Width: self.view.frame.width, aspectRatio: 300/35, padding: 20).height
    }
}

