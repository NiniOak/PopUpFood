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
    
    
    var menuArray = [Menu]()
    
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
        favouriteBtnNotClicked()
    }
    
    func displayFoodItems() {
        //Declare menuID to be used to retrieve menu details
        guard let menuID = menu?.menuID, let chefName = menu?.userName else {
            return
        }
        
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
    
    //Declare pressed variable for favourites button
    var favClicked = false
    //Declare images for favourite button
    let favBtn = UIImage(named: "favorites")?.withRenderingMode(.alwaysOriginal)
    let clickFavBtn = UIImage(named: "full_heart")?.withRenderingMode(.alwaysOriginal)

    
    func showNavBar() {
        
    }
    
    //Declare method to display Message image for message button
    func messageBtn() {
        if let msgButton = UIImage(named: "Messages")?.withRenderingMode(.alwaysOriginal) {
            messageButton?.setImage(msgButton, for: .normal)
            messageButton?.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        }
    }

    @IBAction func messageBtn(_ sender: Any) {
    }
    
    @IBAction func favouriteBtn(_ sender: UIButton) {
        
        if !favClicked {
            favouriteBtnClicked()
        }
        else {
            favouriteBtnNotClicked()
        }
    }
    
    func favouriteBtnNotClicked() {
        favouriteButton?.setImage(favBtn, for: .normal)
        favouriteButton?.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        favClicked = false
    }
    
    func favouriteBtnClicked() {
        favouriteButton?.setImage(clickFavBtn, for: .normal)
        favouriteButton?.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        favClicked = true
        
    }
}
