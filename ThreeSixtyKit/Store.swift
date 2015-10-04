//
//  Store.swift
//  360ViewModel
//
//  Created by Brad Dillon on 9/12/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import CoreData

public class Store {
    public init() {
    }
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle(identifier: "com.possiblemobile.ThreeSixtyKit")!.URLForResource("ThreeSixtyViewModel", withExtension: "mom")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        try! coordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}