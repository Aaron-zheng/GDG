//
//  CommunityViewController.swift
//  gdg
//
//  Created by Aaron on 13/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit

open class CommunityViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var countryEntitys = Array<CountryEntity>()
    fileprivate var chapterEntitys = Array<ChapterEntity>()
    fileprivate var countryService = CountryService()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.countryEntitys = CountryParser().prepare()
        
        self.collectionView.backgroundColor = greyColor
        self.collectionView.contentInset = UIEdgeInsetsMake(materialGap / 2, 0, materialGap / 2, 0)
        self.collectionView.register(CommunityCollectionViewCell.NibObject(), forCellWithReuseIdentifier: CommunityCollectionViewCell.identifier)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.prepare()
        
    }
    
    fileprivate func getName(_ countryID: String) -> String {
        for country in countryEntitys {
            if country.id == countryID {
                return country.name
            }
        }
        return ""
    }
    
    open func prepare() {
        let id = countryService.getSelectedCountryID()
        self.setTitle("GDG " + getName(countryService.getSelectedCountryID()))
        self.prepare(id)
    }
    
    open func prepare(_ countryID: String) {
        for country in countryEntitys {
            if country.id == countryID {
                self.chapterEntitys = country.chapterEntitys
                self.collectionView.reloadData()
            }
        }
    }
    
    
    fileprivate func setTitle(_ title: String) {
        self.title = title
        self.navigationController!.tabBarItem.title = communityText
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        var w: CGFloat = (self.navigationController?.view.frame.width)!
        w = (w - materialGap / 2) / 2
        
        return CGSize(width: w, height: w);
    }
    
    

    
    
}

extension CommunityViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chapterEntitys.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityCollectionViewCell.identifier, for: indexPath) as! CommunityCollectionViewCell
        cell.prepare(chapterEntitys[(indexPath as NSIndexPath).row])
        
        return cell
    }
}

extension CommunityViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        cell.backgroundColor = UIColor(cgColor: CGColor(colorSpace: CGColorSpaceCreateDeviceGray(), components: [0, 0])!)
        let controller = CommunityEventViewController.initFromNib() as! CommunityEventViewController
        controller.prepare(chapterEntitys[(indexPath as NSIndexPath).row].id)
        self.navigationController?.pushViewController(controller, animated: true)
        UIView.animate(withDuration: 0.1, animations: {
            cell.backgroundColor = UIColor.white
        })
        
    }
    
}
