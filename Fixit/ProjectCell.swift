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
    
    let estTimeStub = "Est. time: "
    let estTimeUnitStub = " days"
    
    if let title = project.title {
      self.titleLbl.text = title
    }
    if let tasks = project.taskList {
      let completedTasks = tasks.filter({ (task: AnyObject) -> Bool in
        return (task as? Task)?.completed != true
      })
      self.taskLbl.text = String(completedTasks.count)
    }
    if let estCost = project.estimatedCost {
      let formatter = NSNumberFormatter()
      formatter.usesGroupingSeparator = true
      formatter.numberStyle = .CurrencyStyle
      formatter.locale = .currentLocale()
      self.estCostLbl.text = formatter.stringFromNumber(estCost)
    }
    if let estTime = project.estimatedTime {
      self.estTimeLbl.text = estTimeStub + String(estTime) + estTimeUnitStub
    }
    if let dueDate = project.dueDate {
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "M/d"
      self.dueDateLbl.text = "due " + dateFormatter.stringFromDate(dueDate)
    }
    if let image = project.photo, let data = image.data {
      self.thumbImg.image = UIImage(data: data)
    }
  }
  
}
