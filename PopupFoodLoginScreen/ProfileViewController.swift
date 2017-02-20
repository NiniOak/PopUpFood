//
//  ProfileViewController.swift
//  PopupFood
//
//  Created by Barbara Akaeze on 2017-02-12.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit

class ProfileViewController: UIViewController {
    //FEATURES
    @IBOutlet weak var ImageViewProfilePic: UIImageView!
    @IBOutlet weak var labelName: UILabel!

    //ACTIONS:
    
    //BARBARA: Selling onclick
    @IBAction func sellingButton(_ sender: Any) {
        startSelling()
        
    }
    
    
    //BARBARA: Handle onclick logout
    @IBAction func logoutButton(_ sender: Any) {
        
        //Signout of application
        handleLogOut()
        FBSDKAccessToken.setCurrent(nil)
        
        print("User Logged out")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if user exists in database when logged in
        checkIfUserIsLoggedIn()

    }
    
    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogOut), with: nil, afterDelay: 0)
        } else {
            
            makeProfileImageRound()
            
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("customers").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let name = dictionary["name"] as? String
                    self.labelName.text = name
                    
                    if let profileImage = dictionary["image"] as? UIImage {
                        self.ImageViewProfilePic.image = profileImage
                    } else {
                        self.ImageViewProfilePic.image = UIImage (named: "defaultImage")
                    }
                    
                }
            }, withCancel: nil)
            // Do any additional steps if the user is signed in
            /*if let user = FIRAuth.auth()?.currentUser{
                //User signed in
                let name = user.displayName
                //   let email = user.email
                //    let uid = user.uid
                self.labelName.text = name
                
                //Set image to default image if user has no Profile Image
                if let photoURL = user.photoURL {
                    let data = NSData(contentsOf: photoURL)
                    self.ImageViewProfilePic.image = UIImage(data: data! as Data)
                } else {
                    self.ImageViewProfilePic.image = UIImage(named: "defaultImage")
                }
            }*/
        }
    }
    
    func makeProfileImageRound() {
        //BARBARA: Make profile picture round
        self.ImageViewProfilePic.layer.cornerRadius = self.ImageViewProfilePic.frame.size.height/80
        self.ImageViewProfilePic.clipsToBounds = true
    }
    
    //Call viewcontroller for selling page
    func startSelling() {
        let storyboard = UIStoryboard(name: "startSelling", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "startSelling") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
    }
    
     //handle Logout Button
    func handleLogOut() {
        do {
            try FIRAuth.auth()!.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        displayHomePage()
    }

    //Display homepage if not signed in
    func displayHomePage() {
        
        //Send user back to home screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "landingVC") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
        /////////////////////////////////////////////////////////////////////////////

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

//
//  ProfileViewController.swift
//
//
//  Created by Barbara Akaeze on 2017-02-12.
//
//

/*import UIKit
import FirebaseAuth
import FBSDKCoreKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var ImageViewProfilePic: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    //ACTIONS:
    //BARBARA: Handle onclick logout
    @IBAction func logoutButton(_ sender: Any) {
        
        //Signout of Firebase app
        try! FIRAuth.auth()!.signOut()
        
        //Sign out of Facebook app
        FBSDKAccessToken.setCurrent(nil)
        
        //Send user back to home screen
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let landingViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Main")
        //show new storyboard
        self.present(landingViewController, animated: true, completion: nil)
        
        print("User Logged out")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //BARBARA: Make profile picture round
        
        self.ImageViewProfilePic.layer.cornerRadius = self.ImageViewProfilePic.frame.size.height/2
        self.ImageViewProfilePic.clipsToBounds = true
        
        //if the user is signed in
        if let user = FIRAuth.auth()?.currentUser{
            //User signed in
            let name = user.displayName
            //   let email = user.email
            let photoURL = user.photoURL
            //    let uid = user.uid
            
            self.labelName.text = name
            
            let data = NSData(contentsOf: photoURL!)
            self.ImageViewProfilePic.image = UIImage(data: data! as Data)
            
        } else {
            //No user signed in
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

*/
