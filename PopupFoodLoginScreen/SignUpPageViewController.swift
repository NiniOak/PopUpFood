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
    
    @IBAction func signInBtn(_ sender: Any) {
        goToSignInPage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Sign Up"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    ///////////// OLEK \\\\\\\\\\\\\\\\\\
    //var emailArray = [User]()
    var user : User?
    
    
    var errorArray = [String]()
    
    var errorMessage = String()
    
    //Method for alert box when one of the fields were formmated wrong ------ Olek
    func generalAlert() {
        
        let alert = UIAlertController(title: "Required", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Alert box for a situation when email is already exists in the database
    func emailExistsAlert(){
        let alert = UIAlertController(title: "Warning", message: "Email already in use", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

    /////////////////////////////
    //Olek/Sara method is used for email validation
    var emailErrorMessage  = String()
    
    func checkEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: emailTextField.text!)
        
        if(emailTextField.text == ""){
            errorArray.append("Email required");
            return false
        }
        
        if(emailTest != true){
            errorArray.append("Incorrect email format");
            return false
        }
        return true
    }//end of checkEmail method
    
    
    //Method is used for username field validation
    func checkUsername() -> Bool {
        if(usernameTextField.text == ""){
            errorArray.append("Username required")
            return false
        }
        return true
    }//end of username field validation
    
    
    //Method is used for password's fields match validation
    func checkPassword() -> Bool {
        if(passwordTextField.text != RepasswordTextField.text){
            //password fields are not match
            errorArray.append("Passwords mismatch");
            return false
        }
        return true
    }//end of checkPassword method
    
    //Method is used for password's fields empty validation
    func checkPasswordEntry() -> Bool {
        if (passwordTextField.text == "" && RepasswordTextField.text == ""){
            //password fields are empty
            errorArray.append("Password required");
            return false
        }
        return true
    }//end of checkPasswordEntry method
    ////////////////////////////////////////////////
    
    func handleRegister() {
        
        //getAllEmailsFromDB()
        errorArray = [String]()//empty our errorArray before checks will performe
        
        _ = checkEmail()
        _ = checkUsername()
        _ = checkPasswordEntry()
        _ = checkPassword()
        
        if(errorArray.isEmpty){
            createUserInDataBase()//create user and send it to database
        }
            
        else{
            errorMessage = errorArray.joined(separator: "\n")//concat strings from an array and format an error message from them
            generalAlert()
        }
        //Olek/Sara end of else clause where user is adding if password and email matches requirements
        
    }//end of handleRegister method
    
    /////////////////////////////////////////////////
    
    func createUserInDataBase() {
        
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
                    self.emailExistsAlert()
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
    
    func goToSignInPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "signInPage")
        self.navigationController?.pushViewController(controller, animated: true)
    }
   
}
