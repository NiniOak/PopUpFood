//
//  messageLogViewController.swift
//  PopupFood
//
//  Created by Anita on 2017-03-17.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase

class messageLogViewController: UITableViewController {
    
    let cellId = "cell"
    
    var foodMenu = [Menu]()
    var messagesDictionary = [String: Menu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Messages"
        
        observeMenuMessages()
    }
    
    func observeMenuMessages() {
        var foodImage: String? = ""
        var foodName: String? = ""
        var foodPrice: String? = ""
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let mainMenuRef = FIRDatabase.database().reference().child("menu")
        mainMenuRef.observe(.childAdded, with: { (snapshot) in
            
            let menuID = snapshot.key
            if let dictionary = snapshot.value as? [String: AnyObject] {
                foodImage = dictionary["foodImageUrl"] as? String
                foodName = dictionary["food"] as? String
                foodPrice = dictionary["price"] as? String
            }

            let menuRef = FIRDatabase.database().reference().child("menu").child(menuID).child("messages").child(uid)
            menuRef.observe(.childAdded, with: { (snapshot) in
                let messageID = snapshot.key
                print(snapshot)
                    
            let messageReference = FIRDatabase.database().reference().child("messages").child(messageID)
            messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                //store chef/menu info in "snapshot" and display snapshot
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let menu = Menu()
                    
                    self.foodMenu.append(menu)
                    
                    //This calls the entire database for menu input by a user
                    menu.food = foodName
                    menu.price = foodPrice
                    menu.foodImageUrl = foodImage
                    menu.text = dictionary["text"] as? String
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        }
                    }
                print(snapshot)
                }, withCancel: nil)
            }, withCancel: nil)
        }, withCancel: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return foodMenu.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DisplayMessagesCell
        
        let menu = foodMenu[indexPath.row]
        cell.foodName.text = menu.food
        cell.foodPrice.text = menu.price
        cell.messageLabel.text = menu.text
        if let foodImageUrl = menu.foodImageUrl {
            cell.foodImage.sd_setImage(with: URL(string: foodImageUrl))
        } else {
            cell.foodImage.image = UIImage(named: "test_pizza")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menu = foodMenu[indexPath.row]
        displaySendMessagePage(menu: menu)
        
    }
    
    func displaySendMessagePage(menu: Menu) {
        let storyboard = UIStoryboard(name: "Messages", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "sendChefMessage") as! sendMessageCollectionController
        controller.menu = menu
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
