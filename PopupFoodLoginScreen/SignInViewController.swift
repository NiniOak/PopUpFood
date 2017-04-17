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
    
    var errorsArray = [String]()
    
    var errorMessage = String()
    
    var signUpController: SignUpViewController?
    
    //Field Declaration
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    //let textField: UITextField!
    

    
    //Forgot password button

    @IBAction func forgotPasswordBtn(_ sender: Any) {
        
        alertForgotPassword()

    }//end of forgotPasswordBtn

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
    
    //Implementetion of Sign In validation fields

    func alertForgotPassword() {
        let alert = UIAlertController(title: "Forgot Password", message: "Please provide an email to reset your password", preferredStyle: UIAlertControllerStyle.alert)
        
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
                    message = "Password was successfully reset, please check your email!"
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
    //alert inplementetion here
    func signInValidationAlert(){
        let alert = UIAlertController(title: "Warning", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
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
            errorsArray.append("Incorrect email format!");
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
                //throw login error
                 self.userLogInFailed()
                print(error as Any)
                return
            }
                
            else{
                print("User Logged In")
            }
        })
        
    }//end of handleSignIn method
    
    @IBAction func facebookBtn(_ sender: Any) {
        perform(#selector(goToFacebook), with: nil, afterDelay: 0.1)
        print("I AM FACEBOOK")    }
    
    @IBAction func googleBtn(_ sender: Any) {
        perform(#selector(goToGoogle), with: nil, afterDelay: 0.1)
        print("I AM GOOGLE")    }
    
    func goToFacebook() {
          signUpController?.handleCustomFBLogin()
    }
    func goToGoogle() {
        signUpController?.handleCustomGoogleLogin()
    }
    
    func userLogInFailed() {
        
        let alert = UIAlertController(title: "Login Failed", message: "Please provide correct email and password.", preferredStyle: UIAlertControllerStyle.alert)
        //This is Cancel button action block
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
   
    func returnHomePage() {
        let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "newhomePage") as! HomeAfterSignIn
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
