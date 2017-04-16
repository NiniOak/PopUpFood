//
//  chatMessageCell.swift
//  PopupFood
//
//  Created by Anita on 2017-03-17.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Let this be sample messages"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
//        tv.textColor = .white
        return tv
    }()
    
    let timeTextView: UITextView = {
        let timeTv = UITextView()
        timeTv.text = "Let this be sample time"
        timeTv.font = UIFont.systemFont(ofSize: 10)
        timeTv.translatesAutoresizingMaskIntoConstraints = false
        timeTv.textColor = .gray
        timeTv.backgroundColor = UIColor.clear
        timeTv.contentInset = UIEdgeInsetsMake(-9.0, 0.0, 0, 0.0)
        return timeTv
    }()
    
    static let blueColor = UIColor.rgb(red: 0, green: 137, blue: 249, alpha: 1)
    
    //This code creates the bubble where the chat messages will be displayed in
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 191, blue: 255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    var timeTextViewWidthAnchor: NSLayoutConstraint?
    var timeTextViewRightAnchor: NSLayoutConstraint?
    var timeTextViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        addSubview(timeTextView)
        
        //Profileview COnstraints
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        //BubbleView right and left anchor
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        
        //BubbleView COnstraints
        //Constants serves as padding to push text left or right
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //TIMETEXTVIEW CONSTRAINTS
        //TimeTextView RIGHT AND LEFT Constraints
        timeTextViewRightAnchor = timeTextView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor)
        timeTextViewRightAnchor?.isActive = true
        timeTextViewLeftAnchor = timeTextView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        timeTextViewLeftAnchor?.isActive = true
        
        //TimeTextView TOP AND BOTTOM Constraints
        timeTextView.topAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
//        timeTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        //TimeTextView WIDTH AND HEIGHT Constraints
        timeTextViewWidthAnchor = timeTextView.widthAnchor.constraint(equalToConstant: 110)
        timeTextViewWidthAnchor?.isActive = true
        timeTextView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        //textView Constraints
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
