//
//  sendMessageCollectionController.swift
//  PopupFood
//
//  Created by Anita on 2017-03-17.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

private let reuseIdentifier = "Cell"

class sendMessageCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    @IBOutlet weak var messageTextField: UITextField!
    
    var menu: Menu? {
        didSet{
            navigationItem.title = menu?.food
            retrieveMessagesFromDatabase()
        }
    }
    var messages: Message? {
        didSet{
        }
    }
    
    var sentMessages = [Message]()
    
    @IBAction func sendButton(_ sender: Any) {
        handleSend()
        clearTextFieldInput()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextField.delegate = self
        // Register cell classes
        self.collectionView!.register(chatMessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        retrieveMessagesFromDatabase()
    }
    
    //This method retrieves messages and food image and name from the database
    func retrieveMessagesFromDatabase() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        //Call the user-messages node to get the snapshot key where all messages are stored in order to display messages
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            
            //This call displays all text in messages but is specified by user to text message 
            //rather than all messages in the database
            let ref = FIRDatabase.database().reference().child("messages").child(messageId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                //print(snapshot)
                
//                guard let dictionary = snapshot.value as? [String: AnyObject] else {
//                return
//                }
//                    let messages = Message()
//                    
//                    messages.text = dictionary["text"] as? String
//                
//                if messages.chatPartnerId() == self.menu?.customerID {
//                    self.sentMessages.append(messages)
//                    DispatchQueue.main.async {
//                        self.collectionView?.reloadData()
//                    }
//                }
            }, withCancel: nil)
        }, withCancel: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sentMessages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! chatMessageCell
        
        let messages = sentMessages[indexPath.item]
            cell.messageLabel.text = messages.text
        
        return cell
    }
    
    func handleSend() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid, let sendMesageTextField = messageTextField.text, let chefId = menu?.customerID, let menuID = menu?.menuID else {
            return
        }
        
        //Create Messages table to store all information related to message sent
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = chefId
        let fromId = uid
        let timeStamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let values = ["text": sendMesageTextField, "toId": toId, "fromId": fromId, "timestamp": timeStamp, "menuId": menuID] as [String : Any]
        
        //Update dB with content entered in values field above
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
        }
        
        //Created a user messages table with
        let messageId = childRef.key
        
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId)
        userMessagesRef.updateChildValues([messageId: 1])
        
        let receipentMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toId)
        receipentMessagesRef.updateChildValues([messageId:1])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        clearTextFieldInput()
        return true
    }
    
    //Clear textbox after sending message
    func clearTextFieldInput() {
        messageTextField.text = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        self.view.window?.endEditing(true)
    }
    
}
