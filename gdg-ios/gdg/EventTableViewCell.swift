//
//  EventTableViewCell.swift
//  gdg
//
//  Created by Aaron on 6/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit

open class EventTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var cardTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cardBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var chapterImageView: UIImageView!
    @IBOutlet weak var chapterNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var participantLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UIVerticalAlignLabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.card.layer.cornerRadius = materialGap / 2
        prepareDepth(self.card, depth: .depth1)
        
    }
    
    func prepare(_ eventEntity: EventEntity) {
        downloadImage80(eventEntity.chapterID, view: chapterImageView) {
            () -> Void in
            self.chapterImageView.image = circleImage(self.chapterImageView.image!)
        }
        self.chapterNameLabel.text = "GDG " + eventEntity.chapterName
        self.titleLabel.text = eventEntity.title
        self.timeLabel.text = eventEntity.start + " ~ " + eventEntity.end
        if eventEntity.participant != "" {
            self.participantLabel.text = eventEntity.participant + " joined"
        } else {
            self.participantLabel.text = ""
        }
        self.descriptionLabel.text = eventEntity.description.replacingOccurrences(of: "<[^>]+>", with:"", options: .regularExpression, range: nil)
        self.locationLabel.text = eventEntity.location
    }
    
    func prepare(_ eventEntitys: Array<EventEntity>, indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == 0 {
            self.cardTopConstraint.constant = materialGap * 2
        } else if (indexPath as NSIndexPath).row == eventEntitys.count - 1 {
            self.cardBottomConstraint.constant = materialGap * 2
        }
        
        let eventEntity = eventEntitys[(indexPath as NSIndexPath).row]
        prepare(eventEntity)
    }
}
