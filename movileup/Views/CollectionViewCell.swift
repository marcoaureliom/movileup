//
//  CollectionViewCell.swift
//  movileup
//
//  Created by iOS on 7/17/15.
//  Copyright (c) 2015 movile. All rights reserved.
//

import UIKit
import TraktModels
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellNumberLabel: UILabel!
    
    
    var task : RetrieveImageTask?
    
    func loadShow(show : Show) {
        
        let placeholder = UIImage(named: "poster")
        
        if let image = show.poster?.mediumImageURL {
            task = cellImage.kf_setImageWithURL(image, placeholderImage: placeholder)
        }
        else {
            cellImage.image = placeholder
        }
        
        cellNumberLabel.text = show.title
    }
    
    /*override func prepareForReuse() {
        super.prepareForReuse()
        
        if task != nil {
            task?.cancel()
        }
        showImage.image = nil
    }*/

    
}
