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