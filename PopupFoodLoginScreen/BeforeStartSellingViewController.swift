//
//  BeforeStartSellingViewController.swift
//  PopupFood
//
//  Created by Student on 2017-02-21.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

//OLEK class!!!!!! for Before selling page with CANCEL and ADD button
import UIKit

class BeforeStartSellingViewController: UIViewController{
    
    //plus button functionality
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        startSelling()
        
    }
    
    //Call viewcontroller for selling page
    func startSelling() {
     let storyboard = UIStoryboard(name: "startSelling", bundle: nil)
     let controller = storyboard.instantiateViewController(withIdentifier: "startSelling") as UIViewController
     
     self.present(controller, animated: true, completion: nil)
     }
    
    
    
    
    //Cancel button functionality
    @IBAction func cancelButon(_ sender: UIBarButtonItem) {
        
        goBackToLoggedInView()
    }
    
    func goBackToLoggedInView(){
        let storyboard = UIStoryboard(name: "ProfilePage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
    }
}




//before start selling ViewController with the X and + button
/*func startSelling() {
 let storyboard = UIStoryboard(name: "startSelling", bundle: nil)
 let controller = storyboard.instantiateViewController(withIdentifier: "startSelling") as UIViewController
 
 self.present(controller, animated: true, completion: nil)
 }*/
