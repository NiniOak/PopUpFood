//
//  SignUpViewController.swift
//  PopupFood
//
//  Created by Anita Conestoga on 2017-02-01.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

//Barbara -22:53 - 05022016

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit //Import Facebook SignIn Kit
import GoogleSignIn //Import GoogleSignIn kit

//NEW PROJECT!!!!!
class SignUpViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupFacebookButton() //Method to set up Facebook button
        
        setupGoogleButton() //Method to set up Google Button
        
    }
    
    //Google Method called here
    
    fileprivate func setupGoogleButton() {
        
        //ADD CUSTOM GOOGLE BUTTON HERE
        
        //Commented Code below -> = GoogleUIButton
        /* let googleButton = GIDSignInButton()
         // Google Custom Button, will eventually remove for Custom button
         googleButton.frame = CGRect(x:16, y:116 + 66, width:view.frame.width - 32, height:100)
         view.addSubview(googleButton) */
        
        //Custom Google Sign in Button
        let customButton = googleButton
        customButton?.addTarget(self, action: #selector(handleCustomGoogleLogin), for: .touchUpInside)
        
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    
    func handleCustomGoogleLogin() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    //Facebook Method called here
    
    //ADD CUSTOM FACEBOOK BUTTON HERE
    
    fileprivate func setupFacebookButton() {
        let customFBButton = facebookButton
        customFBButton?.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        //BARBARA: handle login to another screen
        //hide login button if logged in already
        //customFBButton?.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FIRAuth.auth()?.addStateDidChangeListener{ auth, user in
            if user != nil {
                //User signed in
                //Redirect to home screen after sign in
                //let mainStoryboard: UIStoryboard = UIStoryboard(name: "HomePage", bundle:nil)
                //let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomePage") as UICollectionView
                
                let profileViewController = HomeAfterSignIn()
                self.present(profileViewController, animated: true, completion:nil)
                //self.navigationController?.pushViewController(profileViewController, animated: true)
                
                
            } else{
                //no user signed in
                //Show login button
                
                //BARBARA: causing instant re-login, so removed.
                
                //  self.handleCustomFBLogin()
                
                //show login button
                //customFBButton?.isHidden = false
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //FACEBOOK CLICK FUNCTIONALITY
    func handleCustomFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            if err != nil {
                print("Custom FB Button failed", err as Any)
                return
            }
            
            self.showEmailAddress()
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print (error)
            return
        }
        showEmailAddress()
    }
    
    func showEmailAddress() {
        //Save details in Firebase Auth
        let accessToken = FBSDKAccessToken.current()
        guard (accessToken?.tokenString) != nil else
        { return }
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: {(user,
            error) in
            if error != nil {
                print("Something went wrong with facebook: ", error as Any)
                return
            }
            print("Successfully logged in with our user: ", user as Any)
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start Graph request: ", err as Any)
                return
            }
            
            print(result as Any)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
}
/*
 
 
 /*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
 
 }*/
