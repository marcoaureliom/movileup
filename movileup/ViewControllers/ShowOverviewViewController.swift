//
//  ShowOverviewViewController.swift
//  movileup
//
//  Created by iOS on 7/27/15.
//  Copyright (c) 2015 movile. All rights reserved.
//

import UIKit

class ShowOverviewViewController: UIViewController, ShowInternalViewController {
    
    @IBOutlet weak var overviewTextView: UITextView!
    var overview:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.overviewTextView.textContainer.lineFragmentPadding = 0
        self.overviewTextView.textContainerInset = UIEdgeInsetsZero
        
        self.overviewTextView.text = overview
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
        println("\(self.dynamicType) deinit")
        
    }
    
    func intrinsicContentSize() -> CGSize {
        
        var overviewHeight = self.overviewTextView.intrinsicContentSize().height + 39
        return CGSize(width: self.view.frame.width, height: overviewHeight)
        
    }
    
}
