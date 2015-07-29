//
//  ShowSeasonViewController.swift
//  movileup
//
//  Created by iOS on 7/27/15.
//  Copyright (c) 2015 movile. All rights reserved.
//

import UIKit
import TraktModels

protocol ShowSeasonViewControllerDelegate: class {
    func seasonsController(vc: ShowSeasonViewController, didSelectSeason season: Season)
}

class ShowSeasonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ShowInternalViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var showSeasons:[Season]?
    weak var delegate: ShowSeasonViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.scrollEnabled = false
        loadSeasons(self.showSeasons)
    }
    
    deinit {
        
        println("\(self.dynamicType) deinit")
        
    }
    
    
    func loadSeasons(seasons: [Season]?) {
        self.showSeasons = seasons
        if isViewLoaded() {
            self.tableView.reloadData()
        }
    }
    
    //TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let totalSeasons = self.showSeasons?.count {
            return totalSeasons
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = Reusable.SeasonCell.identifier!
        let cell = self.tableView.dequeueReusableCellWithIdentifier(identifier) as! SeasonTableViewCell
        
        if let season = self.showSeasons?[indexPath.row] {
            cell.loadSeason(season)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let season = self.showSeasons?[indexPath.row] {
            self.delegate?.seasonsController(self, didSelectSeason: season)
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func intrinsicContentSize() -> CGSize {
        
        var seasonsHeight = self.tableView.contentSize.height + 31
        return CGSize(width: self.view.frame.width, height: seasonsHeight)
        
    }
    
}
