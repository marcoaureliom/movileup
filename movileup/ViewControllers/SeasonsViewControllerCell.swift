//
//  SeasonsViewControllerCell.swift
//  movileup
//
//  Created by iOS on 7/27/15.
//  Copyright (c) 2015 movile. All rights reserved.
//

import UIKit
import TraktModels
import Kingfisher
import FloatRatingView

class SeasonsCollectionViewCell: UITableViewCell {
    
    @IBOutlet weak var imageSeason: UIImageView!
    @IBOutlet weak var SeasonLabel: UILabel!
    @IBOutlet weak var NumEpisodes: UILabel!
    
    var task : RetrieveImageTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func carregaTemporada(season : Season) -> Void {
        
        let placeholder = UIImage(named: "poster")
        
        if let image = season.poster?.fullImageURL {
            task = imageSeason.kf_setImageWithURL(image, placeholderImage: placeholder)
        }
        else {
            imageSeason.image = placeholder
        }
        
        SeasonLabel.text = "Season \(season.number)"
        if let n = season.episodeCount {
            NumEpisodes.text = "\(n) episodes"
        }
        else {
            NumEpisodes.text = "-"
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if task != nil {
            task?.cancel()
        }
        imageSeason.image = nil
    }
}

