//
//  CountryService.swift
//  gdg
//
//  Created by Aaron on 14/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import CoreData
import UIKit


open class CountryService {
    
    fileprivate let appDelegate: AppDelegate!
    fileprivate let managedContex: NSManagedObjectContext!
    fileprivate let entity: NSEntityDescription
    fileprivate let entityName: String = "CountryEntity"
    
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContex = appDelegate.managedObjectContext
        entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContex)!
        
        if getListItems().count <= 0 {
            createFirstRecord()
        }
    }
    
    open func getSelectedCountryID() -> String {
        return getListItems()[0].value(forKey: "id") as! String
    }

    
    
    open func updateSetting(_ value: String) {
        var listItems: [NSManagedObject] = getListItems()
        let item = listItems[0]
        item.setValue(value, forKey: "id")
        
        do {
            try managedContex.save()
        } catch {
            print("error: updateSetting")
        }
        
    }
    
    fileprivate func createFirstRecord() {
        let item = NSManagedObject(entity: entity, insertInto: managedContex)
        
        let locale = Locale.current.identifier
        let range = locale.lowercased().range(of: "zh")
        if range != nil {
            item.setValue("cn", forKey: "id")
        } else {
            item.setValue("us", forKey: "id")
        }
        
        
        do {
            try managedContex.save()
        } catch {
            print("error: createFirstRecord")
        }
    }
    
    fileprivate func getListItems() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        var listItems: [NSManagedObject] = []
        
        do {
            let result = try managedContex.fetch(fetchRequest)
            listItems = result as! [NSManagedObject]
        } catch {
            print("error: getListItems")
        }
        
        return listItems
    }
    
}
