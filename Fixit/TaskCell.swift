//
//  TaskCell.swift
//  Fixit
//
//  Created by Drew Lanning on 9/1/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData
import pop

class TaskCell: UITableViewCell {
  
  @IBOutlet weak var checkBoxBtn: CheckBoxBtn! 
  @IBOutlet weak var thumbImg: UIImageView!
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var timeAndCostLbl: UILabel!
  @IBOutlet weak var dueDateLbl: UILabel!
  @IBOutlet weak var projectLbl: UILabel!
  @IBOutlet weak var cartIcon: UIImageView!
  
  var task: Task!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configureCell(withTask task: Task) {
    
    self.task = task
    self.cartIcon.isHidden = false

    timeAndCostLbl.text = ""
    dueDateLbl.text = ""
    checkBoxBtn.incompleteTask()
    thumbImg.image = UIImage(named: "Camera")
    thumbImg.contentMode = .scaleAspectFill
    projectLbl.text = ""
    titleLbl.text = ""
    
    contentView.backgroundColor = .clear
    let whiteRoundedView : UIView = UIView(frame: CGRect(x: 5, y: 5, width: self.frame.size.width-10, height: 90))
    whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
    whiteRoundedView.layer.masksToBounds = false
    whiteRoundedView.layer.cornerRadius = 3.0
    whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
    whiteRoundedView.layer.shadowOpacity = 0.2
    contentView.addSubview(whiteRoundedView)
    contentView.sendSubview(toBack: whiteRoundedView)
    
    if self.task.completed?.boolValue == true {
      self.checkBoxBtn.completeTask()
    } else {
      self.checkBoxBtn.incompleteTask()
    }
    
    if let photo = task.photo?.data {
      thumbImg.image = UIImage(data: photo as Data)
    } else {
      thumbImg.image = UIImage(named: "Camera")
    }
    
    if let title = task.title {
      titleLbl.text = title
    } else {
      titleLbl.text = "No title"
    }
    
    if let time = task.time, let cost = task.cost {
      let formatter = NumberFormatter()
      formatter.usesGroupingSeparator = true
      formatter.numberStyle = .currency
      formatter.locale = .current

      timeAndCostLbl.text = formatter.string(from: cost)! + ", " + String(describing: time) + " min."
    } else {
      timeAndCostLbl.text = ""
    }
    
    if let dueDate = task.dueDate {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "M/d"
      dueDateLbl.text = dateFormatter.string(from: dueDate as Date)
    } else {
      dueDateLbl.text = "--/--"
    }
    
    if let project = task.parentProject {
      projectLbl.text = project.title
    } else {
      projectLbl.text = "No project assigned"
    }
    
    if let cart = task.shoppingList?.boolValue {
      self.cartIcon.isHidden = !cart
    }
  }
  
  @IBAction func boxChecked(_ sender: CheckBoxBtn) {
    
    self.task.checkOffTask()
    if task.completed!.boolValue == true {
      sender.completeTask()
    } else {
      sender.incompleteTask()
    }
  }
  
}
