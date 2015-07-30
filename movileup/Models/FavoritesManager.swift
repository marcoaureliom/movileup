//
//  File.swift
//  movileup
//
//  Created by iOS on 7/28/15.
//  Copyright (c) 2015 movile. All rights reserved.
//

import UIKit

class FavoritesManager: NSObject {
    
    private var defaults = NSUserDefaults.standardUserDefaults()
    
    static let favoritesChangedNotification = "favoritesChangedNotification"
    
    static var favoritesIdentifiers: Set<String> = {
        if let favoritesId = NSUserDefaults.standardUserDefaults().objectForKey("favorites") as? [String] {
            
            var favoritesSet:Set<String> = Set(favoritesId)
            
            return favoritesSet
            
        } else {
            
            return Set<String>()
            
        }
        
        }()
    
    private func postNotification() {
        let name = self.dynamicType.favoritesChangedNotification
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName(name, object: self)
        
    }


    
    //Adicionar favorito
    func setFavorite(showId: String) {
        
        FavoritesManager.favoritesIdentifiers.insert(showId)
        
        var array = Array(FavoritesManager.favoritesIdentifiers)
        
        self.defaults.setObject(array, forKey: "favorites")
        self.defaults.synchronize()
        println("Id \(showId) adicionado a defaults")
        self.postNotification()
        
    }
    

    
    
    //Remover favorito
    func removeFavorite(showId: String) {
        
        FavoritesManager.favoritesIdentifiers.remove(showId)
        var array = Array(FavoritesManager.favoritesIdentifiers)
        
        self.defaults.setObject(array, forKey: "favorites")
        self.defaults.synchronize()
        
        println("Id \(showId) removido de defaults")
        self.postNotification()
    }
    
}
