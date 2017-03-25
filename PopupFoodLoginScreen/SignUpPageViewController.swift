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

class SignUpPageViewController: UIViewController {
    
    // Fields Declaration
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var RepasswordTextField: UITextField!
    
    //write a validating function which will go throught all fields and check them, after there will be an error concatinate the erroe message and at the end show concatinated string in alert message.
    
    
    
    
    
    
    
    
    
    //Method for alert box when password and re-enter password fields does not match ------ Olek
    //    func alertPasswordDoesntMatch(){
    //        let alert = UIAlertController(title: "Password warning", message: "Passwords are not match", preferredStyle: UIAlertControllerStyle.alert)
    //
    //        alert.addAction(UIAlertAction(title: "Correct It", style: UIAlertActionStyle.default, handler: nil))
    //
    //        self.present(alert, animated: true, completion: nil)
    //    }
    //
    //
    //    //Method for alert box when password and re-enter password fields are empty ------ Olek
    //    func alertPasswordIsEmpty(){
    //        let alert = UIAlertController(title: "Password warning", message: "Password fields are empty", preferredStyle: UIAlertControllerStyle.alert)
    //
    //        alert.addAction(UIAlertAction(title: "Add them", style: UIAlertActionStyle.default, handler: nil))
    //
    //        self.present(alert, animated: true, completion: nil)
    //    }
    //
    //
    //    //Method for alert box when email field was formmated wrong ------ Olek
    //    func alertEmailFormat(){
    //        let alert = UIAlertController(title: "Email warning", message: "Email formmated wrong", preferredStyle: UIAlertControllerStyle.alert)
    //
    //        alert.addAction(UIAlertAction(title: "Correct It", style: UIAlertActionStyle.default, handler: nil))
    //
    //        self.present(alert, animated: true, completion: nil)
    //    }
    
    
    //Impelmenation for Sign Up button
    @IBAction func signUpBtn(_ sender: UIButton) {
        handleRegister()
        
        goToHomePage()
    }
    
    //    //Olek/Sara method is used for email validation
    //    @discardableResult func isValidEmail(testStr:String) -> Bool {
    //        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}"
    //
    //        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: testStr)
    //
    //        if(emailTest == true){
    //            return emailTest
    //        }
    //
    //        else
    //        {
    //            print("Incorrect format of email!!!")
    //            alertEmailFormat()
    //            return false
    //        }
    //    }//end of email validation method
    
    
    
    func handleRegister() {
        
        guard let email = emailTextField.text, let username = usernameTextField.text, let password = passwordTextField.text
            else {
                print ("Form filled inappropriately")
                return
        }
        
        //        if(){
        //
        //        }
        //        isValidEmail(testStr: email)
        //
        //
        //        //Olek/Sara - added a password validation
        //        if(passwordTextField.text != RepasswordTextField.text){
        //            //password are not match
        //            print("password does not match!!!")
        //            alertPasswordDoesntMatch()
        //        }
        //
        //        else if (passwordTextField.text == "" && RepasswordTextField.text == ""){
        //            //password fields are empty
        //            print("password fields are empty!!!")
        //            alertPasswordIsEmpty()
        //        }
        //if everything is okay go ahead and create a customer and put customer registration data in the database in follows ELSE clause!!!
        
        
        
        //added this else clause for creating a user and sending them data to database
        //else
        //{
        
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
            var ref: FIRDatabaseReference!
            
            ref = FIRDatabase.database().reference()
            let usersReference = ref.child("user").child(uid)
            let values = ["name": username, "email": email, "password": password]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print(err as Any)
                    return
                }
                print ("User Data saved to Firebase Database!")
            })
        })
        //}//Olek/Sara end of else clause where user is adding if password and email matches requirements
        
    }//end of handleRegister method
    
    
    
    func goToHomePage() {
        let signInViewCOntroller = SignInViewController()
        let nextViewController: UINavigationController = UINavigationController(rootViewController: signInViewCOntroller)
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}//end of SignUpPageViewController
