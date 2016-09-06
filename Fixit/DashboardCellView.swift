//
//  DashboardCellView.swift
//  Fixit
//
//  Created by Drew Lanning on 8/19/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class DashboardCellView: UIView, UIGestureRecognizerDelegate {
  
  @IBOutlet var titleLbls: [UILabel]!
  
  func updateView(labels: String..., image: UIImage?) {
    
  }
  
  override func awakeFromNib() {

  }

}

extension DashboardCellView {
  
  func updateProjectView() {
    titleLbls[0].text = ""
    titleLbls[1].text = ""
    titleLbls[2].text = ""
    
    let formatter = NSNumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .CurrencyStyle
    formatter.locale = .currentLocale()
    
    Datasource.ds.fetchProjects()
    
    for label in titleLbls {
      if label.tag == 0 {
        label.text = String(Datasource.ds.fetchedProjects.count) + " projects" // total # of projects
      } else if label.tag == 1 {
        label.text = formatter.stringFromNumber(Datasource.ds.fetchTotalDollars()) // dollars
      } else if label.tag == 2 {
        label.text = String(Datasource.ds.fetchTotalDays()) + " days" // minutes
      }
    }
  }
  
  func updateTaskView() {
    Datasource.ds.fetchTasks()
    
    let dueTasks = Datasource.ds.fetchedTasks.filter { (task: Task) -> Bool in
      if task.completed == false {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M/d/y"
        return formatter.stringFromDate(task.dueDate!) == formatter.stringFromDate(NSDate())
      }
      return false
    }
    
    let totalUpcomingTasks = Datasource.ds.fetchedTasks.filter { (task: Task) -> Bool in
      return task.completed == false
    }
    
    let overDueTasks = Datasource.ds.fetchedTasks.filter { (task: Task) -> Bool in
      if task.completed == false {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M/d/y"
        return formatter.stringFromDate(task.dueDate!) < formatter.stringFromDate(NSDate())
      }
      return false
    }
    
    for label in titleLbls {
      if label.tag == 0 {
        label.text = String(totalUpcomingTasks.count) + " tasks" // total # of tasks
      } else if label.tag == 1 {
        label.text = String("Due: " + String(dueTasks.count))
      } else if label.tag == 2 {
        label.text = String("Overdue: " + String(overDueTasks.count))
      }
    }

  }
  
  func updateShoppingListView() {
    
  }
  
  func updateHitListView() {
    
  }
  
}
