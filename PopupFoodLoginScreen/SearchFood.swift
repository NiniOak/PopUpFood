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
import SDWebImage

class SearchFood: UICollectionViewController, UISearchBarDelegate {
    
    let reuseIdentifier = "FoodImageCell"
    
    var imagesArray = [Menu]()
    
    var menu : Menu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = (collectionView!.frame.width) / 3 - 1
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width + 10.0)
        
        handleFoodImagesFetching()
    }
    
    //Call a search bar Olek
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView: UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SearchFoodHeader", for: indexPath)
        
        if (kind == UICollectionElementKindSectionHeader) {
            
            return headerView
        }
        
        return UICollectionReusableView()
        
    }
    
    
//Olek Search Page fetching images functionality
    func handleFoodImagesFetching(){
        
        let ref = FIRDatabase.database().reference().child("menu")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            for images in snapshot.children.allObjects as! [FIRDataSnapshot] {
                
                if let dictionary = images.value as? [String: AnyObject] {
                    let menu = Menu()

                    self.imagesArray.append(menu)

                    menu.foodImageUrl = dictionary["foodImageUrl"] as? String
                    
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            }
            
        }, withCancel: nil)

    }//end of handleFoodImagesFetching method

    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imagesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DisplayFoodImagesOnSearchingPage
        
        let menu = imagesArray[indexPath.row]
        
        if let foodImageUrl = menu.foodImageUrl {
            cell.foodImage.sd_setImage(with: URL(string: foodImageUrl))
        }
        
        // TODO ------- if search bar was clicked hide cells by cell.isHidden = true
        
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
