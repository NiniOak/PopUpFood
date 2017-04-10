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
    
    var message = [Message]()

    var messagesDictionary = [String: Message]()
    
    var menu: Menu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Messages"
        observeMenuMessages()
    }
    
   // This method stores and displays all values in Messages Node in Firebase
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
                    
                    //This calls the entire database for menu input by a user
                    message.text = dictionary["text"] as? String
                    message.toId = dictionary["toId"] as? String
                    message.fromId = dictionary["fromId"] as? String
                    message.menuId = dictionary["menuId"] as? String
                    message.timestamp = dictionary["timestamp"] as? NSNumber
                    
                    if let menuID = message.menuId {
                        self.messagesDictionary[menuID] = message
                        
                        self.message = Array(self.messagesDictionary.values)
                        
                        //Sort each message into place by order of appearance in time value
                        self.message.sort(by: { (message1, message2) -> Bool in
                            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
                        })
                    }
                    
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
        let newMessage = message[indexPath.row]
        //Go to "DisplayMessageCell" in Views to find controlling method
        cell.message = newMessage
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messages = message[indexPath.row]
        
        //This let us know who sent the message and who the menu belongs to
        //ADD ME LATER!
        guard let menuId = messages.menuId, let chatPartnerId = messages.chatPartnerId() else {
            return
        }
        let ref = FIRDatabase.database().reference().child("menu").child(menuId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let menu = Menu()
                menu.food = dictionary["food"] as? String
                menu.customerID = chatPartnerId
                menu.menuID = menuId
                self.displaySendMessagePage(menu: menu)
            }
        }, withCancel: nil)
    }
    
    func displaySendMessagePage(menu: Menu) {
        let storyboard = UIStoryboard(name: "Messages", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "sendChefMessage") as! sendMessageCollectionController
        controller.menu = menu
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
