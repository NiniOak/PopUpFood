//
//  startSellingViewController.swift
//  PopupFood
//
//  Created by Barbara Akaeze on 2017-02-13.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class startSellingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var cuisineTypeLabel: UILabel!
    @IBOutlet weak var cuisineTypePickerView: UIPickerView!
    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!

    //BARBARA: Create an array for the picker view
    var cuisine = ["Carribbean", "Chinese", "French","Indian", "Italian", "Thai", "Other"]
    
    override func viewDidLoad() {
    super.viewDidLoad()

        let closeButton = UIImage(named: "xBtn")?.withRenderingMode(.alwaysOriginal)
        let leftBarButtonItem = UIBarButtonItem(image: closeButton, style: UIBarButtonItemStyle.plain, target: self, action: #selector(displayProfilePage))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        cuisineTypePickerView.delegate = self
        cuisineTypePickerView.dataSource = self
    }
    
    func displayProfilePage() {
        let storyboard = UIStoryboard(name: "ProfilePage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = false
        //navigationItem.title = "Start Selling"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Return amount of value in array
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cuisine.count
    }
    //identify current row on picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cuisine[row]
    }
    //set current row of picker view on label
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cuisineTypeLabel.text = cuisine[row]
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
