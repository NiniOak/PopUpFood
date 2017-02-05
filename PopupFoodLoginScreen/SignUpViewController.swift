//
//  SignUpViewController.swift
//  PopupFood
//
//  Created by Anita Conestoga on 2017-02-01.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

//SARA
class SignUpViewController: UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var facebookButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //ADD CUSTOM FACEBOOK BUTTON HERE
        let customFBButton = facebookButton
        customFBButton?.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
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
