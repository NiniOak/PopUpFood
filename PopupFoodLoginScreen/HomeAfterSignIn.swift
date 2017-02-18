//
//  HomeAfterSignIn.swift
//  PopupFood
//
//  Created by Student on 2017-02-09.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit

class HomeAfterSignIn: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(foodCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView?.contentInset = UIEdgeInsetsMake(100, 0, 0, 0)//for menu bar
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(100, 0, 0, 0)//for menu bar
        
        setupMenuBar()//for menu bar
        navigationBar() //for navigationBar
        setupNavBarButtons() //add items to NavBar
    }
    
    func navigationBar() {
        
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        //repeated?
        navigationItem.titleView = titleLabel
        
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
        
    }
    
    //SET UP NAV BAR FUNC
    func setupNavBarButtons() {
        let searchImage = UIImage(named: "searchIcon")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let profileIconBtn = UIBarButtonItem(image: UIImage(named: "profileIcon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showProfile))
        
        navigationItem.rightBarButtonItems = [profileIconBtn, searchBarButtonItem]
        
    }
    
    func handleSearch() {
        print("Will add search functionality in the future")
    }
    
    //Pass to show Profile class or method
    func showProfile() {
        print("Profile will be displayed")
    }

    
    //for menu bar
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    //for menu bar
    private func setupMenuBar(){
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]|", views: menuBar)
    }
    //end of for menu bar
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 16 - 16) * 9 / 16
        return CGSize(width: view.frame.width, height: height + 16 + 68)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}//end of HomeAfterSignIn class
