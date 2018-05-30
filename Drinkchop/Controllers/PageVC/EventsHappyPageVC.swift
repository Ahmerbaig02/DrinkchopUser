////
//  EventsHappyPageVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class EventsHappyPageVC: UIViewController {
    
    @IBOutlet var menuBar: UICollectionView!
    
    var pageVC: UIPageViewController!
    
    let horizontalBarView = UIView()
    var horizontalBarViewLeftAnchor:NSLayoutConstraint!
    
    var controllers:[UIViewController] = []
    var TitleText:[String] = ["Events","Happy Hours"]
    
    var lat: Double!
    var lng: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllers()
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        menuBar.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .left)
        
        setupPageController()
        createHorizontalSelector()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setControllersData()
    }
    
    func setupPageController() {
        
        self.pageVC = self.storyboard?.instantiateViewController(withIdentifier: "mainPageController") as! UIPageViewController
        
        pageVC.delegate = self
        pageVC.dataSource = self
        
        pageVC.setViewControllers([getViewController(index: 0)!], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        self.addChildViewController(self.pageVC)
        self.view.addSubview(self.pageVC.view)
        self.pageVC.didMove(toParentViewController: self)
        
        pageVC.view.anchor(self.menuBar.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func createHorizontalSelector() {
        
        horizontalBarView.backgroundColor = .white
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(horizontalBarView)
        
        horizontalBarViewLeftAnchor = horizontalBarView.leftAnchor.constraint(equalTo: self.menuBar.leftAnchor)
        horizontalBarViewLeftAnchor.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.menuBar.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.menuBar.widthAnchor, multiplier: 1/CGFloat(TitleText.count)).isActive = true
        
        horizontalBarView.heightAnchor.constraint(equalToConstant: 5.0).isActive = true
        
        menuBar.bringSubview(toFront: horizontalBarView)
    }
    
    func setupControllers() {
        let eventVC = storyboard?.instantiateViewController(withIdentifier: "EventsVC") as! EventsVC
        eventVC.view.tag = 0
        let happyHoursVC = storyboard?.instantiateViewController(withIdentifier: "EventsVC") as! EventsVC
        happyHoursVC.view.tag = 1
        self.controllers = [eventVC,happyHoursVC]
    }
    
    func setControllersData() {
        let eventVC = self.controllers[0] as! EventsVC
        eventVC.lat = self.lat
        eventVC.lng = self.lng
        let happyHoursVC = self.controllers[0] as! EventsVC
        happyHoursVC.lat = self.lat
        happyHoursVC.lng = self.lng
    }
    
    func getViewController(index:Int) -> UIViewController?  {
        
        if index == NSNotFound || index < 0 || index >= TitleText.count {
            return nil
        }
        return controllers[index]
    }
    
    deinit {
        print("events happy page vc deinit")
    }
}


extension EventsHappyPageVC: UIPageViewControllerDataSource,UIPageViewControllerDelegate  {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var Index = (viewController).view.tag
        
        Index = Index - 1
        
        return getViewController(index: Index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var Index = (viewController).view.tag
        
        Index = Index + 1
        
        return getViewController(index: Index)
    }
    
    func moveToView(controller:UIViewController) {
        
        let newSelectedIndex = controller.view.tag
        let SelectedIndexPath = IndexPath(item: Int(newSelectedIndex), section: 0)
        menuBar.selectItem(at: SelectedIndexPath, animated: true, scrollPosition: .left )
        
        self.horizontalBarViewLeftAnchor.constant = CGFloat(newSelectedIndex) * horizontalBarView.frame.width
        self.view.layoutIfNeeded()
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed == true {
            moveToView(controller: (pageVC.viewControllers?.first)!)
        }
    }
}

extension EventsHappyPageVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK - Collection View Data Source functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return TitleText.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"menu", for: indexPath) as! MenuCell
        
        cell.TitleLabel.text = TitleText[indexPath.row]
        return cell
    }
    
    // MARK - Collection View Delegate Flowlayout functions
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (view.frame.size.width / CGFloat(TitleText.count))
        let cellHeight = CGFloat(52)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    
    // MARK - Collection View Delegate functions
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == menuBar {
            
            let x = CGFloat(indexPath.item) * (view.frame.width / CGFloat(TitleText.count))
            self.horizontalBarViewLeftAnchor.constant = x
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                
                let selectedController = self.getViewController(index: indexPath.row)!
                self.pageVC.setViewControllers([selectedController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
                
                self.moveToView(controller: selectedController)
                
            }, completion: nil)
        }
    }
}





// MARK: - Menu Cell

class MenuCell : UICollectionViewCell {
    
    @IBOutlet var TitleLabel: UILabel!
    
    override var isSelected: Bool {
        didSet{
            
            TitleLabel.textColor = isSelected ? .white : UIColor(white: 1.0, alpha: 0.8)
            TitleLabel.font = isSelected ? .systemFont(ofSize: 13.0, weight: UIFont.Weight.heavy) : .boldSystemFont(ofSize: 12.0)
        }
    }
    
    override var isHighlighted: Bool {
        didSet{
            
            TitleLabel.textColor = isSelected ? .white : UIColor(white: 1.0, alpha: 0.8)
            TitleLabel.font = isSelected ? .systemFont(ofSize: 13.0, weight: UIFont.Weight.heavy) : .boldSystemFont(ofSize: 12.0)
        }
    }
}
