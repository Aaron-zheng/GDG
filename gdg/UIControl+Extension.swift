//
//  UIControl+Extension.swift
//  gdg
//
//  Created by Aaron on 5/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit

/*
 Block of UIControl
 */
open class ClosureWrapper : NSObject {
    let _callback : (Void) -> Void
    init(callback : @escaping (Void) -> Void) {
        _callback = callback
    }
    
    open func invoke() {
        _callback()
    }
}


var AssociatedClosure: UInt8 = 0

extension UIControl {
    func addAction(forControlEvents events: UIControlEvents, withCallback callback: @escaping (Void) -> Void) {
        let wrapper = ClosureWrapper(callback: callback)
        addTarget(wrapper, action:#selector(ClosureWrapper.invoke), for: events)
        objc_setAssociatedObject(self, &AssociatedClosure, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
