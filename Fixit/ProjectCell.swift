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
    thumbImg.contentMode = .scaleAspectFill
    titleLbl.text = ""
    taskLbl.text = ""
    
//    contentView.backgroundColor = .clear
//    let whiteRoundedView : UIView = UIView(frame: CGRect(x: 5, y: 5, width: self.frame.size.width-10, height: 110))
//    whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
//    whiteRoundedView.layer.masksToBounds = false
//    whiteRoundedView.layer.cornerRadius = 3.0
//    whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
//    whiteRoundedView.layer.shadowOpacity = 0.2
//    contentView.addSubview(whiteRoundedView)
//    contentView.sendSubview(toBack: whiteRoundedView)
    
    let estTimeStub = "Est. time: "
    let estTimeUnitStub = " days"
    
    if let title = project.title {
      self.titleLbl.text = title
    } else {
      self.titleLbl.text = "No title"
    }
    
    if let tasks = project.taskList {
      
      let incompleteTasks = tasks.filter({ (task: Any) -> Bool in
        (task as! Task).completed == false
      })
      self.taskLbl.text = String(incompleteTasks.count)
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
      thumbImg.image = nil
    }
  }
  
}
