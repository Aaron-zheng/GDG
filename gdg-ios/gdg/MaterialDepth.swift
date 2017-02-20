//
//  MaterialDepth.swift
//  gdg
//
//  Created by Aaron on 18/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit

public typealias MaterialDepthType = (offset: CGSize, opacity: Float, radius: CGFloat)

public enum MaterialDepth {
    case none
    case depth1
    case depth2
    case depth3
    case depth4
    case depth5
}

/// Converts the MaterialDepth enum to a MaterialDepthType value.
public func MaterialDepthToValue(_ depth: MaterialDepth) -> MaterialDepthType {
    switch depth {
    case .none:
        return (offset: CGSize.zero, opacity: 0, radius: 0)
    case .depth1:
        return (offset: CGSize(width: 0, height: 1), opacity: 0.3, radius: 1)
    case .depth2:
        return (offset: CGSize(width: 0, height: 2), opacity: 0.3, radius: 2)
    case .depth3:
        return (offset: CGSize(width: 0, height: 3), opacity: 0.3, radius: 3)
    case .depth4:
        return (offset: CGSize(width: 0, height: 4), opacity: 0.3, radius: 4)
    case .depth5:
        return (offset: CGSize(width: 0, height: 5), opacity: 0.3, radius: 5)
    }
}
