//
//  ProjectCell.swift
//  Fixit
//
//  Created by Drew Lanning on 8/26/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class ProjectCell: UITableViewCell {
  
  @IBOutlet weak var thumbImg: UIImageView!
  @IBOutlet weak var taskLbl: UILabel!
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var estCostLbl: UILabel!
  @IBOutlet weak var estTimeLbl: UILabel!
  @IBOutlet weak var dueDateLbl: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  func configureCell(withProject project: Project) {
    
    estCostLbl.text = ""
    estTimeLbl.text = ""
    dueDateLbl.text = ""
    thumbImg.image = UIImage(named: "Camera")
    titleLbl.text = ""
    taskLbl.text = ""
    
    let estTimeStub = "Est. time: "
    let estTimeUnitStub = " days"
    
    if let title = project.title {
      self.titleLbl.text = title
    } else {
      self.titleLbl.text = "No title"
    }
    
    if let tasks = project.taskList {
      
      //let completedTasks = tasks.filter({ (task: AnyObject) -> Bool in
      //  return (task as? Task)?.completed != true
      //})
      
      var completedTasks = 0
      for task in tasks {
        if ((task as! Task).completed != nil) {
          completedTasks = completedTasks + 1
        }
      }
      self.taskLbl.text = String(completedTasks)
    } else {
      taskLbl.text = "0"
    }
    
    if let estCost = project.estimatedCost {
      let formatter = NumberFormatter()
      formatter.usesGroupingSeparator = true
      formatter.numberStyle = .currency
      formatter.locale = .current
      self.estCostLbl.text = formatter.string(from: estCost)
    } else {
      estCostLbl.text = "No cost estimate"
    }
    
    if let estTime = project.estimatedTime {
      self.estTimeLbl.text = estTimeStub + String(describing: estTime) + estTimeUnitStub
    } else {
      estTimeLbl.text = "No time estimate"
    }
    
    if let dueDate = project.dueDate {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "M/d"
      self.dueDateLbl.text = "due " + dateFormatter.string(from: dueDate as Date)
    } else {
      dueDateLbl.text = "--/--/--"
    }
    
    if let image = project.photo, let data = image.data {
      self.thumbImg.image = UIImage(data: data as Data)
    } else {
      thumbImg.image = UIImage(named: "Camera")
    }
  }
  
}
