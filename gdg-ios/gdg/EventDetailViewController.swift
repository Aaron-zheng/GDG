//
//  EventDetailViewController.swift
//  gdg
//
//  Created by Aaron on 7/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit

open class EventDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var chapterImageView: UIImageView!
    @IBOutlet weak var chapterNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UIVerticalAlignLabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var participantLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UIVerticalAlignLabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!
    
    var eventEntity: EventEntity?
    
    open override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clear
        self.scrollView.backgroundColor = greyColor
        self.card.layer.cornerRadius = materialGap / 2
        self.prepare(eventEntity!)
        prepareDepth(self.card, depth: .depth1)
    }
    
    
    
    
    open func prepare(_ eventEntity: EventEntity) {
        downloadImage80(eventEntity.chapterID, view: chapterImageView){
            () -> Void in
            self.chapterImageView.image = circleImage(self.chapterImageView.image!)
        }
        self.chapterNameLabel.text = "GDG " + eventEntity.chapterName
        self.titleLabel.text = eventEntity.title
        let textHeight = preCalculateTextHeight(eventEntity.title, font: UIFont(name: "Roboto-Medium", size: 20)!, width: (self.navigationController?.view.frame.width)! - materialGap * 4)
        if floor(textHeight / materialGap / 3) > 1 {
            self.titleLabelHeight.constant = textHeight
        }
        
        self.timeLabel.text = eventEntity.start + " ~ " + eventEntity.end
        if eventEntity.participant != "" {
            self.participantLabel.text = eventEntity.participant + " joined"
        } else {
            self.participantLabel.text = ""
        }
        self.descriptionLabel.text = eventEntity.description.replacingOccurrences(of: "<[^>]+>", with:"", options: .regularExpression, range: nil)
        self.locationLabel.text = eventEntity.location
        
    }

    
}
