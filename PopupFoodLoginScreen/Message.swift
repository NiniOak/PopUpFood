//
//  Message.swift
//  PopupFood
//
//  Created by Anita on 2017-03-18.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    var fromId: String?
    var toId: String?
    var text: String?
    var timestamp: NSNumber?
    var menuId: String?
    
    func chatPartnerId() -> String? {
//        This line means if fromId = currentUser return toId else return fromId
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
}
