//
//  SeasonTableViewCell.swift
//  movileup
//
//  Created by iOS on 7/26/15.
//  Copyright (c) 2015 movile. All rights reserved.
//

import UIKit
import FloatRatingView
import Kingfisher
import TraktModels

class SeasonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var seasonTitleLabel: UILabel!
    @IBOutlet weak var seasonEpisodesLabel: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadSeason(season: Season) {
        
        let placeholder = UIImage(named: "poster")
        
        if let url = season.poster?.thumbImageURL {
            self.posterImageView.kf_setImageWithURL(url, placeholderImage: placeholder)
            
        } else {
            self.posterImageView.image = placeholder
        }
        
        self.seasonTitleLabel.text = "Season \(season.number)"
        self.seasonEpisodesLabel.text = "\(season.episodeCount!) episodes"
        self.ratingView.rating = season.rating!
        self.ratingLabel.text = String(format: "%.1f", season.rating!)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
    
    
    
    
    
}
