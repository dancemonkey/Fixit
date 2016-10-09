//
//  Task+CoreDataClass.swift
//  Fixit
//
//  Created by Drew Lanning on 10/4/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Foundation
import CoreData


public class Task: NSManagedObject {
    
  override public func awakeFromInsert() {
    self.completed = false
    self.shoppingList = false
    self.creationDate = Date()
    self.parentProjectTitle = "No project assigned"
  }
  
  func checkOffTask() {
    if self.completed == true {
      self.completed = false
    } else {
      self.completed = true
    }
    do {
      try appDelegate.managedObjectContext.save()
    } catch {
    }
  }

}
