//
//  TaskCell.swift
//  Fixit
//
//  Created by Drew Lanning on 9/1/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class TaskCell: UITableViewCell, TaskCheckboxDelegate {
  
  @IBOutlet weak var checkBoxBtn: CheckBoxBtn! // TODO: subclass this for a checkbox
  @IBOutlet weak var thumbImg: UIImageView!
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var timeAndCostLbl: UILabel!
  @IBOutlet weak var dueDateLbl: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    checkBoxBtn.delegate = self
  }
  
  func configureCell(withTask task: Task) {
    // TODO: configure with passed in data
  }
  
  func boxChecked(sender: UIButton) {
    print("tapped") // TODO: set task to complete or not based on checkbox status, then save context?
  }
  
}
