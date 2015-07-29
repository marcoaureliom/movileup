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

class ShowCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func loadShow(show: Show) {
        
        let placeholder = UIImage(named: "poster")
        
        if let url = show.poster?.mediumImageURL {
            self.posterImageView.kf_setImageWithURL(url, placeholderImage: placeholder)
            
        } else {
            self.posterImageView.image = placeholder
        }
        
        self.titleLabel.text = show.title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
    
    
    
    
    
}

