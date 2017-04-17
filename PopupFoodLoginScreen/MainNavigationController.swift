//
//  MainNavigationController.swift
//  PopupFood
//
//  Created by Anita on 2017-04-14.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        isUserSignedIn() //Declare start up
        
//        
//        // Check IF User is Logged In
//        if IsLoggedIn() {
//            let homeController = TestHomeController()
//            viewControllers = [homeController]
//        } else {
//            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
//        }
}
    
    func isUserSignedIn() {
        if FIRAuth.auth()?.currentUser?.uid != nil {
            
            let homeController = TestHomeController()
            viewControllers = [homeController]
            print("HOMEPAGE")
        } else {
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
            print("SIGNIN PAGE")
        }
    }

//    fileprivate func IsLoggedIn() -> Bool {
//        if FIRAuth.auth()?.currentUser?.uid != nil {
//            
//            print("TRUEFALSE")
//            return true //return HOMEPAGE
//        }
//        print("FALSE")
//        return false // returns SIGNIN/SIGNUP PAGE
//
//    }

    func showLoginController() {
        //Strictly for launching page
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "landingVC") as! ViewController
        let navigationController = UINavigationController(rootViewController: controller)
        self.present(navigationController, animated: true, completion: {
            
        })
    }
    
    class TestHomeController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            
            perform(#selector(showHomeController), with: nil, afterDelay: 0.01)
//            view.backgroundColor = .yellow
        }
        
        func showHomeController() {
            //Strictly for launching page
            let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "newhomePage") as! HomeAfterSignIn
            let navigationController = UINavigationController(rootViewController: controller)
            self.present(navigationController, animated: true, completion: {
                
            })
        }
    }

}
