//
//  Task+CoreDataProperties.swift
//  Fixit
//
//  Created by Drew Lanning on 8/18/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task {

    @NSManaged var title: String?
    @NSManaged var details: String?
    @NSManaged var cost: NSNumber?
    @NSManaged var time: NSNumber?
    @NSManaged var completed: NSNumber?
    @NSManaged var photo: NSSet?
    @NSManaged var parentProject: Project?

}
