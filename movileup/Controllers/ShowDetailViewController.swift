//
//  ShowDetailViewController.swift
//  movileup
//
//  Created by iOS on 7/28/15.
//  Copyright (c) 2015 movile. All rights reserved.
//

import UIKit
import TraktModels
import Kingfisher
import FloatRatingView

class ShowDetailViewController: UIViewController, ShowSeasonViewControllerDelegate {
    
    private let httpClient = TraktHTTPClient()
    var show:Show?
    var season: Season?
    var showSeasons:[Season]?
    
    private var favoritesManager:FavoritesManager = FavoritesManager()
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var yearLabel: UILabel!
    
    private weak var showOverviewViewController: ShowOverviewViewController!
    private weak var showSeasonsViewController: ShowSeasonViewController!
    private weak var showGenresViewController: ShowGenresViewController!
    private weak var showMoreViewController: ShowMoreViewController!
    private weak var seasonEpisodesViewController: SeasonEpisodesViewController!
    
    @IBOutlet weak var overviewConstraint: NSLayoutConstraint!
    @IBOutlet weak var seasonsConstraint: NSLayoutConstraint!
    @IBOutlet weak var genresConstraint: NSLayoutConstraint!
    @IBOutlet weak var moreConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = self.show?.title {
            
            self.title = title
            
        }
        
        if let showYear = self.show?.firstAired {
            
            //Obter o ano
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy"
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            
            let year = formatter.stringFromDate(showYear) as String
            
            self.yearLabel.text  = year
            
             
        }
        
        self.loadData()
        
        //Favoritos
        self.isFavorite()
        
    }
    
    deinit {
        
        println("\(self.dynamicType) deinit")
        
    }

    
    
    //Verificar favoritos
    func isFavorite() -> Bool {
        
        if let showId = self.show?.identifiers.slug {
            
            if FavoritesManager.favoritesIdentifiers.contains(showId) {
                
                self.favoriteButton.selected = true
                return true
                
            } else {
                
                self.favoriteButton.selected = false
                return false
            }
        }
        return false
    }
    
    

    
    
    
    func loadData() {
        
        // Atualizar imagem
        let placeholder = UIImage(named: "bg")
        
        if let url = self.show?.thumbImageURL {
            self.coverImageView.kf_setImageWithURL(url, placeholderImage: placeholder)
        } else {
            self.coverImageView.image = placeholder
        }
        
        if let showRating = self.show?.rating {
            self.ratingView.rating = showRating
            self.ratingLabel.text = String(format: "%.1f", showRating)
        }
        
        if let showIdentifier = self.show?.identifiers.slug {
            
            self.httpClient.getSeasons(showIdentifier, completion: { (result) -> Void in
                if let seasons = result.value {
                    
                    println("Seasons carregada")
                    self.showSeasons = seasons
                    
                    self.showSeasonsViewController.loadSeasons(seasons)
                    
                } else {
                    
                    println("Erro \(result.error)")
                }
            })
        }
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        self.overviewConstraint.constant = self.showOverviewViewController.intrinsicContentSize().height
        self.seasonsConstraint.constant = self.showSeasonsViewController.intrinsicContentSize().height
        self.genresConstraint.constant = self.showGenresViewController.intrinsicContentSize().height
        self.moreConstraint.constant = self.showMoreViewController.intrinsicContentSize().height
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == Segue.SegueShowOverview.identifier! {
            
            self.showOverviewViewController = segue.destinationViewController as! ShowOverviewViewController
            //Aqui
            if let overview = self.show?.overview {
                self.showOverviewViewController.overview = overview
            }
            
            // Seasons
        } else if segue.identifier == Segue.SegueShowSeasons.identifier! {
            
            self.showSeasonsViewController = segue.destinationViewController as! ShowSeasonViewController
            self.showSeasonsViewController.delegate = self
            self.showSeasonsViewController.loadSeasons(showSeasons)
            
        } else if segue.identifier == Segue.SegueShowGenres.identifier! {
            
            self.showGenresViewController = segue.destinationViewController as! ShowGenresViewController
            self.showGenresViewController.show = self.show
            
            
        } else if segue.identifier == Segue.SegueShowMore.identifier! {
            
            self.showMoreViewController = segue.destinationViewController as! ShowMoreViewController
            self.showMoreViewController.show = self.show
            
            
        } else if segue.identifier == Segue.SegueSeasonEpisodes.identifier! {
            
            self.seasonEpisodesViewController = segue.destinationViewController as! SeasonEpisodesViewController
            self.seasonEpisodesViewController.season = self.season
            self.seasonEpisodesViewController.show = self.show
        }
        
    }
    
    func seasonsController(vc: ShowSeasonViewController, didSelectSeason season: Season) {
        println("Season: \(season.number)")
        
        self.season = season
        performSegueWithIdentifier(Segue.SegueSeasonEpisodes.identifier!, sender: self)
    }
    
    
    @IBAction func favoriteTouch(sender: AnyObject) {
        
        let button = sender as! UIButton
        
        if let showId = self.show?.identifiers.slug {
            
            if self.isFavorite() {
                self.favoritesManager.removeFavorite(showId)
            } else {
                self.favoritesManager.setFavorite(showId)
            }
            
        }
        self.isFavorite()
        
    }
    
}
