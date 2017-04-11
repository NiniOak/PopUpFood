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



class sendMessageCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    let cellId = "cell"
    
    var menu: Menu? {
        didSet{
            navigationItem.title = menu?.food
            retrieveMessagesFromDatabase()
        }
    }

    var sentMessages = [Message]()
    
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
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                let messages = Message()
                
                messages.text = dictionary["text"] as? String
                messages.fromId = dictionary["fromId"] as? String
                messages.menuId = dictionary["menuId"] as? String
                messages.toId = dictionary["toId"] as? String
                messages.timestamp = dictionary["timestamp"] as? NSNumber
                
                if messages.menuId == self.menu?.menuID {
                    self.sentMessages.append(messages)
                //this is called becausw we are in a background thread. Async is used to call back to main thread
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                    }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Write message here..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        // Register cell classes
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        setupInputComponent()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sentMessages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = sentMessages[indexPath.item]
        cell.textView.text = message.text
        
        setupCell(cell: cell, message: message)
        return cell
    }
    
    //This function controls the chat bubble color
    private func setupCell(cell: ChatMessageCell, message: Message) {
        
        //Get user profile Image to be used in chat
        guard let userID = self.menu?.customerID else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("user").child(userID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let profileImageUrl = dictionary["photo"] as? String {
                    cell.profileImageView.sd_setImage(with: URL(string: profileImageUrl))
                }
            }
        }, withCancel: nil)
        
        if message.fromId == FIRAuth.auth()?.currentUser?.uid {
            //outgoing Blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
            //Incoming gray
            cell.bubbleView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240, alpha: 1)
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        //This get's the text width
        cell.bubbleWidthAnchor?.constant = estimatedFrameForText(text: message.text!).width + 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        //get estimated height
        if let text = sentMessages[indexPath.item].text {
            height = estimatedFrameForText(text: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    //Design the UI for the Message Collection View
    func setupInputComponent() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        //addConstrainsts for view
        //x,y,width,height
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //Create send button
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: UIControlState())
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        //x,y,width,height
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
    
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.black
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLine)
        
        //x,y,w,h
        separatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func handleSend() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid, let sendMesageTextField = inputTextField.text, let chefId = menu?.customerID, let menuID = menu?.menuID else {
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
        //Clear textfield after messages have been sent
        self.clearTextFieldInput()
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
        return true
    }
    
    //Clear textbox after sending message
    func clearTextFieldInput() {
        inputTextField.text = ""
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.view.window?.endEditing(true)
    }
    
}
