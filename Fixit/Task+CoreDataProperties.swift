//
//  Task+CoreDataProperties.swift
//  Fixit
//
//  Created by Drew Lanning on 9/5/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task {

    @NSManaged var completed: NSNumber?
    @NSManaged var cost: NSNumber?
    @NSManaged var details: String?
    @NSManaged var dueDate: NSDate?
    @NSManaged var time: NSNumber?
    @NSManaged var title: String?
    @NSManaged var shoppingList: NSNumber?
    @NSManaged var parentProject: Project?
    @NSManaged var photo: Photo?

}
