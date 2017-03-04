//
//  PresentViewController.swift
//  PopupFood
//
//  Created by Anita on 2017-03-03.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit

class PresentViewController: UIViewController {

    func returnHomePage() {
        
        let signInViewCOntroller = SignInViewController()
        let nextViewController: UINavigationController = UINavigationController(rootViewController: signInViewCOntroller)
        self.present(nextViewController, animated: true, completion: nil)

    }


}
