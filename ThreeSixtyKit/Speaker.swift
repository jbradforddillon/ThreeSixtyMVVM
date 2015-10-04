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