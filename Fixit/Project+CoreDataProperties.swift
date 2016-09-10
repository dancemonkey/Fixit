//
//  Project+CoreDataProperties.swift
//  Fixit
//
//  Created by Drew Lanning on 9/9/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Project {

    @NSManaged var complete: NSNumber?
    @NSManaged var completeDate: NSDate?
    @NSManaged var details: String?
    @NSManaged var dueDate: NSDate?
    @NSManaged var estimatedCost: NSNumber?
    @NSManaged var estimatedTime: NSNumber?
    @NSManaged var startDate: NSDate?
    @NSManaged var title: String?
    @NSManaged var photo: Photo?
    @NSManaged var taskList: NSSet?

}
