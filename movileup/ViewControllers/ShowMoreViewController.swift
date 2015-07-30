//
//  ShowMoreViewController.swift
//  movileup
//
//  Created by iOS on 7/26/15.
//  Copyright (c) 2015 movile. All rights reserved.
//

import UIKit
import TraktModels

class ShowMoreViewController: UIViewController {
    
    @IBOutlet weak var detailsTextView: UITextView!
    var show:Show?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDetails()
    }
    
    deinit {
        
        println("\(self.dynamicType) deinit")
        
    }
    
    func loadDetails() {
        
        var showDetails:String = ""
        
        if let broadcasting = self.show?.network {
            showDetails += "Broadcasting: \(broadcasting)"
        }
        
        if let status:ShowStatus = self.show?.status {
            showDetails += "\nStatus: \(status.rawValue)"
        }
        
        //Criar a formatação da data
        if let startedIn = self.show?.firstAired {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy"
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            
            let year = formatter.stringFromDate(startedIn) as String
            
            showDetails += "\nStarted in: \(year)"
        }
        
        
    
        if let country = self.show?.country {
            showDetails += "\nCountry: \(country.uppercaseString)"
        }
        
        self.detailsTextView.text = showDetails
    }
    
    //Ajustar tamanho
    func intrinsicContentSize() -> CGSize {
        
        var overviewHeight = self.detailsTextView.intrinsicContentSize().height + 39
        return CGSize(width: self.view.frame.width, height: overviewHeight)
        
    }
    
    
}
