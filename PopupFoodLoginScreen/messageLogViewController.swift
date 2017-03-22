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
    
    var menu: Menu? {
        didSet{
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Messages"
        
        observeMenuMessages()
    }
    
    func observeMenuMessages() {
        var messageText: String? = ""
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
//        let ref = FIRDatabase.database().reference().child("user").child(uid).child("messages")
//        ref.observe(.childAdded, with: { (snapshot) in
//            let menuID = snapshot.key
        
        let ref = FIRDatabase.database().reference().child("user").child(uid).child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            let menuID = snapshot.key
            
            let menuRef = FIRDatabase.database().reference().child("user").child(uid).child("messages").child(menuID)
            menuRef.observe(.childAdded, with: { (snapshot) in
                let messageID = snapshot.key
                
                let messageRef = FIRDatabase.database().reference().child("messages").child(messageID)
                messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        messageText = dictionary["text"] as? String
                    }
                    
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
                    menu.text = messageText
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                        }
//                      }, withCancel: nil)
                    }, withCancel: nil)
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
