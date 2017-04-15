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
    
    @IBOutlet weak var xButton: UIButton!
    @IBAction func closeBtn(_ sender: UIButton) {
        
        displayHomePage()
    }
    
    @IBAction func signInBtn(_ sender: Any) {
        displaySignInPage()
    }
    @IBAction func signUpBtn(_ sender: Any) {
        displaySignUpPage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        closeBtn()
    }
    
    func closeBtn() {
        let closeButton = UIImage(named: "xBtn")?.withRenderingMode(.alwaysOriginal)
        xButton.setImage(closeButton, for: .normal)
    }
    
    func displayHomePage() {
        let storyboard = UIStoryboard(name: "defaultTimeline", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "initialController") as! defaultPageViewController
        self.navigationController?.pushViewController(controller, animated: true)
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
    func returnHomePage() {
        let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "newhomePage") as! HomeAfterSignIn
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //If user is signed in, display homepage
        FIRAuth.auth()?.addStateDidChangeListener{ auth, user in
            
            if user != nil {
                self.returnHomePage()
            }
            else{
                self.navigationController?.isNavigationBarHidden = true
                
            }
        }
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
