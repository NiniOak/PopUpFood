//
//  HomeAfterSignIn.swift
//  PopupFood
//
//  Created by Student on 2017-02-09.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeAfterSignIn: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var cellId = "cellID"
    var foodMenu = [Menu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(foodCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)//for menu bar
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50
            , 0, 0, 0)//for menu bar
        
        setupMenuBar()//for menu bar
        navigationBar() //for navigationBar
        setupNavBarButtons() //add items to NavBar
        fetchMenuCollection()
        //fetchMenu()
    }
    
    func navigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        
            //Set up home button for profile page
            let button = UIButton.init(type: .custom)
            button.setImage(UIImage.init(named: "logo2"), for: UIControlState.normal)
            button.frame = CGRect.init(x: 0, y: 0, width: 120, height: 50)
            let barButton = UIBarButtonItem.init(customView: button)
            self.navigationItem.leftBarButtonItem = barButton
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
        
        //Check if user is logged in
        FIRAuth.auth()?.addStateDidChangeListener{ auth, user in
            
            //If user is logged in, show profile storyboard
            if user != nil {
                
                //If user is logged in, show profile storyboard
                self.displayProfilePage()
            }
            else{
                
                //If user is NOT logged in, show signup storyboard
                self.displaySignUpPage()
                
            }
        }
    }

    //for menu bar
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        //handle navigation
        mb.homeController = self
        return mb
    }()
    
    //for menu bar
    private func setupMenuBar(){
        //Scroll menu bar away when scrolling
        navigationController?.hidesBarsOnSwipe = true
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]|", views: menuBar)
        
        //lock menu bar to top of page
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }
    //end of for menu bar
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
    }

    //Fetch entire Menu by user who created the menu
    //This enables adding user info such as profile image and data not available in Menu Node
    func fetchMenuCollection() {
        let ref = FIRDatabase.database().reference().child("user")
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userID = snapshot.key
            var profileImageUrl: String? = ""
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                profileImageUrl = dictionary["photo"] as? String
            }
            
            //Refer to sub menu after identifying all child keys. User table -> Child key for every table -> All User data
            let UserMenuReference = FIRDatabase.database().reference().child("user").child(userID).child("menu")
            
            UserMenuReference.observe(.childAdded, with: { (snapshot) in
                let menuID = snapshot.key
            
            let menuReference = FIRDatabase.database().reference().child("menu").child(menuID)
                menuReference.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    //store chef/menu info in "snapshot" and display snapshot
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        
                        let menu = Menu()
                        
                        self.foodMenu.append(menu)
                        
                        //This calls the entire database for menu input by a user
                        menu.food = dictionary["food"] as? String
                        menu.price = dictionary["price"] as? String
                        menu.foodImageUrl = dictionary["foodImageUrl"] as? String
                        menu.profileImageUrl = profileImageUrl
                        
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                }, withCancel: nil)
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    //Fetch every item in the database without specific user id
    //CURRENTLY NOT IN USE ======
    func fetchMenu() {
        
        FIRDatabase.database().reference().child("menu").observe(.childAdded, with: { (snapshot) in
         
         //Add firebase
         //store chef/menu info in "snapshot" and display snapshot
         if let dictionary = snapshot.value as? [String: AnyObject] {
         
         let menu = Menu()
         
         self.foodMenu.append(menu)
         
         //This calls the entire database for menu input by a user
         menu.food = dictionary["food"] as? String
         menu.price = dictionary["price"] as? String
         menu.foodImageUrl = dictionary["foodImageUrl"] as? String
         
         
         //self.foodMenu.append(menu)
         DispatchQueue.main.async {
         self.collectionView?.reloadData()
         }
         
         }
         
         }, withCancel: nil)
    } //===========
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodMenu.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! foodCell
        
        let menu = foodMenu[indexPath.row]
        
        cell.titleLabel.text = menu.food
        cell.subtitleTextView.text = menu.price
        
        //Display food image
        if let foodImageUrl = menu.foodImageUrl {
            let url = URL(string: foodImageUrl)
            cell.thumbnailImageView.sd_setImage(with: url)
        } else {
            cell.thumbnailImageView.image = UIImage(named: "test_pizza")
        }
        
        //Display user profile image in menu cell on home page
        if let profileImageUrl = menu.profileImageUrl {
            let url = URL(string: profileImageUrl)
            cell.userProfileImage.sd_setImage(with: url)
        } else {
            cell.userProfileImage.image = UIImage(named: "defaultImage")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 16 - 16) * 9 / 16
        return CGSize(width: view.frame.width, height: height + 16 + 68)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //BARBARA: HANDLE ALL click functions for Food Cells
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Food Cell Tapped!! Yay")
        //Change page linked to individual storyboard designed with display
        //and viewController
        displayFavorites() //temporary
    }
    
    
    func displayProfilePage() {
        let storyboard = UIStoryboard(name: "ProfilePage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func displaySignUpPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SignUpSocialMedia") as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //BARBARA: Handle ALL menu clicks navigation
    //onClick Favorites icon, load fave view storyboard
    func displayFavorites() {
        let storyboard = UIStoryboard(name: "mainFoodCell", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "foodCell") as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)

    }
    
    
}//end of HomeAfterSignIn class
