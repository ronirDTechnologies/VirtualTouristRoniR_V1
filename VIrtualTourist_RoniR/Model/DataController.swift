//
//  DataController.swift
//  VIrtualTourist_RoniR
//
//  Created by Roni Rozenblat on 6/30/20.
//  Copyright © 2020 dinatech. All rights reserved.
//

import Foundation
import CoreData

/*
 * 1. Hold a persistent container instance
 * 2. To help us load the persistent store
 * 3. To help access the context
 */

class DataController
{
    let persistentContainer: NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName:String)
    {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil)
    {
        persistentContainer.loadPersistentStores{ storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            
        }
            
    }
    
}
