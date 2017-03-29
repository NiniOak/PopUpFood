//
//  FavoritesViewController.swift
//  PopupFood
//
//  Created by Barbara Akaeze on 2017-03-07.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FavoritesViewController: UITableViewController {
    
    var foodMenu = [Menu]()
    //Instantiate menu class
    
    var menu : Menu?
    
    let cellId = "favourites"
    
    //Nav Bar
    func showNavBar() {
        navigationItem.title = "Favorites"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavBar()
        fetchUserFavourites()
        
    }
    //FETCH FAVOURITES FOR INDIVIDUAL USER
    func fetchUserFavourites() {
        //Get user table, then userID, in user ID, get the favourites
        /*guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }*/
        //Get username from User Database table
        let reference = FIRDatabase.database().reference().child("user")//.child(uid)
        reference.observe(.childAdded, with: { (snapshot) in
            
            let userID = snapshot.key
            var userName: String? = ""
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                userName = dictionary["name"] as? String
            }
        //Get other info from Menu table in DB
        let ref = FIRDatabase.database().reference().child("user-favourites").child(userID)
        ref.observe(.childAdded, with: { (snapshot) in
            //Get menuID within favourites
            let menuID = snapshot.key
            
            let menuReference = FIRDatabase.database().reference().child("menu").child(menuID)
            
            menuReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                //var userName: String? = ""
                //store chef/menu info in "snapshot" and display snapshot
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let favemenu = Menu()
                    
                    self.foodMenu.append(favemenu)
    
                    //This calls the entire database for menu input by a user
                    favemenu.food = dictionary["food"] as? String
                    favemenu.price = dictionary["price"] as? String
                    favemenu.foodImageUrl = dictionary["foodImageUrl"] as? String
                    favemenu.cuisine = dictionary["cuisine"] as? String
                    favemenu.foodDescription = dictionary["foodDescription"] as? String
                    favemenu.customerID = userID
                    favemenu.menuID = menuID
                    favemenu.userName = userName

                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
      })
    }
    
    //Set up number of cells in Table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return foodMenu.count
    }
    
    //Display images, test and amount in cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DisplayFavouritesTableViewCell

        let menu = foodMenu[indexPath.row]
        cell.foodLabel.text = menu.food
        cell.foodPrice.text = menu.price
        
        if let foodImageUrl = menu.foodImageUrl {
            cell.foodImage.sd_setImage(with: URL(string: foodImageUrl))
        } else {
            cell.foodImage.image = UIImage(named: "test_pizza")
        } 
        return (cell)
    }
    //Select each row to display menu details
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menu = self.foodMenu[indexPath.row]
        showClickedFaveCell(favemenu: menu)
        print("Favourites row clicked")
    }
    //Display the favourites menu page
    func showClickedFaveCell(favemenu: Menu) {
        let storyboard = UIStoryboard(name: "mainFoodCell", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "foodCell") as! foodCellViewController
        //controller.menu = menu
        controller.menu = favemenu
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
