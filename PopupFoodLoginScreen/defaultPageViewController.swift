//
//  defaultPageViewController.swift
//  PopupFood
//
//  Created by Anita on 2017-02-07.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit

//Iteration 1
class defaultPageViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DEFAULT PAGE CODE
        navigationItem.title = "PopupFood" //align left
        collectionView?.backgroundColor = UIColor.white
        //Register cellID
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "cellID")
    }
    
    //DEFAULT PAGE CODE
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:view.frame.width, height:200)
    }
    
    //Edit lineSpacing between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //Implement Class for Video Cell
    class VideoCell: UICollectionViewCell{
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupViews()
        }
        
        //IMPLEMENT BIG IMAGE DISPLAY
        let thumbnailImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.blue
            return imageView
        }()
        
        //IMPLEMENT PROFILE IMAGE VIEW
        let userProfileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.blue
            return imageView
        }()
        
        //ADD LINES BETWEEN CELLS
        let separatorView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.black
            return view
        }()
        
       func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        
        //Constraints for image cell
        addConstraintsWithFormat(format:"H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstraintsWithFormat(format:"V:|-16-[v0]-16-[v1(1)]|", views: thumbnailImageView, separatorView)
        
        //constraints for lines between cells
        addConstraintsWithFormat(format:"H:|[v0]|", views: separatorView)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    //Default Method created with the Class
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}




