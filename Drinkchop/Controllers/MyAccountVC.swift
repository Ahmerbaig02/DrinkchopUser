////
//  MyAccountVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class MyAccountVC: UIViewController {
    
    @IBOutlet var userImgView:UIImageView!
    @IBOutlet var accountCollectionView:UICollectionView!
    
    var titlesStr:[String] = ["My Cards","Password","Allergy","Budget","Cover"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titlesStr.insert(DrinkUser.iUser.userEmail ?? "", at: 0)
        self.titlesStr.insert(DrinkUser.iUser.userName?.removingPercentEncoding ?? "", at: 0)
        
        registerCell()
        
        self.userImgView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.getImageFromLibrary))
        self.userImgView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.userImgView.pin_setImage(from: URL(string: DrinkUser.iUser.userImage ?? ""))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.userImgView.getRounded(cornerRaius: self.userImgView.frame.width/2)
        self.userImgView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func registerCell() {
        let cellNib = UINib(nibName: "AccountCVC", bundle: nil)
        self.accountCollectionView.register(cellNib, forCellWithReuseIdentifier: AccountCellID)
    }
    
    func gotoImageGallery(isCamera: Bool) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = (isCamera) ? .camera : .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func getImageFromLibrary() {
        let sheet = UIAlertController(title: "Gallery", message: "Select option from below:", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] (action) in
            self!.gotoImageGallery(isCamera: true)
        }))
        sheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { [weak self] (action) in
            self!.gotoImageGallery(isCamera: false)
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(sheet, animated: true, completion: nil)
    }
    
    deinit {
        print("my account vc deinit")
    }
}

extension MyAccountVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titlesStr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCellID, for: indexPath) as! AccountCVC
        cell.infoLbl.text = titlesStr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellHeaderSize(Width: self.view.frame.width, aspectRatio: 300.0/30.0, padding: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 1 && indexPath.row != 0 {
            self.performSegue(withIdentifier: titlesStr[indexPath.row], sender: nil)
        }
    }
    
}

extension MyAccountVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func saveUserData() {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(DrinkUser.iUser) else {return}
        
        UserDefaults.standard.set(data, forKey: UserProfileDefaultsID)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            userImgView.contentMode = .scaleAspectFit
            userImgView.image = pickedImage
            let fileURL = info[UIImagePickerControllerReferenceURL] as! URL
            let data = UIImageJPEGRepresentation(pickedImage, 1)!
            
            Manager.showLoader(text: "Please Wait...", view: self.view)
            Manager.uploadUserImageOnServer(imgData: data, fileURL: fileURL, completionHandler: { [weak self] (url) in
                Manager.hideLoader()
                if let url = url {
                    print(url)
                    DrinkUser.iUser.userImage = url
                    self!.saveUserData()
                    self!.showToast(message: "Profile picture uploaded.")
                } else {
                    self!.showToast(message: "Error Uploading Picture. Please try again...")
                    //err
                }
            })
            
        }
        dismiss(animated: true, completion: nil)
    }
}
