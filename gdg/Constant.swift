//
//  ConstantText.swift
//  gdg
//
//  Created by Aaron on 4/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit

public let materialGap: CGFloat = 8
public let redColor = UIColor(red: 237 / 255.0, green: 65 / 255.0, blue: 45 / 255.0, alpha: 1.0)
public let blueColor = UIColor(red: 62 / 255.0, green: 130 / 255.0, blue: 247 / 255.0, alpha: 1.0)
public let greenColor = UIColor(red: 45 / 255.0, green: 169 / 255.0, blue: 79 / 255.0, alpha: 1.0)
public let yellowColor = UIColor(red: 253 / 255.0, green: 189 / 255.0, blue: 0.0, alpha: 1.0)
public let greyColor = UIColor(red: 238 / 255.0, green: 238 / 255.0, blue: 238 / 255.0, alpha: 1.0)
public let darkColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)

public let eventText = "Event"
public let settingText = "Setting"
public let communityText = "Community"


private let urlBase = "http://sightcorner.qiniudn.com/sightcorner/staging/gdg/"
public let urlEventPrefix = urlBase + "event/"
public let urlAvatarPrefix = urlBase + "avatar/"
public let urlAvatarSuffix80 = "?imageView2/2/w/80/h/80/format/jpg/interlace/0/q/80"
public let urlAvatarSuffix368 = "?imageView2/2/w/368/h/368/format/jpg/interlace/0/q/80"

public let heightRatio: CGFloat = 4 / 3
public let communityRation: CGFloat = 6 / 5
