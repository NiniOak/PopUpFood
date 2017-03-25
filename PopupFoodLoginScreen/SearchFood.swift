//
//  SearchFood.swift
//  PopupFood
//
//  Created by Student on 2017-03-15.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//



import UIKit
import Firebase
import FirebaseAuth


class SearchFood: UICollectionViewController {
    
    let reuseIdentifier = "FoodImageCell"
    
    var imagesArray = [Menu]()
    
    var menu : Menu?
    
    //Style for cells
    //    private let leftAndRightPadding: CGFloat = 3.0
    //    private let numberOfItemsPerRaw: CGFloat = 3.0
    //    private let heightAdjustment: CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = (collectionView!.frame.width) / 3 - 1
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width + 10.0)
        
        handleFoodImagesFetching()
        //        let width = (collectionView!.frame.width - leftAndRightPadding) / numberOfItemsPerRaw
        //
        //        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        //        layout.itemSize = CGSize(width: width, height: width + heightAdjustment)
    }
    
    //Call a search bar Olek
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SearchFoodHeader", for: indexPath)
            
            return headerView
        }
        
        return UICollectionReusableView()
        
    }
    
    func handleFoodImagesFetching(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        //Get user table, then userID, in user ID, get the favourites
        let ref = FIRDatabase.database().reference().child("user").child(uid).child("menu")
        ref.observe(.childAdded, with: { (snapshot) in
            //Get menuID within users
            let menuID = snapshot.key
            let menuReference = FIRDatabase.database().reference().child("menu").child(menuID)
            
            menuReference.observe(.childAdded, with: { (snapshot) in
                //GetimageUrl within menu
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    //save all pictures to an array
                    
                    let menu = Menu()
                    
                    self.imagesArray.append(menu)
                    
                    //This calls the entire database for menu input by a user
                    menu.foodImageUrl = dictionary["foodImageUrl"] as? String
                    
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                    
                }
            })
        })
    }
    
    
    
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imagesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as UICollectionViewCell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DisplayFoodImagesOnSearchingPage
        
        let menu = imagesArray[indexPath.row]
        
        print(menu)
        if let foodImageUrl = menu.foodImageUrl {
            cell.foodImage.sd_setImage(with: URL(string: foodImageUrl))
            //} else {
            //  cell.foodImage.image = UIImage(named: "Mike Saj")
            //}
            
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
