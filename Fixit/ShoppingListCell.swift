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
  
  var task: Task!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  func configureCell(withTask task: Task) {
    
    self.task = task
    
    costLbl.text = ""
    titleLbl.text = ""

    if let title = task.title {
      titleLbl.text = title
    }
    if let cost = task.cost {
      
      let formatter = NSNumberFormatter()
      formatter.usesGroupingSeparator = true
      formatter.numberStyle = .CurrencyStyle
      formatter.locale = .currentLocale()
      
      costLbl.text = formatter.stringFromNumber(cost)!
    }
  }
  
  @IBAction func boxChecked(sender: CheckBoxBtn) {
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
