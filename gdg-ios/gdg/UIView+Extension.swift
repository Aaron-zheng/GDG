//
//  UIView+Extension.swift
//  gdg
//
//  Created by Aaron on 6/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /**
     主要用于获取 Cell 的 Nib 对象，用于 registerNib
     */
    class func NibObject() -> UINib {
        let hasNib: Bool = Bundle.main.path(forResource: self.nameOfClass, ofType: "nib") != nil
        guard hasNib else {
            return UINib()
        }
        return UINib(nibName: self.nameOfClass, bundle:nil)
    }
}
