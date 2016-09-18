//
//  Project.swift
//  Fixit
//
//  Created by Drew Lanning on 8/18/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Foundation
import CoreData


class Project: NSManagedObject {

  override func awakeFromInsert() {
    super.awakeFromInsert()
    self.startDate = Date()
  }
  
}
