//
//  sendMessageCollectionController.swift
//  PopupFood
//
//  Created by Anita on 2017-03-17.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit

class sendMessageCollectionController: UICollectionViewController {
    
    var cellId = "cell"
    
    let sentMessages = ["We nearly had some drama at the end and could have gone into extra time, but United hold on and progress to the quarter-finals of the Europa League.", "Sometimes fans just demand too much from managers. Defensive Mourinho is taking us to the last eight of the Europa League."]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(chatMessageCell.self, forCellWithReuseIdentifier: cellId)

    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return sentMessages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! chatMessageCell
        
        let messages = sentMessages[indexPath.item]
        //cell.messageLabel.text = messages.text
    
        return cell
    }
}
