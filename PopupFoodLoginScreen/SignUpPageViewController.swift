//
//  SignUpPageViewController.swift
//  PopupFood
//
//  Created by Anita Conestoga on 2017-02-01.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpPageViewController: UIViewController, UINavigationControllerDelegate {

    // Fields Declaration
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var RepasswordTextField: UITextField!

    
    //Impelmenation for Sign Up button
    @IBAction func signUpBtn(_ sender: UIButton) {
        handleRegister()
        goToHomePage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Sign Up"
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func handleRegister() {
        
        guard let email = emailTextField.text, let username = usernameTextField.text, let password = passwordTextField.text else {
            print ("Form filled inappropriately")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error ) in
            
            if error != nil {
                print(error as Any)
                return
            }
            else {
                print("User Created")
            }
            
            //Push entered information to Firebase Database
            //Guard statment gives us access to UID similar to email, Username and Password above.
            guard let uid = user?.uid else {
                return
            }
            //Collect entered User information and input in Database
            let ref = FIRDatabase.database().reference().child("user").child(uid)
            let values = ["name": username, "email": email, "password": password]
            ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print(err as Any)
                    return
                }
                print ("User Data saved to Firebase Database!")
            })
        })
    }
    
    func goToHomePage() {
        let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "newhomePage") as! HomeAfterSignIn
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
//    func displaySignInPage() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "signInPage") as! SignInViewController
//        self.navigationController?.pushViewController(controller, animated: true)
//    }
//    
   
}
