//
//  CollectionView.swift
//  movileup
//
//  Created by iOS on 7/17/15.
//  Copyright (c) 2015 movile. All rights reserved.
//

import UIKit
import TraktModels
import Kingfisher

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var allShows : [Show] = []
    var visibleShows : [Show] = []
    
    var currentPage = 1
    var loadedShows = [Int : [Show]]()
    
    private var userDefaults = NSUserDefaults.standardUserDefaults()
    private let httpClient = TraktHTTPClient()
    private let group = dispatch_group_create()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    private func loadShows(page: Int) {
        
        dispatch_group_enter(group)
        
        httpClient.getPopularShows(page, completion: {[weak self] result in
            
            if let shows = result.value {
                self?.loadedShows[page] = shows
                
                if let s = self {
                    dispatch_group_leave(s.group)
                }
            }
            })
    }
    
    var loadingMore = false
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        var scrollViewHeight = scrollView.bounds.size.height
        var scrollContentSizeHeight = scrollView.contentSize.height
        var bottomInset = scrollView.contentInset.bottom
        var scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        
        if scrollView.contentOffset.y > scrollViewBottomOffset && !loadingMore {
            
            loadingMore = true
            currentPage++
            
            
            loadShows(currentPage)
            
            dispatch_group_notify(group, dispatch_get_main_queue()) { [weak self] in
                
                if let s = self {
                    var indexPaths : [AnyObject] = []
                    var lastIndex = s.visibleShows.count
                    for show in s.loadedShows[s.currentPage]! {
                        s.visibleShows.append(show)
                        indexPaths.append((NSIndexPath(forItem: lastIndex, inSection: 0) as AnyObject))
                        lastIndex++
                    }
                    s.collectionView.insertItemsAtIndexPaths(indexPaths)
                    s.loadingMore = false
                    
                    s.loadedShows.removeAll(keepCapacity: true)
                }
            }
        }
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "shows_to_show" {
    if let cell = sender as? UICollectionViewCell,
    indexPath = collectionView.indexPathForCell(cell) {
    }
    }
    }*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue == Segue.Seasons {
        if let cell = sender as? UICollectionViewCell,
        indexPath = collectionView.indexPathForCell(cell) {
        
        let vc = segue.destinationViewController as! SeasonsViewController
        
        if let id = visibleShows[indexPath.row].identifiers.slug {
            
            vc.selectedShow = visibleShows[indexPath.row]
            /*
            vc.showID = id
            vc.selectedShowTitle = visibleShows[indexPath.row].title
            vc.showIndex = indexPath.row*/
        }
        
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return self.visibleShows.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = Reusable.Cell.identifier!
        
        let item = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! CollectionViewCell
        
        let show = self.visibleShows[indexPath.row]
        item.loadShow(show)
        
        return item
    }
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            
            var flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            var itemSize = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
            var maxPerRow = floor(collectionView.bounds.width / itemSize)
            var usedSpace = itemSize * maxPerRow
            var additionalSpace = flowLayout.minimumInteritemSpacing * maxPerRow
            var sideSpace = floor(((collectionView.bounds.width - usedSpace) + additionalSpace) / (maxPerRow + 1))
            return UIEdgeInsetsMake(flowLayout.sectionInset.top, sideSpace, flowLayout.sectionInset.bottom, sideSpace)
    }
    
    
    
}
/*
import UIKit
import TraktModels

class ShowDetailsViewController: UIViewController, ShowInternalViewController {

@IBOutlet weak var broadcastingLabel: UILabel!
@IBOutlet weak var statusLabel: UILabel!
@IBOutlet weak var seasonsLabel: UILabel!
@IBOutlet weak var startedLabel: UILabel!
@IBOutlet weak var countryLabel: UILabel!
@IBOutlet weak var homepageLabel: UILabel!

var selectedShow : Show?
var seasons : [Season]?

override func viewDidLoad() {
super.viewDidLoad()

LoadDetails()
}

func intrinsicContentSize() -> CGSize {
let h1 = broadcastingLabel.intrinsicContentSize().height + broadcastingLabel.frame.height
let h2 = statusLabel.intrinsicContentSize().height + statusLabel.frame.height
let h3 = seasonsLabel.intrinsicContentSize().height + seasonsLabel.frame.height
let h4 = startedLabel.intrinsicContentSize().height + startedLabel.frame.height
let h5 = countryLabel.intrinsicContentSize().height + countryLabel.frame.height
let h6 = homepageLabel.intrinsicContentSize().height + homepageLabel.frame.height

return CGSize(width: 0, height: h1 + h2 + h3 + h4 + h5 + h6)
}

func LoadDetails() -> Void {

if let show = self.selectedShow,
seasons = self.seasons {

// Set broadcast text
if let network = show.network {

let broadText =  "Broadcastring: \(network)"

var mutableBroad = NSMutableAttributedString(string: broadText, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 16.0)!])
mutableBroad.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 16.0)!, range: NSRange(location:0, length:14))

broadcastingLabel.attributedText = mutableBroad
}
else {
broadcastingLabel.hidden = true
}


// Set Status text
if let status = show.status {

let statusText =  "Status: \(status.rawValue.capitalizedString)"

var mutableStatus = NSMutableAttributedString(string: statusText, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 16.0)!])
mutableStatus.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 16.0)!, range: NSRange(location:0, length:7))

statusLabel.attributedText = mutableStatus
}
else {
statusLabel.hidden = true
}

// Set Seasons text
let seasonText = "Seasons: \(seasons.filter { $0.number > 0 }.count)"

var mutableSeason = NSMutableAttributedString(string: seasonText, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 16.0)!])
mutableSeason.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 16.0)!, range: NSRange(location:0, length:8))

seasonsLabel.attributedText = mutableSeason

// Set started info text
let startedText = "Started in: \(show.year)"

var mutableStarted = NSMutableAttributedString(string: startedText, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 16.0)!])
mutableStarted.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 16.0)!, range: NSRange(location:0, length:11))

startedLabel.attributedText = mutableStarted

// Set Country text
if let country = show.country {

let countryText = "Country: \(country.uppercaseString)"

var mutableCountry = NSMutableAttributedString(string: countryText, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 16.0)!])
mutableCountry.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 16.0)!, range: NSRange(location:0, length:8))

countryLabel.attributedText = mutableCountry
}
else {
countryLabel.hidden = true
}


// Set homepage text
if let page = show.homepageURL {

let homepageText = "Homepage: \(page)"

var mutableHomepage = NSMutableAttributedString(string: homepageText, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 16.0)!])
mutableHomepage.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 16.0)!, range: NSRange(location:0, length:9))

homepageLabel.attributedText = mutableHomepage
}
else {
homepageLabel.hidden = true
}
}

}
}*/

