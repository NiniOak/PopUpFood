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
    
    var user = [User]()
    
    @IBOutlet weak var homeButton: UIBarButtonItem!
    
    @IBAction func homeButton(_ sender: Any) {
        returnHomePage()
  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "home"), for: .normal)
        button.sizeToFit()
        self.homeButton = UIBarButtonItem(customView: button)
        
        // Check if user exists in database when logged in
        checkIfUserIsLoggedIn()
        
    }
    //FEATURES
    @IBOutlet weak var ImageViewProfilePic: UIImageView!
    @IBOutlet weak var labelName: UILabel!

    //ACTIONS:
    
    @IBAction func sellingButton(_ sender: Any) {
        //startSelling() move to before page and assign to plus button
        
        goToBeforeSelling()
    }
    @IBAction func editProfile(_ sender: Any) {
        editProfile()
    }
    
    //BARBARA: Handle onclick logout
    @IBAction func logoutButton(_ sender: Any) {
        
        //Signout of application
        handleLogOut()
        FBSDKAccessToken.setCurrent(nil)
        
        print("User Logged out")
    }
    //BARBARA: On click, launch edit profile page

    
     func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogOut), with: nil, afterDelay: 0)
        } else {
            
            makeProfileImageRound()
            let uid = FIRAuth.auth()?.currentUser?.uid
            let user = User()
            user.id = uid
            
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
        self.ImageViewProfilePic.layer.cornerRadius = self.ImageViewProfilePic.frame.size.height/89
        self.ImageViewProfilePic.clipsToBounds = true
    }
    
    //Call viewcontroller for selling page //move to before page!!!!!!!!!!!!!!!!!!!!!!!!!
    /*func startSelling() {
        let storyboard = UIStoryboard(name: "startSelling", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "startSelling") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
    }*/
    
    
    
    //Olek refactoring to insert SELLING view before startSellingViewController
    func goToBeforeSelling() {
        let storyboard = UIStoryboard(name: "startSelling", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BeforeSellingPage") as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)
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
    //Display edit profile page
    func editProfile() {
        let storyboard = UIStoryboard(name: "ProfilePage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "editProfile") as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func returnHomePage() {
        
        let signInViewCOntroller = SignInViewController()
        let nextViewController: UINavigationController = UINavigationController(rootViewController: signInViewCOntroller)
        self.present(nextViewController, animated: true, completion: nil)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//
//  ProfileViewController.swift
//
//
//  Created by Barbara Akaeze on 2017-02-12.
//
//


