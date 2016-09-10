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
    checkBoxBtn.incompleteTask()
    thumbImg.image = UIImage(named: "Camera")
    projectLbl.text = ""
    titleLbl.text = ""
    
    
    if self.task.completed?.boolValue == true {
      self.checkBoxBtn.completeTask()
    } else {
      self.checkBoxBtn.incompleteTask()
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
    
    self.task.checkOffTask()
    if task.completed!.boolValue == true {
      sender.completeTask()
      print("complete called by \(self.tag)")
    } else {
      sender.incompleteTask()
      print("incomplete called by \(self.tag)")
    }
    
    do {
      try appDelegate.managedObjectContext.save()
    } catch {
      print("couldn't save - \(error)")
    }

  }
  
}
