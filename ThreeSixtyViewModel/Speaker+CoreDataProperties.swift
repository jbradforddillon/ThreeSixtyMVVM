//
//  Speaker+CoreDataProperties.swift
//  360ViewModel
//
//  Created by Brad Dillon on 9/12/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Speaker {

    @NSManaged var avatarURL: String?
    @NSManaged var bio: String?
    @NSManaged var name: String?
    @NSManaged var identifier: String?
    @NSManaged var talks: NSSet?

}
