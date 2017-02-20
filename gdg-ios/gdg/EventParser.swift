//
//  EventParser.swift
//  gdg
//
//  Created by Aaron on 6/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation

open class EventParser: NSObject {
    fileprivate var currentNodeName: String!
    fileprivate var chapterEntity: ChapterEntity!
    fileprivate var eventEntity: EventEntity!
    fileprivate var eventEntitys: Array<EventEntity>!
    fileprivate var countryEntitys: Array<CountryEntity>!
    
    
    open func prepare(_ id: String, countryEntitys: Array<CountryEntity>, completionHandler: @escaping (_ chapterEntity: ChapterEntity?) -> ()) {
        self.countryEntitys = countryEntitys
        let url: URL = URL(string: urlEventPrefix + id + ".xml?t=" + getCurrentDate())!
        getDataFromUrl(url){(data, response, error) in
            DispatchQueue.main.async {
                () -> Void in
                
                guard let data = data , error == nil else {
                    completionHandler(nil)
                    return
                }
                
                let xmlParser = XMLParser(data: data)
                xmlParser.delegate = self
                let flag = xmlParser.parse()
                if flag {
                    for e in self.chapterEntity.eventEntitys {
                        e.title = self.updateContent(e.title)
                        e.description = self.updateContent(e.description)
                        e.location = self.updateContent(e.location)
                    }
                    completionHandler(self.chapterEntity)
                } else {
                    completionHandler(nil)
                }
            }
        }
    }
    
    open func updateContent(_ content: String) -> String {
        let result = content
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&apos;", with: "'")
            .replacingOccurrences(of: "&quot;", with: "\"")
        return result
    }
    
    open func getName(_ id: String) -> String {
        for countryitem in countryEntitys {
            for chapterEntity in countryitem.chapterEntitys {
                if chapterEntity.id == id {
                    return chapterEntity.name
                }
            }
        }
        return ""
    }
    
}


extension EventParser: XMLParserDelegate {
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        self.currentNodeName = elementName
        if elementName == "events" {
            eventEntitys = Array<EventEntity>()
            chapterEntity = ChapterEntity()
        } else if elementName == "event" {
            eventEntity = EventEntity()
        }
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "events" {
            chapterEntity.eventEntitys = self.eventEntitys
        } else if elementName == "event" {
            eventEntitys.append(eventEntity)
        }
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        let str = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if str.isEmpty {
            return
        }
        
        switch currentNodeName {
        case "title":
            eventEntity.title += str
        case "description":
            eventEntity.description += str
        case "start":
            eventEntity.start += str
        case "end":
            eventEntity.end += str
        case "location":
            eventEntity.location += str
        case "participantscount":
            eventEntity.participant += str
        case "chapterid":
            eventEntity.chapterID += str
            eventEntity.chapterName = getName(eventEntity.chapterID)
        default:
            break
        }
    }
}
