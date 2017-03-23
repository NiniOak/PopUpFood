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
    
//    var foodMenu = [Menu]()
    var message = [Message]()
    var messagesDictionary = [String: Menu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Messages"
        
        observeMenuMessages()
    }
    
    func observeMenuMessages() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let mainMenuRef = FIRDatabase.database().reference().child("user-messages").child(uid)
        mainMenuRef.observe(.childAdded, with: { (snapshot) in
            
            let messageID = snapshot.key
                    
            let messageReference = FIRDatabase.database().reference().child("messages").child(messageID)
            messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                //store chef/menu info in "snapshot" and display snapshot
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let message = Message()
                    
                    self.message.append(message)
                    
                    //This calls the entire database for menu input by a user
                    message.text = dictionary["text"] as? String
                    message.toId = dictionary["toId"] as? String
                    message.fromId = dictionary["fromId"] as? String
                    message.menuId = dictionary["menuId"] as? String
                    message.timestamp = dictionary["timestamp"] as? NSNumber
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        }
                    }
            }, withCancel: nil)
        }, withCancel: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return message.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DisplayMessagesCell
       
        //where "newMessage" stores all values in indexPath.row
        let newMessage = message[indexPath.row]
        
        cell.messageLabel.text = newMessage.text
        
        //The value of each food item is gotten from this code snippet
        //"foodName" is where data for all menu items is
        if let foodName = newMessage.menuId {
            let menuReference = FIRDatabase.database().reference().child("menu").child(foodName)
            menuReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    cell.foodName.text = dictionary["food"] as? String
                    cell.foodPrice.text = dictionary["price"] as? String
                    if let foodImage = dictionary["foodImageUrl"] as? String {
                        cell.foodImage.sd_setImage(with: URL(string: foodImage))
                    }
                }
            }, withCancel: nil)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMessage = message[indexPath.row]
        displaySendMessagePage(message: selectedMessage)
        
    }
    
    func displaySendMessagePage(message: Message) {
        let storyboard = UIStoryboard(name: "Messages", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "sendChefMessage") as! sendMessageCollectionController
        controller.messages = message
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
