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
    let estCostStub = "Est. cost: $"
    let estTimeStub = "Est. time: "
    let estTimeUnitStub = " min."
    
    if let title = project.title {
      self.titleLbl.text = title
    }
    if let tasks = project.taskList {
      self.taskLbl.text = String(tasks.count)
    }
    if let estCost = project.estimatedCost {
      self.estCostLbl.text = estCostStub + String(estCost)
    }
    if let estTime = project.estimatedTime {
      self.estTimeLbl.text = estTimeStub + String(estTime) + estTimeUnitStub
    }
    if let dueDate = project.dueDate {
      self.dueDateLbl.text = String(dueDate)
    }
    if let image = project.photo, let data = image.data {
      self.thumbImg.image = UIImage(data: data)
    }
  }
  
}
