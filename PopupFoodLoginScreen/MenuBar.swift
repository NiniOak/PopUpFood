//
//  MenuBar.swift
//  PopupFood
//
//  Created by Student on 2017-02-11.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 221, green: 242, blue: 236, alpha: 1)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    let imageNames = ["home", "favorites", "messages", "selling"]
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        //Add cell for adding icons
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        //ensure current menu position button is ALWAYS selected
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: (UICollectionViewScrollPosition.left))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        //cell.imageView.image = UIImage(named: #imageLiteral(resourceName: "favorites"))?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(showFavorites())
        cell.tintColor = UIColor.rgb(red: 91, green: 14, blue: 13, alpha: 1)
        
        return cell
    }
    //get frame and height of menu
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}//end of MenuBar class

//for entering icons
class MenuCell: BaseCell{
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Home")?.withRenderingMode(.alwaysTemplate) //specify the name of the photo from Assets
        iv.tintColor = UIColor.rgb(red: 91, green: 14, blue: 13, alpha: 1)
        return iv
    }()
    
    
    //block for hightlights
    override var isHighlighted: Bool{
        didSet {
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.rgb(red: 91, green: 14, blue: 13, alpha: 1)
        }
    }//end of is Hightlighted
    
    //when a cell is selected, a new color is put on icons
    override var isSelected: Bool{
        didSet {
            imageView.tintColor = isSelected ? UIColor.white : UIColor.rgb(red: 91, green: 14, blue: 13, alpha: 1)
            selectMenuItems()
           
        }
    }//end of isSelected

        //calling from videocell
    override func setupViews(){
        super.setupViews()
        
        addSubview(imageView)
        
        addConstraintsWithFormat(format: "H:[v0(28)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(28)]", views: imageView)
        
        addConstraints([NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)])
        
        addConstraints([NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
    }
    
    func selectMenuItems() {
        let iv = UIImageView()
        if iv.image == UIImage(named: "favorites") {
            print("favorite selected")
        }else {
            print("fave not selected")
        }
}
    
}//end of Menu Bar class


