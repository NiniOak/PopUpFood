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
    @IBOutlet weak var emailSignUpTxt: UITextField!
    @IBOutlet weak var pwdSignUpTxt: UITextField!
    
    //Impelmenation for Sign Up button
    @IBAction func signUpBtn(_ sender: UIButton) {
        
        FIRAuth.auth()?.createUser(withEmail: emailSignUpTxt.text!, password: pwdSignUpTxt.text!, completion: { (user, error ) in
        
            if error != nil {
            
                print(error?.localizedDescription as Any)
            }
            
            else {
            
                    print("User Created")
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
