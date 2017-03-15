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

class foodCellViewController: UIViewController {
    
    //create Menu reference
    var menu: Menu? {
        didSet{
            navigationItem.title = menu?.food
        }
    }

    @IBOutlet weak var messageButton: UIButton? = nil
    @IBOutlet weak var favouriteButton: UIButton? = nil
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    
    //Declare pressed variable for favourites button
    var favClicked = false
    //Declare images for favourite button
    let favBtn = UIImage(named: "favorites")?.withRenderingMode(.alwaysOriginal)
    let clickFavBtn = UIImage(named: "full_heart")?.withRenderingMode(.alwaysOriginal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Display message button image
        messageBtn()
        favouriteBtnNotClicked()
    }
    
    //Declare method to display Message image for message button
    func messageBtn() {
        if let msgButton = UIImage(named: "Messages")?.withRenderingMode(.alwaysOriginal) {
            messageButton?.setImage(msgButton, for: .normal)
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
        favClicked = false
    }
    
    func favouriteBtnClicked() {
        favouriteButton?.setImage(clickFavBtn, for: .normal)
        favClicked = true
        
    }
    
    func showClickedFoodCell() {
        let storyboard = UIStoryboard(name: "mainFoodCell", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "foodCell") as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func displayAllFavorites() {
        let storyboard = UIStoryboard(name: "favoritesPage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FavoritesPage") as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func returnHomePage() {
        
        let signInViewCOntroller = SignInViewController()
        let nextViewController: UINavigationController = UINavigationController(rootViewController: signInViewCOntroller)
        self.present(nextViewController, animated: true, completion: nil)
    }

    var homeController: HomeAfterSignIn?
    
    lazy var homeSignInCtrl: HomeAfterSignIn = {
        let homeSignIn = HomeAfterSignIn()
        //handle navigation
        homeSignIn.foodCellVC = self
        return homeSignIn
    }()
}
