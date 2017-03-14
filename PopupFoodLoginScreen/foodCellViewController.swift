//
//  foodCellViewController.swift
//  PopupFood
//
//  Created by Anita on 2017-03-14.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit

class foodCellViewController: UIViewController {

    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var foodImage: UIImageView!
    //Declare pressed variable for favourites button
    var favClicked = false
    //Declare images for favourite button
    let favBtn = UIImage(named: "favorites")?.withRenderingMode(.alwaysOriginal)
    let clickFavBtn = UIImage(named: "full_heart")?.withRenderingMode(.alwaysOriginal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Display message button image
        messageBtn()
        //Display favourite buton image
        favouriteBtnNotClicked()
    }
    
    //Declare method to display Message image for message button
    func messageBtn() {
        let msgButton = UIImage(named: "Messages")?.withRenderingMode(.alwaysOriginal)
        messageButton.setImage(msgButton, for: .normal)
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
        favouriteButton.setImage(favBtn, for: .normal)
        favClicked = false
    }
    
    func favouriteBtnClicked() {
        favouriteButton.setImage(clickFavBtn, for: .normal)
        favClicked = true
        
    }
}
