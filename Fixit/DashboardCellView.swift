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
  let formatter = NumberFormatter()
  
  func updateView(_ labels: String..., image: UIImage?) {
    
  }
  
  override func awakeFromNib() {
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .currency
    formatter.locale = .current
    
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.layer.borderWidth = 1.0
    
    self.layer.cornerRadius = self.frame.width/2
    self.layer.masksToBounds = true
  }
  
}

extension DashboardCellView {
  
  func updateProjectView() {
    titleLbls[0].text = ""
    titleLbls[1].text = ""
    
    Datasource.ds.fetchProjects()
    
    for label in titleLbls {
      if label.tag == 0 {
        label.text = String(Datasource.ds.fetchedProjects.count) // total # of projects
      } else if label.tag == 1 {
        label.text = formatter.string(from: NSNumber(value: Datasource.ds.fetchTotalDollars()))! + ", " + String(Datasource.ds.fetchTotalDays()) + " days" // dollars
      } else if label.tag == 2 {
        label.text = String(Datasource.ds.fetchTotalDays()) + " days" // days
      }
    }
  }
  
  func updateTaskView() {
    
    Datasource.ds.fetchTasks()
    
    titleLbls[0].text = ""
    titleLbls[1].text = ""
    
    let dueTasks = Datasource.ds.fetchedTasks.filter { (task: Task) -> Bool in
      if task.completed == false {
        let formatter = DateFormatter()
        formatter.dateFormat = "m/d/y"
        if let date = task.dueDate {
          return formatter.string(from: date as Date) == formatter.string(from: Date())
        }
      }
      return false
    }
    
    let totalUpcomingTasks = Datasource.ds.fetchedTasks.filter { (task: Task) -> Bool in
      return task.completed == false
    }
    
    for label in titleLbls {
      if label.tag == 0 {
        label.text = String(totalUpcomingTasks.count) // total # of tasks
      } else if label.tag == 1 {
        label.text = String("Due: " + String(dueTasks.count)) + ", " + String("Overdue: " + String(Datasource.ds.fetchOverdueTaskCount()))
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
        label.text = String(shoppingCartTasks.count)
      } else if label.tag == 1 {
        label.text = formatter.string(from: NSNumber(value: shoppingCartValue))
      }
    }
    
  }
  
  func updateHitListView() {
    Datasource.ds.fetchTasks()
    let hitlistTasks = Datasource.ds.fetchedTasks.filter { (task: Task) -> Bool in
      if let time = task.time {
        return time.int32Value < 15 && task.completed != true
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
        label.text = String(hitlistTasks.count)
      } else if label.tag == 1 {
        label.text = String(hitlistTotalTime) + " mins."
      }
    }
  }
  
}
