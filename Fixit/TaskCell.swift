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
  
  @IBOutlet weak var checkBoxBtn: CheckBoxBtn! 
  @IBOutlet weak var thumbImg: UIImageView!
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var timeAndCostLbl: UILabel!
  @IBOutlet weak var dueDateLbl: UILabel!
  @IBOutlet weak var projectLbl: UILabel!
  
  var task: Task!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configureCell(withTask task: Task) {
    
    self.task = task 

    timeAndCostLbl.text = ""
    dueDateLbl.text = ""
    
    if let complete = self.task.completed {
      self.checkBoxBtn.complete = complete.boolValue
      self.checkBoxBtn.setCompleteImage()
    } else {
      self.checkBoxBtn.complete = false
      self.checkBoxBtn.setCompleteImage()
    }
    
    if let photo = task.photo?.data {
      thumbImg.image = UIImage(data: photo)
    } else {
      thumbImg.image = UIImage(named: "Camera")
    }
    
    if let title = task.title {
      titleLbl.text = title
    } else {
      titleLbl.text = "No title"
    }
    
    if let time = task.time, let cost = task.cost {
      
      let formatter = NSNumberFormatter()
      formatter.usesGroupingSeparator = true
      formatter.numberStyle = .CurrencyStyle
      formatter.locale = .currentLocale()

      timeAndCostLbl.text = formatter.stringFromNumber(cost)! + ", " + String(time) + " min."
    } else {
      timeAndCostLbl.text = ""
    }
    
    if let dueDate = task.dueDate {
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "M/d"
      dueDateLbl.text = dateFormatter.stringFromDate(dueDate)
    } else {
      dueDateLbl.text = "-/-"
    }
    
    if let project = task.parentProject {
      projectLbl.text = project.title
    } else {
      projectLbl.text = "No project assigned"
    }
  }
  
  @IBAction func boxChecked(sender: CheckBoxBtn) {
    
    sender.checkBox()
    self.task.checkOffTask()
    
    // TODO: when checked
    // - set status of task to complete in model
    // - gray out cell, move to "complete" section
    // - refresh view 
  }
  
}
