//
//  Talk+CoreDataProperties.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 10/4/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Talk {

    @NSManaged var date: NSDate?
    @NSManaged var name: String?
    @NSManaged var details: String?
    @NSManaged var location: String?
    @NSManaged var identifier: String?
    @NSManaged var speaker: Speaker?

}
