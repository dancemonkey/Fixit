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
  let formatter = NSNumberFormatter()
  
  func updateView(labels: String..., image: UIImage?) {
    
  }
  
  override func awakeFromNib() {
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .CurrencyStyle
    formatter.locale = .currentLocale()
  }
  
}

extension DashboardCellView {
  
  func updateProjectView() {
    titleLbls[0].text = ""
    titleLbls[1].text = ""
    titleLbls[2].text = ""
    
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
    
    titleLbls[0].text = ""
    titleLbls[1].text = ""
    titleLbls[2].text = ""
    
    let dueTasks = Datasource.ds.fetchedTasks.filter { (task: Task) -> Bool in
      if task.completed == false {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "m/d/y"
        if let date = task.dueDate {
          return formatter.stringFromDate(date) == formatter.stringFromDate(NSDate())
        }
      }
      return false
    }
    
    let totalUpcomingTasks = Datasource.ds.fetchedTasks.filter { (task: Task) -> Bool in
      return task.completed == false
    }
    
    for label in titleLbls {
      if label.tag == 0 {
        label.text = String(totalUpcomingTasks.count) + " tasks" // total # of tasks
      } else if label.tag == 1 {
        label.text = String("Due: " + String(dueTasks.count))
      } else if label.tag == 2 {
        label.text = String("Overdue: " + String(Datasource.ds.fetchOverdueTaskCount()))
      }
    }
    
  }
  
  func updateShoppingListView() {
    Datasource.ds.fetchTasks()
    
    titleLbls[0].text = ""
    titleLbls[1].text = ""
    
    let shoppingCartTasks = Datasource.ds.fetchedTasks.filter { (task: Task) -> Bool in
      return task.shoppingList!.boolValue && task.completed == false
    }
    let shoppingCartValue = shoppingCartTasks.reduce(0) { (value: Double, task: Task) -> Double in
      if let cost = task.cost {
        return cost.doubleValue + value
      }
      return value
    }
    for label in titleLbls {
      if label.tag == 0 {
        label.text = String(shoppingCartTasks.count) + " items"
      } else if label.tag == 1 {
        label.text = formatter.stringFromNumber(shoppingCartValue)! + " total"
      }
    }
    
  }
  
  func updateHitListView() {
    Datasource.ds.fetchTasks()
    let hitlistTasks = Datasource.ds.fetchedTasks.filter { (task: Task) -> Bool in
      if let time = task.time {
        return time.intValue < 15 && task.completed != true
      }
      return false
    }
    let hitlistTotalTime = hitlistTasks.reduce(0) { (value, task) -> Int in
      return value + Int(task.time!)
    }
    
    titleLbls[0].text = ""
    titleLbls[1].text = ""
    
    for label in titleLbls {
      if label.tag == 0 {
        label.text = String(hitlistTasks.count) + " items"
      } else if label.tag == 1 {
        label.text = String(hitlistTotalTime) + " min. total"
      }
    }
  }
  
}
