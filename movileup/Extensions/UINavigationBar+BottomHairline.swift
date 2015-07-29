//
//  UINavigationBar+BottomHairline.swift
//  movileup
//
//  Created by iOS on 7/28/15.
//  Copyright (c) 2015 movile. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    func hideBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView?.hidden = true
    }
    
    func showBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView?.hidden = false
    }
    
    private func hairlineImageViewInNavigationBar(view: UIView) -> UIImageView? {
        if let imageView = view as? UIImageView where view.bounds.height <= 1.0 {
            return imageView
        }
        
        let subviews = view.subviews as! [UIView]
        for subview in subviews {
            if let imageView = hairlineImageViewInNavigationBar(subview) {
                return imageView
            }
        }
        
        return nil
    }
    
}