//
//  Speaker.swift
//  360ViewModel
//
//  Created by Brad Dillon on 9/8/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import Foundation
import CoreData

class Speaker: NSManagedObject {
    class func withID(ID: String, moc: NSManagedObjectContext) -> Speaker {
        let request = NSFetchRequest(entityName: "Speaker")
        request.predicate = NSPredicate(format: "identifier = %@", ID)
        
        let results = try! moc.executeFetchRequest(request) as! [Speaker]
        
        if results.count > 0 {
            return results.last!
        }
        
        let speaker = NSEntityDescription.insertNewObjectForEntityForName("Speaker", inManagedObjectContext: moc) as! Speaker
        speaker.identifier = ID
        
        return speaker
    }
}

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