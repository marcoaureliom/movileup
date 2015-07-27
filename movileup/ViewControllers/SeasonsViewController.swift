//
//  SeasonsViewController.swift
//  movileup
//
//  Created by iOS on 7/27/15.
//  Copyright (c) 2015 movile. All rights reserved.
//

import UIKit
import TraktModels

protocol SeasonsViewControllerDelegate: class {
    func seasonsController(vc: SeasonsViewController, didSelectedSeason seasons: Season)
}

class SeasonsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var collectionViewControllerSeasons: UITableView!
    
    /*var showID: String?
    var selectedShowTitle: String?
    var showIndex: Int?*/
    
    weak var delegate : SeasonsViewControllerDelegate?
    
    var selectedShow : Show?
    var seasonsList : [Season] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    func ReloadTable(show: Show?, seasons: [Season]) -> Void {
        
        self.selectedShow = show
        self.seasonsList = seasons
        collectionViewControllerSeasons.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let season = seasonsList[indexPath.row]
        delegate?.seasonsController(self, didSelectedSeason: season)
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.seasonsList.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        
        return cell
    }
    
    func tableView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> Void {
        
        let identifier = Reusable.Cell.identifier!
        
        let item = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! SeasonsCollectionViewCell
        
        let season = self.seasonsList[indexPath.row]
        item.carregaTemporada(season)
        
        //return item
    }

    
    
}
