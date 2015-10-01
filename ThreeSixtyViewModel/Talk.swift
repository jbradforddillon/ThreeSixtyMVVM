//
//  Talk.swift
//  360ViewModel
//
//  Created by Brad Dillon on 9/8/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import Foundation
import CoreData

class Talk: NSManagedObject {
    class func withID(ID: String, moc: NSManagedObjectContext) -> Talk {
        let request = NSFetchRequest(entityName: "Talk")
        request.predicate = NSPredicate(format: "identifier = %@", ID)
        
        let results = try! moc.executeFetchRequest(request) as! [Talk]
        
        if results.count > 0 {
            return results.last!
        }
        
        let talk = NSEntityDescription.insertNewObjectForEntityForName("Talk", inManagedObjectContext: moc) as! Talk
        talk.identifier = ID
        
        return talk
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