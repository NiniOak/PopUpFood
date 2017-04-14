//
//  SignInViewController.swift
//  PopupFood
//
//  Created by Anita Conestoga on 2017-02-01.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit //Import Facebook SignIn Kit
import GoogleSignIn //Import GoogleSignIn kit

//SIGN IN PAGE WITH FACEBOOK AND GOOGLE BUTTONS
class SignInViewController: UIViewController {
    
    var signUpController: SignUpViewController?
    
    //Field Declaration
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    //let textField: UITextField!
    
    @IBAction func facebookBtn(_ sender: Any) {
        signUpController?.handleCustomFBLogin()
    }
    
    @IBAction func googleBtn(_ sender: Any) {
        signUpController?.handleCustomGoogleLogin()
    }
    
    func alertForgotPassword() {
        let alert = UIAlertController(title: "Forgot your password?", message: "Please provide your email to reset a password", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Email Address"
        }
        
        let reset = UIAlertAction(title: "Reset", style: UIAlertActionStyle.default){ (action: UIAlertAction) -> Void in
            let textField = alert.textFields?[0]
            FIRAuth.auth()?.sendPasswordReset(withEmail: (textField?.text!)!, completion:{(error) in
                
                var title = ""
                var message = ""
                
                if(textField?.text! == ""){
                    title = "Something went wrong, please try again"
                    message = "Email field is empty, please provide a valid email!"
                }
                    
                else if(error != nil)
                {
                    title = "Something went wrong, please try again"
                    message = (error?.localizedDescription)!
                }
                    
                else
                {
                    title = "Success"
                    message = "Password was successfully reseted, please check your email!"
                    textField?.text = ""
                }
                
                
                //This is an alert box which is come after execution of Reset button was finished, and let us now was it okay or not
                let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
            })
        }
        
        alert.addAction(reset)// execute a reset functionality after user clicked Reset button
        
        //This is Cancel button action block
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    //Forgot password button
    @IBAction func forgotPasswordBtn(_ sender: Any) {
        
        alertForgotPassword()

    }//end of forgotPasswordBtn
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //If user is signed in, display homepage
        FIRAuth.auth()?.addStateDidChangeListener{ auth, user in
            
            if user != nil {
                self.returnHomePage()
            }
        }
    }
    
    //Implementation for Sign In Button and validation as well
    
    @IBAction func signInBtn(_ sender: UIButton) {
        
        errorsArray = [String]()//empty our errorsArray before checks will performe

        isValidEmail()
        isPasswordEmpty()
        
        if(errorsArray.isEmpty){
            handleSignIn()//create user and send it to databse
        }
            
        else{
            errorMessage = errorsArray.joined(separator: "\n")//concatinate strings from an array and format an error message from them
            signInValidationAlert()
        }
    }
    
    //Implementetion of Sign In validation fields
    var errorsArray = [String]()
    
    var errorMessage = String()
    
    //alert inplementetion here
    func signInValidationAlert(){
        let alert = UIAlertController(title: "Warning", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Correct It", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //Method is used for password's fields empty validation
    @discardableResult func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: emailTextField.text!)
        
        if(emailTextField.text == ""){
            errorsArray.append("Email field is empty!");
            return false
        }
        
        if(emailTest != true){
            errorsArray.append("Incorrect format of an email!");
            return false
        }
        return true
    }//end of isValidEmail method
    
    
    //Method is used for password's field empty validation
    @discardableResult func isPasswordEmpty() -> Bool {
        if (passwordTextField.text == ""){
            //password fields are empty
            errorsArray.append("Password field is empty!");
            return false
        }
        return true
    }//end of isPasswordsEmpty method

    
    //handleSignIn method
    func handleSignIn() {
        guard let email = emailTextField.text, let password = passwordTextField.text
            else {
                print ("Incorrect details entered")
                return
        }
        
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil{
                
                print(error as Any)
                return
            }
                
            else{
                print("User Logged In")
            }
        })
        
    }//end of handleSignIn method
    
    
    
    
    func returnHomePage() {
        let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "newhomePage") as! HomeAfterSignIn
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //    func displayLandingPage() {
    //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //        let controller = storyboard.instantiateViewController(withIdentifier: "landingVC") as UIViewController
    //        self.navigationController?.pushViewController(controller, animated: true)
    //    }
    
    @IBAction func backToLandingPage(_ sender: Any) {
        //displayLandingPage()
    }
}
