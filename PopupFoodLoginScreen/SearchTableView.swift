//
//  SearchTableView.swift
//  PopupFood
//
//  Created by Sara Kandil on 2017-04-15.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class SearchTableViewController: UITableViewController, UISearchResultsUpdating,UISearchBarDelegate {
    
    var searchFood: SearchFood?
    
    //identify the cell
    let cellId = "cellId"
    
    //construct an array for the users
    var users = [User]()
    var filteredUsers = [User]()
    
    //create the searchbar
    var resultSearchController = UISearchController()
    
    func willPresentSearchController(searchController: UISearchController) {
//        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        // self.resultSearchController
        self.resultSearchController = UISearchController(searchResultsController: nil)
        
        //Configure the searchbar
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = true
        self.resultSearchController.hidesNavigationBarDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.resultSearchController.definesPresentationContext = true
        self.resultSearchController.searchBar.placeholder = "Search Users Name"
        self.resultSearchController.searchBar.delegate = self
        self.navigationItem.titleView = self.resultSearchController.searchBar
        self.resultSearchController.searchBar.showsScopeBar = true
        //setting the searchbar to be the header view
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        
        
        //fetch data from firebasedatabase
        fetchUsers()
        // fetchMenu()
        
        self.tableView.reloadData()
        
        
    }
    
    func fetchUsers(){
        
        let ref = FIRDatabase.database().reference().child("user")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? Dictionary<String, Any> {
                
                let user = User()
                self.users.append( user)
                
                user.name = dictionary["name"] as? String
                // user.email = dictionary["email"] as? String
                
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            }
        }, withCancel: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.isActive{
            
            return self.filteredUsers.count
        }
            
        else{
            
            return self.users.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if self.resultSearchController.isActive {
            
            let user = filteredUsers[indexPath.row]
            cell.textLabel?.text = user.name
        }
        else {
            let user = users[indexPath.row]
            
            cell.textLabel?.text = user.name
            
        }
        return cell
    }
    
    class UserCell: UITableViewCell{
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    
    
    @available(iOS 8.0, *)
    func updateSearchResults(for searchController: UISearchController) {
        
        print("test")
        //Remove all the filtered data
        self.filteredUsers.removeAll(keepingCapacity: false)
        print (filteredUsers)
        let searchPredicate = NSPredicate(format: "name CONTAINS[c] %@", searchController.searchBar.text!)
        
        self.filteredUsers = (self.users as NSArray).filtered(using: searchPredicate) as! [User]
        
        self.tableView.reloadData() }
    
    
}
