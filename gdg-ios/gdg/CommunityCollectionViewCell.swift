//
//  CommunityCollectionViewCell.swift
//  gdg
//
//  Created by Aaron on 13/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit


open class CommunityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var eventCountLabel: UILabel!
    
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = materialGap / 2
        prepareDepth(self, depth: .depth1)
    }
    
    open func prepare(_ chapterEntity: ChapterEntity) {
        
        downloadImage368(chapterEntity.id, view: groupImageView){
            () -> Void in
            self.groupImageView.image = resizeImage(self.groupImageView.image!, newWidth: self.frame.width)
            
            let rect = CGRect(x: 0, y: self.frame.width / 4, width: self.frame.width, height: self.frame.width / 2)
            let ref = (self.groupImageView.image!.cgImage)?.cropping(to: rect)
            self.groupImageView.image = UIImage(cgImage: ref!)
            
        }
        
        titleLabel.text = "GDG " + chapterEntity.name
        locationLabel.text = chapterEntity.city
        eventCountLabel.text = "First event: " + chapterEntity.firstEventDate
        
        
        
    }
    
    
}
