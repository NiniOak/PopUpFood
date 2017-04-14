//
//  BeforeStartSellingViewController.swift
//  PopupFood
//
//  Created by Student on 2017-02-21.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

//OLEK class!!!!!! for Before selling page with CANCEL and ADD button
import UIKit
import Firebase
import FirebaseAuth

class BeforeStartSellingViewController: UITableViewController, UINavigationControllerDelegate {
    
    //Menu array to display food items
    var foodMenu = [Menu]()
    let cellId = "cell"
    
    //instantiate menu class
    var menu : Menu?
    
    override func viewDidLoad() {

        navigationItem.title = "Your Menu"
        fetchUserMenu()
    }
    
    //plus button functionality
    @IBAction func addButton(_ sender: Any) {
            startSelling()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        goBackToLoggedInView()
    }

    //This methid displays navigation Bar
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //FETCH ITEMS BY SINGLE USER ENTRY
    func fetchUserMenu() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("user").child(uid).child("menu")
        ref.observe(.childAdded, with: { (snapshot) in
            
            let menuID = snapshot.key
            let menuReference = FIRDatabase.database().reference().child("menu").child(menuID)
            
            menuReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                //store chef/menu info in "snapshot" and display snapshot
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let menu = Menu()
                    
                    self.foodMenu.append(menu)
                    
                    //This calls the entire database for menu input by a user
                    menu.menuID = menuID
                    menu.food = dictionary["food"] as? String
                    menu.price = dictionary["price"] as? String
                    menu.foodImageUrl = dictionary["foodImageUrl"] as? String
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    
    //Set up number of cells in Table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return foodMenu.count
    }
    
    //Display images, test and amount in cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DisplayMenuTableViewCell
        
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
    
    //Edit Menu in Table View
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let item = foodMenu[indexPath.row]
        
        guard let menuID = item.menuID else {
            return
        }
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            FIRDatabase.database().reference().child("menu").child(menuID).removeValue(completionBlock: { (error, ref) in
                if (error != nil) {
                    print(error as Any)
                } else {
                    print(ref)
                    print("Menu successfully deleted")
                }
            })
        }
        tableView.reloadData()
    }
    
    //Delete Menu
    func deleteMenu() {
        //remove from database
        guard let menuID = menu?.menuID else {
            return
        }
        //check for menuID in database
        FIRDatabase.database().reference().child("menu").child(menuID).removeValue(completionBlock: { (error, ref) in
            if (error != nil) {
                print(error as Any)
            } else {
                print(ref)
                print("Menu successfully deleted")
            }
        })
    }
    //Call viewcontroller and navigation bar for selling page
    func startSelling() {
     let storyboard = UIStoryboard(name: "startSelling", bundle: nil)
     let controller = storyboard.instantiateViewController(withIdentifier: "startSelling") as UIViewController
     self.navigationController?.pushViewController(controller, animated: true)
     }
    
    func goBackToLoggedInView(){
        let storyboard = UIStoryboard(name: "ProfilePage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


