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
    let formatter = NSNumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .CurrencyStyle
    formatter.locale = .currentLocale()
    
    Datasource.ds.fetchProjects()
    titleLbls[0].text = String(Datasource.ds.fetchedProjects.count) + " projects" // total # of projects
    titleLbls[1].text = formatter.stringFromNumber(Datasource.ds.fetchTotalDollars()) // dollars
    titleLbls[2].text = String(Datasource.ds.fetchTotalDays()) + " days" // minutes
    
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
    
    titleLbls[0].text = String(totalUpcomingTasks.count) + " tasks" // total # of tasks
    
    let overDueTasks = Datasource.ds.fetchedTasks.filter { (task: Task) -> Bool in
      if task.completed == false {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M/d/y"
        return formatter.stringFromDate(task.dueDate!) < formatter.stringFromDate(NSDate())
      }
      return false
    }
    titleLbls[1].text = String("Due: " + String(dueTasks.count))
    titleLbls[2].text = String("Overdue: " + String(overDueTasks.count))
  }
  
  func updateShoppingListView() {
    
  }
  
  func updateHitListView() {
    
  }
  
}
