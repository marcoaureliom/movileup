//
//  viewDidLoad.swift
//  movileup
//
//  Created by iOS on 7/16/15.
//  Copyright (c) 2015 movile. All rights reserved.
//

//import Foundation

import UIKit

//@UIApplicationMain
class TextView: UIViewController{

    @IBOutlet weak var overviewTextView: UITextView!
override func viewDidLoad(){
    super.viewDidLoad()
    
    overviewTextView.textContainer.lineFragmentPadding = 0
    overviewTextView.textContainerInset = UIEdgeInsetsZero
    
}
}