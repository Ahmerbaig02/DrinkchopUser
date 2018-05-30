//
//  MenuView.swift
//  ParkVit
//
//  Created by Mac on 07/12/2016.
//
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import swiftScan

class MenuView: UIViewController {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var Name: UILabel!
    @IBOutlet var menuTable:UITableView!
    
    var MyAccountDetails:[String:Any]!
    
    let titles:[String] = ["Find","Events/HappyHours","Notifications","My Favourite","My Orders","Cover","Scan QRCode","Settings","My Account","Help","Signout"]
    
    
    var ScanController = LBXScanViewController()
    
    let textAligments:[NSTextAlignment] = [.left,.left,.left,.left,.left,.left,.left,.left,.left,.left,.left]
    
    let fontStyles:[UIFont] = [.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium)]
    
    let menuImages:[UIImage?] = [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil]
    let BGColors:[UIColor] = [.clear,.clear,.clear,.clear,.clear,.clear,.clear,.clear,.clear,.clear,.clear,.clear]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTable.estimatedRowHeight = 54.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Name.text = DrinkUser.iUser.userName?.removingPercentEncoding ?? ""
        userImage.pin_setImage(from: URL(string: DrinkUser.iUser.userImage ?? ""))
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
    
    func doLogout() {
        UserDefaults.standard.set(false, forKey: isLoggedInDefaultID)
        UserDefaults.standard.set(nil, forKey: settingsDefaultsID)
        GIDSignIn.sharedInstance().signOut()
        FBSDKLoginManager().logOut()
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
    
    func showAlert(title: String, Message: String) {
        let confirm = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        confirm.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(confirm, animated: true, completion: nil)
    }
    
    func getTableServiceFromManager(tableID: String) {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.getTableServiceFromServer(userId: DrinkUser.iUser.userId!, tableID: tableID) { [weak self] (success) in
            Manager.hideLoader()
            self!.ScanController.startScan()
            if let success = success {
                print("Success:", success)
                self!.ScanController.showToast(message: "User Registered...")
            } else {
                self!.ScanController.showToast(message: "User Not Registered...")
                
            }
        }
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
        if titles[indexPath.row] == "Scan QRCode"  {
            let controller = self.ScanController
            controller.drawScanView()
            controller.scanStyle = LBXScanViewStyle()
            controller.scanResultDelegate = self
            if let scanView = controller.qRScanView {
                let closeBtn = UIButton(frame: CGRect(x: 10, y: 20, width: 40 , height: 40))
                closeBtn.getRounded(cornerRaius: 20)
                closeBtn.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
                closeBtn.setImage(#imageLiteral(resourceName: "ic_clear_white"), for: .normal)
                closeBtn.addTarget(self, action: #selector(dismissScanVC(_:)), for: .touchUpInside)
                scanView.addSubview(closeBtn)
                self.present(controller, animated: true) {
                    controller.startScan()
                }
            }
        } else if titles[indexPath.row] == "Signout" {
            showLogoutAlert()
        } else {
            ID = (titles[indexPath.row] == " ") ? "" : titles[indexPath.row]
            closeMenu()
        }
    }
    
    @objc func dismissScanVC(_ sender: UIButton) {
        let controller = self.ScanController
        controller.dismiss(animated: true, completion: nil)
    }
    
}

extension MenuView: LBXScanViewControllerDelegate {
    
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        if let err = error {
            print("Error: ", err)
        } else {
            print("Result:", scanResult.strScanned ?? "")
            getTableServiceFromManager(tableID: scanResult.strScanned ?? "")
        }
    }
    
}
