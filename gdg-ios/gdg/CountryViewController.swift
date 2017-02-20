//
//  CountryViewController.swift
//  gdg
//
//  Created by Aaron on 7/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit

open class CountryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var countryEntitys = Array<CountryEntity>()
    open var delegate: CountryProtocol!
    fileprivate var countryService = CountryService()
    fileprivate var selectedCountryID: String!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        countryEntitys = CountryParser().prepare()
        self.tableView.backgroundColor = greyColor
        self.tableView.separatorStyle = .singleLine
        self.tableView.tableHeaderView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CountryTableViewCell.NibObject(), forCellReuseIdentifier: CountryTableViewCell.identifier)
        self.selectedCountryID = countryService.getSelectedCountryID()
    }
    
}

extension CountryViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        _ = self.navigationController?.popViewController(animated: true)
        self.delegate.didFinish(countryEntitys[(indexPath as NSIndexPath).row])
    }
}

extension CountryViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryEntitys.count
    }
    
    @objc(tableView:heightForRowAtIndexPath:)
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return materialGap * 6
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identifier, for: indexPath) as! CountryTableViewCell
        cell.prepare(countryEntitys[(indexPath as NSIndexPath).row], selectedCountryID: selectedCountryID)
        return cell
    }
 
}
