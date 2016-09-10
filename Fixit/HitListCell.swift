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
  
  var task: Task!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  func configureCell(withTask task: Task) {
    
    self.task = task
    
    timeLabel.text = ""
    titleLbl.text = ""
    
    if let title = task.title {
      titleLbl.text = title
    }
    if let time = task.time {
      
      timeLabel.text = String(time) + " mins."
    }
  }
  
  @IBAction func boxChecked(sender: CheckBoxBtn) {
    self.task.checkOffTask()
    if task.completed!.boolValue {
      sender.completeTask()
    } else {
      sender.incompleteTask()
    }
  }


}
