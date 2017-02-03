//
//  UIVerticalAlignLabel.swift
//  gdg
//
//  Created by Aaron on 7/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit


open class UIVerticalAlignLabel: UILabel {
    
    enum VerticalAligment: Int {
        case verticalAligmentTop = 0
        case verticalAligmentMiddle = 1
        case verticalAligmentBottom = 2
    }
    
    
    var verticalAligment: VerticalAligment = .verticalAligmentTop {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        
        switch verticalAligment {
        case .verticalAligmentTop:
            return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
        case .verticalAligmentMiddle:
            return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
        case .verticalAligmentBottom:
            return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
        }
    }
    
    open override func drawText(in rect: CGRect) {
        let r = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: r)
    }
}
