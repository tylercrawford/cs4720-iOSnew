//
//  Item+CoreDataProperties.swift
//  UVAThingsToDo
//
//  Created by Tyler Crawford on 11/2/15.
//  Copyright © 2015 Scott Mallory. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var item_title: String?
    @NSManaged var item_description: String?
    @NSManaged var item_completed: NSNumber?
    @NSManaged var item_date: NSDate?
    @NSManaged var item_latitude: NSNumber?
    @NSManaged var item_longitude: NSNumber?
    @NSManaged var item_image: NSData?

}
