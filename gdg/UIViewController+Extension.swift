//
//  UIViewController+Extension.swift
//  gdg
//
//  Created by Aaron on 4/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /**
     
     - returns: UIViewController
     */
    class func initFromNib() -> UIViewController {
        let hasNib: Bool = Bundle.main.path(forResource: self.nameOfClass, ofType: "nib") != nil
        guard hasNib else {
            return UIViewController()
        }
        return self.init(nibName: self.nameOfClass, bundle: nil)
    }
}
