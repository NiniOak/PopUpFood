//
//  DisplayMessagesCell.swift
//  PopupFood
//
//  Created by Anita on 2017-03-21.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit

class DisplayMessagesCell: UITableViewCell {

    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
