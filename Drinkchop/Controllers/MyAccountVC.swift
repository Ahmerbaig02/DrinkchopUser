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
    
    var titlesStr:[String] = ["John Doe","johndoe@gmail.com","My Cards","Password","Allergy","Budget","Cover"]
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        registerCell()
        
        self.userImgView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.getImageFromLibrary))
        self.userImgView.addGestureRecognizer(tapGesture)
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
    
    @objc func getImageFromLibrary() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            userImgView.contentMode = .scaleAspectFit
            userImgView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
