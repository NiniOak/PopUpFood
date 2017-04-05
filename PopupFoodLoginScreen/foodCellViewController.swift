//
//  foodCellViewController.swift
//  PopupFood
//
//  Created by Anita on 2017-03-14.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class foodCellViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var messageButton: UIButton? = nil
    @IBOutlet weak var favouriteButton: UIButton? = nil
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var chefUsername: UILabel!
    
    //Declare current user
    let uid = FIRAuth.auth()?.currentUser?.uid
    //Store Menu in an array
    var menuArray = [Menu]()
    //Instantiate menu class
    
    var menu: Menu? {
        didSet{
            navigationItem.title = menu?.food
            displayFoodItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Display message button image
        messageBtn()
        //Check if fave is in DB
        checkIfFavouriteExists()
// Passing information to screen       
        priceLabel.text = menu?.price
        if let foodImage = menu?.foodImageUrl {
            self.foodImage.sd_setImage(with: URL(string: foodImage))
        }
        foodLabel.text = menu?.food
        cuisineLabel.text = menu?.cuisine
        descriptionLabel.text = menu?.foodDescription
        chefUsername.text = menu?.userName
    }
    
    @IBAction func messageBtn(_ sender: Any) {
        displaySendMessagePage(menu: menu!)
    }
    
    @IBAction func favouriteBtn(_ sender: Any) {

        if !favClicked {
            favouriteBtnClicked()
        }
        else {
            favouriteBtnNotClicked()
             deleteFavourite()
        }
    }
    //Get item details from DB and display to screen
    func displayFoodItems() {
        //Declare menuID to be used to retrieve menu details
        
        guard let menuID = menu?.menuID, let chefName = menu?.userName else {
            return
        }
        //link menu table in DB and get menuID
        let menuReference = FIRDatabase.database().reference().child("menu").child(menuID)
        menuReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //store chef/menu info in "snapshot" and display snapshot
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                self.menuArray.append(self.menu!)
                self.foodLabel.text = dictionary["food"] as? String
                
                self.foodImage.contentMode = .scaleToFill
                if let foodImageUrl = dictionary["foodImageUrl"] as? String {
                    self.foodImage.sd_setImage(with: URL(string: foodImageUrl))
                } else {
                    self.foodImage.image = UIImage(named: "defaultImage")
                }
                self.priceLabel.text = dictionary["price"] as? String
                self.cuisineLabel.text = dictionary["cuisine"] as? String
                self.descriptionLabel.text = dictionary["foodDescription"] as? String
                self.chefUsername.text = (chefName + "'s other food items")
                
            }
        }, withCancel: nil)
    }
    
    //Add Favorites to the Database
    private func registerFavouritesIntoDatabaseWithUserID() {
        
        guard let menuID = menu?.menuID else{
            return
        } //Add user ID to favorites
        //This remembers which user likes what
        let userFaveFood = FIRDatabase.database().reference().child("user-favourites").child(uid!)
        userFaveFood.updateChildValues([menuID: 1])
    }
    
    //Declare pressed variable for favourites button
    var favClicked = false
    //Declare images for favourite button
    let favBtn = UIImage(named: "favorites")?.withRenderingMode(.alwaysOriginal)
    let clickFavBtn = UIImage(named: "full_heart")?.withRenderingMode(.alwaysOriginal)
    
    //Declare method to display Message image for message button
    func messageBtn() {
        if let msgButton = UIImage(named: "message")?.withRenderingMode(.alwaysOriginal) {
            messageButton?.setImage(msgButton, for: .normal)
        }
    }

    
    //Set button to unclick status/colour
    func favouriteBtnNotClicked() {
        favouriteButton?.setImage(favBtn, for: .normal)
        favClicked = false
    }
    //Click favourite button
    func favouriteBtnClicked() {
        favouriteButton?.setImage(clickFavBtn, for: .normal)
        favClicked = true
        registerFavouritesIntoDatabaseWithUserID()
    }


    //BARBARA: Click favourite to remove from DB and favourites list
    func deleteFavourite() {
        guard let menuID = menu?.menuID else {
            return
        }
        FIRDatabase.database().reference().child("user-favourites").child(uid!).child(menuID).removeValue { (error, ref) in
            if error != nil {
                print(error as Any)
            }
        }
    }
    
    //BARBARA: Set red heart button when exists
    func checkIfFavouriteExists() {
        //Get menuID for menu
        guard let menuID = menu?.menuID else {
            return
        }

        let menuRef = FIRDatabase.database().reference().child("user-favourites").child(FIRAuth.auth()!.currentUser!.uid).child(menuID)

        menuRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //Check if menuID exists in user's favourites
            if snapshot.exists() == true {
                self.favouriteBtnClicked()
            } else {
                self.favouriteBtnNotClicked()
            }
        })
    }
    
//    //Set button to unclick status/colour
//    func favouriteBtnNotClicked() {
//        favouriteButton?.setImage(favBtn, for: .normal)
//        favClicked = false
//    }
//    
//    //Click favourite button
//    func favouriteBtnClicked() {
//        favouriteButton?.setImage(clickFavBtn, for: .normal)
//        favClicked = true
//        registerFavouritesIntoDatabaseWithUserID()
//    }
    
    func displaySendMessagePage(menu: Menu) {
        let storyboard = UIStoryboard(name: "Messages", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "sendChefMessage") as! sendMessageCollectionController
        controller.menu = menu
        self.navigationController?.pushViewController(controller, animated: true)
    }

    //ANITA: On click, load message storyboard
    func displaySendMessagePage() {
        let storyboard = UIStoryboard(name: "Messages", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "sendChefMessage") as! sendMessageCollectionController
        controller.menu = menu
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
