//
//  ShoppingListCell.swift
//  Fixit
//
//  Created by Drew Lanning on 9/7/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListCell: UITableViewCell {
  
  @IBOutlet weak var checkBoxBtn: CheckBoxBtn!
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var costLbl: UILabel!
  @IBOutlet weak var projectLbl: UILabel!
  
  var task: Task!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  func configureCell(withTask task: Task) {
    
    self.task = task
    
    costLbl.text = ""
    titleLbl.text = ""
    checkBoxBtn.incompleteTask()
    
    if let title = task.title {
      titleLbl.text = title
    } else {
      titleLbl.text = "No title"
    }
    
    if let cost = task.cost {
      
      let formatter = NumberFormatter()
      formatter.usesGroupingSeparator = true
      formatter.numberStyle = .currency
      formatter.locale = .current
      
      costLbl.text = formatter.string(from: cost)!
    } else {
      costLbl.text = "$0.00"
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
    
    do {
      try appDelegate.managedObjectContext.save()
    } catch {
      print(error)
    }
    
  }
  
}
