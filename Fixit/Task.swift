//
//  Task.swift
//  Fixit
//
//  Created by Drew Lanning on 8/18/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Foundation
import CoreData


class Task: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
  
  override func awakeFromInsert() {
    self.completed = false
    self.shoppingList = false
    self.creationDate = Date()
    self.sectionName = "No project assigned"
  }
  
  func checkOffTask() {
    if self.completed == true {
      self.completed = false
    } else {
      self.completed = true
    }
  }
}
