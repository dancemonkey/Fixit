//
//  TaskCell.swift
//  Fixit
//
//  Created by Drew Lanning on 9/1/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

enum checkImages: String {
  case Incomplete, Complete // TODO: images for these states on the checkBox button
}

class TaskCell: UITableViewCell {
  
  @IBOutlet weak var checkBoxBtn: UIButton! // TODO: subclass this for a checkbox
  @IBOutlet weak var thumbImg: UIImageView!
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var timeAndCostLbl: UILabel!
  @IBOutlet weak var dueDateLbl: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configureCell(withTask task: Task) {
    // TODO: configure with passed in data
  }
  
}
