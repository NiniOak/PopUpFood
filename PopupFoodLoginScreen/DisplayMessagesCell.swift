//
//  DisplayMessagesCell.swift
//  PopupFood
//
//  Created by Anita on 2017-03-21.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase

class DisplayMessagesCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            
            observeMessagesCell()
            
            messageLabel.text = message?.text
            //convert timestamp to date
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                timeLabel.text = dateFormatter.timeSince(from: timestampDate as NSDate, numericDates: true)
            }
            
        }
    }

    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func observeMessagesCell() {
        //The value of each food item is gotten from this code snippet
        //"foodName" is where data for all menu items is
        
        
        if let menuId = message?.menuId , let userId = message?.chatPartnerId() {
            let menuReference = FIRDatabase.database().reference().child("menu").child(menuId)
            menuReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    if let foodName = dictionary["food"] as? String {
                        self.foodName.text = foodName
                        //Assigning content to message class to be used in MessageLogClass to group data
                    }
                    if let foodPrice = dictionary["price"] as? String {
                        self.foodPrice.text = foodPrice
                    }
//                    self.foodPrice.text = userName
                    
                    if let foodImage = dictionary["foodImageUrl"] as? String {
                        self.foodImage.sd_setImage(with: URL(string: foodImage))
                        //        self.message?.foodImageUrl = messagedFoodImage
                    }
                }
            }, withCancel: nil)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
