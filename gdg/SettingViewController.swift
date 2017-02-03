//
//  SettingViewController.swift
//  gdg
//
//  Created by Aaron on 4/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit

open class SettingViewController: UIViewController {

    @IBOutlet weak var gdgImageView: UIImageView!
 
    
    open override func viewDidLoad() {
        self.title = settingText
        
        self.gdgImageView.image = circleImage(self.gdgImageView.image!)
    }
}
