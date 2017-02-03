//
//  CountryParser.swift
//  gdg
//
//  Created by Aaron on 6/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation


open class CountryParser: NSObject {
    
    fileprivate var currentNodeName: String!
    fileprivate var countryEntity: CountryEntity!
    fileprivate var chapterEntity: ChapterEntity!
    fileprivate var chapterEntitys = Array<ChapterEntity>()
    fileprivate var countryEntitys = Array<CountryEntity>()
    
    open func prepare() -> Array<CountryEntity>{
        let url: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "chapters", ofType: "xml")!)
        let xmlParser = XMLParser(contentsOf: url)!
        xmlParser.delegate = self
        let flag = xmlParser.parse()
        if flag {
            return self.countryEntitys
        }
        
        return []
    }
}

extension CountryParser: XMLParserDelegate {
    
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        self.currentNodeName = elementName
        if elementName == "country" {
            countryEntity = CountryEntity()
        } else if elementName == "chapters" {
            chapterEntitys = Array<ChapterEntity>()
        } else if elementName == "chapter" {
            chapterEntity = ChapterEntity()
        }
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "country" {
            countryEntitys.append(countryEntity)
        } else if elementName == "chapters" {
            countryEntity.chapterEntitys = chapterEntitys
        } else if elementName == "chapter" {
            chapterEntitys.append(chapterEntity)
        }
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        let str = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if str.isEmpty {
            return
        }
        
        switch currentNodeName {
        case "countryname":
            countryEntity.name += str
        case "countryid":
            countryEntity.id += str
        case "number":
            countryEntity.number += str
        case "chapterid":
            chapterEntity.id += str
        case "city":
            chapterEntity.city += str
        case "chaptername":
            chapterEntity.name += str
        case "firsteventdate" :
            chapterEntity.firstEventDate += str
        default:
            break
        }
    }
}
