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

    //Field Declaration
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    
    @IBOutlet weak var emailSignInTxt: UITextField!
    
    @IBOutlet weak var passwordSignInTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let callGoogleBtn = SignUpViewController()
        callGoogleBtn.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //Implementation for Sign In Button
    
    @IBAction func signInBtn(_ sender: UIButton) {
    
        FIRAuth.auth()?.signIn(withEmail: emailSignInTxt.text!, password: passwordSignInTxt.text!, completion: { (user, error) in
        
            if error != nil{
            
                print(error?.localizedDescription as Any)
                
            }
            
            else{
                
                print("User Logged In")
            }
        
        })
    
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
