//
//  Parsers.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 10/4/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import CoreData

func speakerFromDictGenerator(moc: NSManagedObjectContext) -> (([String: AnyObject]) -> Speaker) {
    return { (dict) -> Speaker in
        let speaker = Speaker.withID(dict["id"] as! String, moc: moc)
        speaker.identifier = dict["id"] as? String
        speaker.name = dict["name"] as? String
        speaker.bio = dict["bio"] as? String
        speaker.avatarURL = dict["avatarURL"] as? String
        
        if let talks = dict["talks"] as? [String] {
            speaker.talks = NSSet(array: talks.map { Talk.withID($0, moc: moc) })
        }
        
        return speaker
    }
}

func talkFromDictGenerator(moc: NSManagedObjectContext) -> (([String: String]) -> Talk) {
    return { (dict) -> Talk in
        let talk = Talk.withID(dict["id"]!, moc: moc)
        talk.identifier = dict["id"]
        talk.name = dict["name"]
        talk.details = dict["details"]
        talk.location = dict["location"]
        
        if let dateString = dict["date"] {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            talk.date = formatter.dateFromString(dateString)
        }
        
        if let speaker = dict["speaker"] {
            talk.speaker = Speaker.withID(speaker, moc: moc)
        }
        
        return talk
    }
}