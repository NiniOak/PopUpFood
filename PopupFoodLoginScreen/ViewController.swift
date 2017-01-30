//
//  ViewController.swift
//  PopupFoodLoginScreen
//
//  Created by Anita Conestoga on 2017-01-27.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "SignUpView", sender: self);
    }

    /*override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Back"
    }*/

}
