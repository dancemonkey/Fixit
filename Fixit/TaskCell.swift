//
//  TaskCell.swift
//  Fixit
//
//  Created by Drew Lanning on 9/1/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class TaskCell: UITableViewCell {
  
  @IBOutlet weak var checkBoxBtn: CheckBoxBtn! // TODO: subclass this for a checkbox
  @IBOutlet weak var thumbImg: UIImageView!
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var timeAndCostLbl: UILabel!
  @IBOutlet weak var dueDateLbl: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configureCell(withTask task: Task) {

    if let photo = task.photo?.data {
      thumbImg.image = UIImage(data: photo)
    }
    if let title = task.title {
      titleLbl.text = title
    }
    if let time = task.time, let cost = task.cost {
      
      let formatter = NSNumberFormatter()
      formatter.usesGroupingSeparator = true
      formatter.numberStyle = .CurrencyStyle
      formatter.locale = .currentLocale()

      timeAndCostLbl.text = formatter.stringFromNumber(cost)! + ", " + String(time) + " min."
    }
    if let dueDate = task.dueDate {
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "M/d"
      dueDateLbl.text = dateFormatter.stringFromDate(dueDate)
    }
  }
  
  @IBAction func boxChecked(sender: CheckBoxBtn) {
    sender.checkBox()
    // TODO: when checked
    // - set status of task to complete in model
    // - gray out cell, move to "complete" section
    // - refresh view 
  }
  
}
