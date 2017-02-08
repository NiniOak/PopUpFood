//
//  defaultPageViewController.swift
//  PopupFood
//
//  Created by Anita on 2017-02-07.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit

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
        
        let thumbnailImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.blue
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
       func setupViews() {
        addSubview(thumbnailImageView)
        
        //thumbnailImageView.frame = CGRect(x:0, y:0, width:100, height:100)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": thumbnailImageView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": thumbnailImageView]))
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
