//
//  NSObject+String.swift
//  gdg
//
//  Created by Aaron on 4/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last! as String
    }
    
    class var identifier: String {
        return String(format: "%@_identifier", self.nameOfClass)
    }
}
