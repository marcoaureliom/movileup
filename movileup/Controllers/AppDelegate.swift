//
//  AppDelegate.swift
//  movileup
//
//  Created by iOS on 7/27/15.
//  Copyright (c) 2015 movile. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        //Setar o fundo da barra para laranja e deixar o texto branco
        let appearance = UINavigationBar.appearance()
        appearance.barTintColor = UIColor.mup_orangeColor()
        
        let attrs = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        appearance.titleTextAttributes = attrs
        appearance.tintColor = UIColor.whiteColor()
        
        return true 
        
    }
    
    
    
    
    
}
