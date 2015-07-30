//
//  ShowsViewController.swift
//  movileup
//
//  Created by iOS on 7/22/15.
//  Copyright (c) 2015 movile. All rights reserved.
//
import UIKit
import TraktModels

class ShowsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Qual página
    var page = 1
    var isLoading = false
    
    var loadingView = UIView()
    var loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    
    
    private var favoritesManager:FavoritesManager = FavoritesManager()
    private let httpClient = TraktHTTPClient()
    private var shows: [Show]?
    private var popularShows = [Show]()
    private var favoriteShows = [Show]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Carregar Shows
        self.loadShows()
        let name = FavoritesManager.favoritesChangedNotification
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self, selector: "favoritesChanged", name: name, object: nil)
        
        println(FavoritesManager.favoritesIdentifiers)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hideBottomHairline()
        
        self.reloadShows()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.showBottomHairline()
    }
    
    deinit {
        let name = FavoritesManager.favoritesChangedNotification
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.removeObserver(self, name: name, object: nil)
        
        println("\(self.dynamicType) deinit")
        
    }
    
    //Atualizar os Favoritos
    func favoritesChanged() {
        
        self.favoriteShows.removeAll(keepCapacity: true)
        
        for showId in FavoritesManager.favoritesIdentifiers {
            self.httpClient.getShow(showId, completion: { (result) -> Void in
                
                if let show = result.value {
                    self.favoriteShows.append(show)
                }
            })
        }
        
        self.reloadShows()
    }
    
    
    
    func loadingView(show: Bool) {
        
        self.loadingView.frame = self.view.frame
        self.loadingIndicator.frame = self.view.frame
        
        self.loadingView.backgroundColor = UIColor.whiteColor()
        self.loadingView.alpha = 0.9
        
        self.loadingIndicator.startAnimating()
        
        if show == true {
            
            self.loadingView.addSubview(self.loadingIndicator)
            self.view.addSubview(self.loadingView)
            
        } else {
            self.loadingView.removeFromSuperview()
            self.loadingIndicator.removeFromSuperview()
            
        }
        
    }
    
    
    func loadShows() {
        
        if self.isLoading == false {
            //Loading
            self.loadingView(true)
            self.isLoading = true
            
            self.httpClient.getPopularShows(1) { (result) -> Void in
                if let shows = result.value {
    
                    self.popularShows = shows
                    
                    for showId in FavoritesManager.favoritesIdentifiers {
                        self.httpClient.getShow(showId, completion: { (result) -> Void in
                            
                            if let show = result.value {
                                self.favoriteShows.append(show)
                            }
                        })
                    }
                    
                    self.reloadShows()
                    self.isLoading = false
                    
                    self.loadingView(false)
                    
                } else {
                    println("Erro \(result.error)")
                }
            }
        }
        
    }
    
    //Carregar mais Shows
    func loadMore() {
        
        if self.isLoading == false {
            self.loadingView(true)
            //Há uma requisição
            self.isLoading = true
            
            self.page += 1
            
            self.httpClient.getPopularShows(self.page, completion: { (result) -> Void in
                
                if let shows = result.value {
                    for show in shows {
                        self.popularShows.append(show)
                        }
                    
                    self.reloadShows()
                    self.isLoading = false
                    
                    self.loadingView(false)
                    
                } else {
                    println("Erro \(result.error)")
                }
                
            })
            
        }
        
    }
    
    //Recarregar
    func reloadShows() {
        
        switch self.filterSegmentedControl.selectedSegmentIndex {
        case 0:
            self.shows = self.popularShows
            self.collectionView.reloadData()
        case 1:
            self.shows = self.favoriteShows
            self.collectionView.reloadData()
        default:
            self.collectionView.reloadData()
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let countShows = self.shows?.count {
            return countShows
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = Reusable.ShowCell.identifier!
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! ShowCollectionViewCell
        
        if let show = self.shows?[indexPath.row] {
            cell.loadShow(show)
        }
        
        if indexPath.row == self.popularShows.count - 3 {
            self.loadMore()
        }
        return cell
    }

    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let idealSpace: CGFloat = 12
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = idealSpace
        
        let itemWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
        let widthAvailable = collectionView.bounds.width
        let maxPerRow:CGFloat = 3
        let spaces = maxPerRow + 1
        let usedSpace = itemWidth * maxPerRow
        let space = floor((collectionView.bounds.width - usedSpace) / spaces)
        let increaseWidth = floor((((space - idealSpace) * spaces) / maxPerRow))
        let idealWidth = itemWidth + increaseWidth
        let idealHeight = round(((flowLayout.itemSize.height / itemWidth) * idealWidth))
        flowLayout.itemSize = CGSizeMake(idealWidth, idealHeight)
        
        return UIEdgeInsets(top: space, left: space, bottom: space, right: space)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UICollectionViewCell
        let indexPath = self.collectionView.indexPathForCell(cell)!
        
        if segue.identifier == Segue.SegueShowDetail.identifier {
            
            let showDetail = segue.destinationViewController as! ShowDetailViewController
            showDetail.show = self.shows?[indexPath.row]
            
            println(self.shows![indexPath.row].title)
            
            
            
        }
    }
    
    @IBAction func SegmentedTouch(sender: AnyObject) {
        self.reloadShows()
        
    }
    
    
}
