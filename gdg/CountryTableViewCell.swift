//
//  CountryTableViewCell.swift
//  gdg
//
//  Created by Aaron on 7/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit

open class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var chapterLabel: UILabel!
    @IBOutlet weak var pinImageView: UIImageView!
    
    func prepare(_ countryEntity: CountryEntity, selectedCountryID: String) {
        pinImageView.image = UIImage(named: "ic_chevron_right_white")!.withRenderingMode(.alwaysTemplate)
        if countryEntity.id == selectedCountryID {
            self.tintColor = UIColor.white
        } else {
            self.tintColor = greyColor
        }
        countryLabel.text = countryEntity.name
        var gdgText: String = ""
        
        for chapter in countryEntity.chapterEntitys {
            if gdgText.characters.count + chapter.name.characters.count > 25 {
                gdgText += "..."
                break
            }
            
            if gdgText != "" {
                gdgText += ", "
            }
            
            gdgText += chapter.name
        }
        gdgText = countryEntity.number + " GDGs: " + gdgText
        chapterLabel.text = gdgText
    }
}
