//
//  Photo+CoreDataProperties.swift
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

extension Photo {

    @NSManaged var creationDate: Date?
    @NSManaged var data: Data?
    @NSManaged var parentProject: Project?
    @NSManaged var parentTask: Task?

}
