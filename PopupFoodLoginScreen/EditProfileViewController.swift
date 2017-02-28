//
//  EditProfileViewController.swift
//  PopupFood
//
//  Created by Barbara Akaeze on 2017-02-27.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var updateProfileImage: UIImageView!
 
    var databaseRef: FIRDatabaseReference!
    
    //Change Image button
    @IBAction func changeImage(_ sender: Any) {
        
        let selectImage = UIImagePickerController()
        selectImage.delegate = self
        
        selectImage.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        //selectImage.allowsEditing = false
        self.present(selectImage, animated: true)
        

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            updateProfileImage.image = selectImage
        }
        else
        {
            //Display Error Message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveProfile(_ sender: Any) {
        updateProfile()
        
       // print("123")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        databaseRef = FIRDatabase.database().reference()
        
        defaultProfileImage()
        loadProfileData()
        
    }
    //Inputs existing info from DB in the text label
    func loadProfileData() {
        if let userID = FIRAuth.auth()?.currentUser?.uid{
            databaseRef.child("customers").child(userID).observe(.value, with: { (snapshot) in
                
                //Store users data in dictionary
                let values = snapshot.value as? NSDictionary
                
                self.usernameText.text = values?["name"] as? String
                self.emailText.text = values?["email"] as? String
                self.passwordText.text = values?["password"] as? String
            })
        }
    }
    
    func updateProfile() {
        //check if user is logged in
        if let userID = FIRAuth.auth()?.currentUser?.uid
          
        {
            //get access to user profit pic storage
            //get image from gallery
            //upload to Firebase storage
            //get all new entries and store
            
           // guard let newUsername = self.usernameText.text!, let newEmail = self.emailText.text!, let newPassword = self.passwordText.text! else {
            //    return
           // }
            
            //save in dictionary
            let newValuesForProfile =
            ["name": self.usernameText.text!,
             "email": self.emailText.text!,
             "password": self.passwordText.text!]
            
            //Update the Database
            self.databaseRef.child("customers").child(userID).updateChildValues(newValuesForProfile, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
                print("Profile details successfully updated")
            })
            
        }
    }
    
    
    func defaultProfileImage() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("customers").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                if let profileImage = dictionary["image"] as? UIImage {
                    self.updateProfileImage.image = profileImage
                } else {
                    self.updateProfileImage.image = UIImage (named: "defaultImage")
                }
            }
        }, withCancel: nil)
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
