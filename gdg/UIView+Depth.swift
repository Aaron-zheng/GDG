//
//  UITableViewCell+Extension.swift
//  gdg
//
//  Created by Aaron on 18/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit



public func prepareDepth(_ view: UIView, depth: MaterialDepth) {
    view.layer.masksToBounds = false
    view.layer.shadowColor = UIColor.gray.cgColor
    view.layer.zPosition = 0
    let value = MaterialDepthToValue(depth)
    view.layer.shadowOffset = value.offset
    view.layer.shadowOpacity = value.opacity
    view.layer.shadowRadius = value.radius
    
}
    
