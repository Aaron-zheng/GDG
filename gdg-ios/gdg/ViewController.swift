//
//  ViewController.swift
//  gdg
//
//  Created by Aaron on 4/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {
    
    var communityController: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBarStyle()
        self.setupNavigationBarStyle()
        self.setupViewController()
        
    }
    
    fileprivate func setupNavigationBarStyle() {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    fileprivate func setupTabBarStyle() {
        self.tabBar.tintColor = UIColor.white
        self.tabBar.barTintColor = darkColor
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == communityText {
            (communityController as! CommunityViewController).prepare()
        }
    }
    
    fileprivate func setupViewController() {
        var navigationViewController: UINavigationController
        let navigationViewControllerArray = NSMutableArray()
        //event
        let eventController = EventViewController.initFromNib()
        eventController.tabBarItem.title = eventText
        eventController.tabBarItem.image = UIImage(named: "ic_event_white")?.withRenderingMode(.alwaysTemplate)
        eventController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -1 * materialGap / 2)
        navigationViewController = UINavigationController(rootViewController: eventController)
        prepareDepth(navigationViewController.navigationBar, depth: .depth5)
        navigationViewControllerArray.add(navigationViewController)
        
        //community
        communityController = CommunityViewController.initFromNib()
        communityController.tabBarItem.title = communityText
        communityController.tabBarItem.image = UIImage(named: "ic_group_work_white")?.withRenderingMode(.alwaysTemplate)
        communityController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -1 * materialGap / 2)
        navigationViewController = UINavigationController(rootViewController: communityController)
        prepareDepth(navigationViewController.navigationBar, depth: .depth5)
        navigationViewControllerArray.add(navigationViewController)
        
        //setting
        let settingController = SettingViewController.initFromNib()
        settingController.tabBarItem.title = settingText
        settingController.tabBarItem.image = UIImage(named: "ic_settings_white")?.withRenderingMode(.alwaysTemplate)
        settingController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -1 * materialGap / 2)
        navigationViewController = UINavigationController(rootViewController: settingController)
        prepareDepth(navigationViewController.navigationBar, depth: .depth5)
        navigationViewControllerArray.add(navigationViewController)
        
        self.viewControllers = navigationViewControllerArray.mutableCopy() as! [UINavigationController]

//        prepareDepth((self.viewControllers as! [UINavigationController])[0].navigationBar, depth: .Depth2)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

