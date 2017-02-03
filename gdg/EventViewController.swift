//
//  EventViewController.swift
//  gdg
//
//  Created by Aaron on 4/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit

open class EventViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var countryEntitys = Array<CountryEntity>()
    fileprivate var chapterEntity = ChapterEntity()
    fileprivate var eventEntitys = Array<EventEntity>()
    fileprivate var countryService = CountryService()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.stopAnimating()
        self.navigationItem.rightButtonAction(UIImage(named: "ic_place_white")!){(Void) -> Void in
            let controller = CountryViewController.initFromNib() as! CountryViewController
            controller.delegate = self
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
        self.tableView.backgroundColor = greyColor
        self.tableView.separatorStyle = .none
        self.tableView.tableHeaderView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(EventTableViewCell.NibObject(), forCellReuseIdentifier: EventTableViewCell.identifier)
        
        self.countryEntitys = CountryParser().prepare()
        self.setTitle("GDG " + getName(countryService.getSelectedCountryID()))
        self.loadEventTableView(countryService.getSelectedCountryID())
    }
    
    
    fileprivate func getName(_ countryID: String) -> String {
        for country in countryEntitys {
            if country.id == countryID {
                return country.name
            }
        }
        return ""
    }
    
    fileprivate func setTitle(_ title: String) {
        self.title = title
        self.navigationController!.tabBarItem.title = eventText
    }
    
    fileprivate func loadEventTableView(_ id: String) {
        self.eventEntitys = []
        self.tableView.reloadData()
        self.activityIndicator.startAnimating()
        EventParser().prepare(id, countryEntitys: countryEntitys) { (chapterEntity) in
            if chapterEntity == nil {
                self.eventEntitys = []
            } else {
                self.chapterEntity = chapterEntity!
                self.eventEntitys = chapterEntity!.eventEntitys
            }
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
}


extension EventViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = EventDetailViewController.initFromNib() as! EventDetailViewController
        controller.eventEntity = eventEntitys[(indexPath as NSIndexPath).row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension EventViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventEntitys.count
    }
    
    
    @objc(tableView:heightForRowAtIndexPath:)
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).row == 0 {
            return self.view.frame.width / heightRatio + materialGap * 3
        } else if (indexPath as NSIndexPath).row == eventEntitys.count - 1 {
            return self.view.frame.width / heightRatio + materialGap * 3
        } else {
            return self.view.frame.width / heightRatio + materialGap * 2
        }
        
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier, for: indexPath) as! EventTableViewCell
        cell.prepare(eventEntitys, indexPath: indexPath)
        return cell
    }

}

extension EventViewController: CountryProtocol {
    public func didFinish(_ countryEntity: CountryEntity) {
        self.setTitle("GDG " + countryEntity.name)
        self.loadEventTableView(countryEntity.id)
        countryService.updateSetting(countryEntity.id)
    }
}




extension UINavigationItem {
    
    //right bar
    func rightButtonAction(_ image: UIImage, action: @escaping ActionHandler) {
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(image, for: UIControlState())
        button.frame = CGRect(x: 0, y: 0, width: materialGap * 5, height: materialGap * 5)
        button.imageView!.contentMode = .scaleAspectFit;
        button.contentHorizontalAlignment = .right
        button.addAction(forControlEvents: .touchUpInside, withCallback: {
            action()
        })
        let barButton = UIBarButtonItem(customView: button)
        let gapItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        gapItem.width = -7 //fix the space
        self.rightBarButtonItems = [gapItem, barButton]
    }
}

public typealias ActionHandler = (Void) -> Void

