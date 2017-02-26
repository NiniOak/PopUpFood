//
//  BeforeStartSellingViewController.swift
//  PopupFood
//
//  Created by Student on 2017-02-21.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

//OLEK class!!!!!! for Before selling page with CANCEL and ADD button
import UIKit

class BeforeStartSellingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let foodImages = ["test_pizza", "pasta", "defaultImage"]
    
    //Set up Table view rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
     return (foodImages.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DisplayMenuTableViewCell
        
        cell.foodImage.image = UIImage(named: (foodImages[indexPath.row]))
        cell.foodLabel.text = foodImages[indexPath.row]
        return (cell)
    }
    
    //plus button functionality
    @IBAction func addButton(_ sender: Any) {
        
            startSelling()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        goBackToLoggedInView()
    }
    override func viewDidLoad() {
        self.navigationItem.title = "Start Selling"
    }
    
    //This methid displays navigation Bar
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //Call viewcontroller and navigation bar for selling page
    func startSelling() {
     let storyboard = UIStoryboard(name: "startSelling", bundle: nil)
     let controller = storyboard.instantiateViewController(withIdentifier: "startSelling") as UIViewController
     self.navigationController?.pushViewController(controller, animated: true)
     }
    
    func goBackToLoggedInView(){
        let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "newhomePage") as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


