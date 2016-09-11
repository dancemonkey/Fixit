//
//  Photo.swift
//  Fixit
//
//  Created by Drew Lanning on 8/18/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Foundation
import CoreData


class Photo: NSManagedObject {
  
  override func awakeFromInsert() {
    super.awakeFromInsert()
    self.creationDate = NSDate()
  }

}
