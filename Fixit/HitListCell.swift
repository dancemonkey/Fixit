//
//  HitListCell.swift
//  Fixit
//
//  Created by Drew Lanning on 9/9/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class HitListCell: UITableViewCell {

  
  @IBOutlet weak var checkBoxBtn: CheckBoxBtn!
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var projectLbl: UILabel!
  
  var task: Task!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  func configureCell(withTask task: Task) {
    
    self.task = task
    
    timeLabel.text = ""
    titleLbl.text = ""
    checkBoxBtn.incompleteTask()
    
    if let title = task.title {
      titleLbl.text = title
    }
    if let time = task.time {
      timeLabel.text = String(describing: time) + " mins."
    }
    if let project = task.parentProject {
      projectLbl.text = project.title
    } else {
      projectLbl.text = "No Project"
    }
  }
  
  @IBAction func boxChecked(_ sender: CheckBoxBtn) {
    self.task.checkOffTask()
    if task.completed!.boolValue {
      sender.completeTask()
    } else {
      sender.incompleteTask()
    }
  }


}
