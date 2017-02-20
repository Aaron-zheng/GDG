//
//  CommunityEventViewController.swift
//  gdg
//
//  Created by Aaron on 14/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit

open class CommunityEventViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var countryEntitys = Array<CountryEntity>()
    fileprivate var chapterEntity = ChapterEntity()
    fileprivate var eventEntitys = Array<EventEntity>()
    fileprivate var id: String!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.stopAnimating()
        
        self.tableView.backgroundColor = greyColor
        self.tableView.separatorStyle = .none
        self.tableView.tableHeaderView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(EventTableViewCell.NibObject(), forCellReuseIdentifier: EventTableViewCell.identifier)
        
        self.countryEntitys = CountryParser().prepare()
        self.loadEventTableView(self.id)
    }
    
    open func prepare(_ id: String) {
        self.id = id
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


extension CommunityEventViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = EventDetailViewController.initFromNib() as! EventDetailViewController
        controller.eventEntity = eventEntitys[(indexPath as NSIndexPath).row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension CommunityEventViewController: UITableViewDataSource {
    
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
