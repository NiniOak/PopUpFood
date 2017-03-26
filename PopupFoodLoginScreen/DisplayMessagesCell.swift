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
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timestampDate as Date)
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
        if let foodName = message?.menuId {
            
            let menuReference = FIRDatabase.database().reference().child("menu").child(foodName)
            menuReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    if let foodName = dictionary["food"] as? String {
                        self.foodName.text = foodName
                        //Assigning content to message class to be used in MessageLogClass to group data
                        //                            self.message?.foodName = messagedFoodName
                    }
                    if let foodPrice = dictionary["price"] as? String {
                        self.foodPrice.text = foodPrice
                        //                            self.message?.foodPrice = messagedFoodPrice
                    }
                    if let foodImage = dictionary["foodImageUrl"] as? String {
                        self.foodImage.sd_setImage(with: URL(string: foodImage))
                        //                            self.message?.foodImageUrl = messagedFoodImage
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
