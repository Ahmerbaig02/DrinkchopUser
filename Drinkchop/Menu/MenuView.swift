//
//  MenuView.swift
//  ParkVit
//
//  Created by Mac on 07/12/2016.
//
//

import UIKit

class MenuView: UIViewController {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var Name: UILabel!
    @IBOutlet var menuTable:UITableView!
    
    var MyAccountDetails:[String:Any]!
    
    let titles:[String] = ["Cards","Cover","Notifications", "Settings","My Account","Contact Us","My Favourite","The Hyve","Find","My Orders"]
    
    
    let textAligments:[NSTextAlignment] = [.left,.left,.left,.left,.left,.left,.left,.left,.left,.left]
    
    let fontStyles:[UIFont] = [.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium)]
    
    let menuImages:[UIImage?] = [#imageLiteral(resourceName: "ic_credit_card"),#imageLiteral(resourceName: "ic_work"),#imageLiteral(resourceName: "ic_notification"),#imageLiteral(resourceName: "ic_settings"),#imageLiteral(resourceName: "ic_info_outline_white"),#imageLiteral(resourceName: "ic_phone"),#imageLiteral(resourceName: "ic_favorite"),#imageLiteral(resourceName: "ic_about"),#imageLiteral(resourceName: "ic_search"),#imageLiteral(resourceName: "ic_shopping_cart")]
    let BGColors:[UIColor] = [.clear,.clear,.clear,.clear,.clear,.clear,.clear,.clear,.clear,.clear]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTable.estimatedRowHeight = 54.0
        Name.text = "Ahmer Baig"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.userImage.getRounded(cornerRaius: self.userImage.frame.width/2)
    }
    
    func getCellHeaderSize(Width:CGFloat, aspectRatio:CGFloat, padding:CGFloat) -> CGSize {
        
        let cellWidth = (Width ) - padding
        let cellHeight = cellWidth / aspectRatio
        
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
    
    func closeMenu() {
        
        if let drawerController = parent as? KYDrawerController {
            drawerController.setDrawerState(.closed, animated: true)
        }
    }
    
    func DialNumber(phoneNumber:String) {
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    
    // funcion to check for Rider Later and Rider Now Offline Calling
    
    func MakeACall(_ phoneString:String ) {
        
        let MakeACallURL:URL = URL(string: phoneString)!
        
        let application = UIApplication.shared
        
        if application.canOpenURL(MakeACallURL){
            application.openURL(MakeACallURL)
        }
        else{
            print("Can't open Native App to make a call")
        }
    }
    
    // function to book ride offline
    func showContactSheet() {
        
        let alertCall = UIAlertController(title: "Contact Us!", message: "Below are our contact numbers. Select One to Call our Customer Service", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        var phoneString:String = "tel:"
        
        alertCall.addAction(UIAlertAction(title: "Dial +15164660066", style: UIAlertActionStyle.destructive, handler: { [weak self] (UIAlertAction) in
            phoneString += "+15164660066"
            self!.MakeACall(phoneString)
        }) )
        
        alertCall.addAction(UIAlertAction(title: "Dial +15164661166", style: UIAlertActionStyle.destructive, handler: { [weak self] (UIAlertAction) in
            phoneString += "+15164661166"
            self!.MakeACall(phoneString)
        }) )
        
        alertCall.addAction(UIAlertAction(title: "Dial +15164667766", style: UIAlertActionStyle.destructive, handler: { [weak self](UIAlertAction) in
            phoneString += "+15164667766"
            self!.MakeACall(phoneString)
        }) )
        
        alertCall.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
            
            if let currentPopoverpresentioncontroller = alertCall.popoverPresentationController {
                currentPopoverpresentioncontroller.sourceView = self.view
                currentPopoverpresentioncontroller.sourceRect = self.view.bounds
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.down
                present(alertCall, animated: true, completion: nil)
            }
        }
        else{
            present(alertCall, animated: true, completion: nil)
        }
        
    }
    
    func doLogout() {
        UserDefaults.standard.set(false, forKey: isLoggedInDefaultID)
        self.dismiss(animated: true, completion: nil)
    }
    
    func showLogoutAlert() {
        let confirm = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        confirm.addAction(UIAlertAction(title: "Sign out", style: .default, handler: { [weak self] (action) in
            self!.doLogout()
        }))
        
        confirm.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(confirm, animated: true, completion: nil)
    }
    
    @IBAction func SignoutAction(_ sender: Any) {
        showLogoutAlert()
    }
    
    deinit {
        print("Menu View deinit")
    }
    
}

extension MenuView: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if titles[indexPath.row] == "" {
            return 1
        }
        
        return getCellHeaderSize(Width: self.view.frame.width, aspectRatio: 240/54, padding: 0).height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        
        cell.textLabel?.text = titles[indexPath.row]
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.font = fontStyles[indexPath.row]
        cell.textLabel?.textAlignment = textAligments[indexPath.row]
        cell.backgroundColor = BGColors[indexPath.row]
        cell.imageView?.tintColor = .gray
        cell.imageView?.image = menuImages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if titles[indexPath.row] == "Contact Us" {
            showContactSheet()
        } else {
            ID = (titles[indexPath.row] == " ") ? "" : titles[indexPath.row]
            closeMenu()
        }
    }
    
}
