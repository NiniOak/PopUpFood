//
//  ViewController.swift
//  PopupFoodLoginScreen
//
//  Created by Anita Conestoga on 2017-01-27.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class ViewController: UIViewController,UINavigationControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isSignedIn()
        self.navigationController?.isNavigationBarHidden = true
        closeBtn()
    }
    
    @IBOutlet weak var xButton: UIButton!
    @IBAction func closeBtn(_ sender: UIButton) {
        perform(#selector(displayHomePage), with: nil, afterDelay: 0.01)
    }
    
    @IBAction func signInBtn(_ sender: Any) {
        perform(#selector(displaySignInPage), with: nil, afterDelay: 0.01)
    }
    @IBAction func signUpBtn(_ sender: Any) {
        
        perform(#selector(displaySignUpPage), with: nil, afterDelay: 0.01)
    }

    
    func closeBtn() {
        let closeButton = UIImage(named: "xBtn")?.withRenderingMode(.alwaysOriginal)
        xButton.setImage(closeButton, for: .normal)
    }
    
    func displaySignInPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "signInPage") as! SignInViewController
        //self.present(controller, animated: true, completion: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func displaySignUpPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SignUpSocialMedia") as! SignUpViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func displayHomePage() {
        //Strictly for launching page
        let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "newhomePage") as! HomeAfterSignIn
        let navigationController = UINavigationController(rootViewController: controller)
        self.present(navigationController, animated: true, completion: {
            
        })
    }
    
    //Check if user is signed in
    func isSignedIn() {
        FIRAuth.auth()?.addStateDidChangeListener{ auth, user in
            
            if user != nil {
                //Send user to home screen
                self.displayHomePage()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
//    lazy var profilePage: ProfileViewController = {
//        let storyboard = UIStoryboard(name: "ProfilePage", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as! ProfileViewController
//        //handle navigation
//        controller.displayViewCOntroller = self
//        return controller
//    }()
//    

}
