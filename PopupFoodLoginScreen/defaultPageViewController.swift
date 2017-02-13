//
//  defaultPageViewController.swift
//  PopupFood
//
//  Created by Anita on 2017-02-07.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit

//Iteration 1
class defaultPageViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DEFAULT PAGE CODE
        navigationItem.title = "Popup Food" //align left
        navigationController?.navigationBar.isTranslucent = false
        
        //SET TITLE TEXT FOR NAVIGATION BAR
        let titleLabel = UILabel(frame: CGRect(x:0, y:0, width:view.frame.width - 32, height:view.frame.height))
        titleLabel.text = "Popup Food"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 19)
        navigationItem.titleView = titleLabel
        
        collectionView?.backgroundColor = UIColor.white
        //Register cellID
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "cellID")
        
        //SET UP NAV BAR BUTTONS
        setupNavBarButtons()
        
    }
    
    //SET UP NAV BAR FUNC
    func setupNavBarButtons() {
        let searchImage = UIImage(named: "searchIcon")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let profileIconBtn = UIBarButtonItem(image: UIImage(named: "profileIcon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showProfile))
        navigationItem.rightBarButtonItems = [profileIconBtn, searchBarButtonItem]
    }
    
    //Method to handle search button in future
    func handleSearch() {
        print(123)
    }
    
    //Pass to show Profile class or method
    func showProfile() {
        let storyboard = UIStoryboard(name: "ProfilePage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
    }
    
    //DEFAULT PAGE CODE
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 16 - 16) * 9 / 16
        return CGSize(width:view.frame.width, height:height + 16 + 68)
    }
    
    //Edit lineSpacing between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //Default Method created with the Class
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}





