//
//  ViewController.swift
//  Fixit
//
//  Created by Drew Lanning on 8/18/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData
import pop

class DashboardVC: UIViewController {
  
  @IBOutlet var dashboardViews: [DashboardCellView]!
  @IBOutlet var dashboardButtons: [UIButton]!
  let segueStrings = ["goToProjects","goToTasks","goToShoppingList","goToHitList"]

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func buttonTapped(sender: UIButton) {
    performSegueWithIdentifier(segueStrings[sender.tag], sender: sender)
  }
  
  func testDataFetch() {

    Datasource.ds.fetchPhotos()
    Datasource.ds.fetchTasks()
    Datasource.ds.fetchProjects()
    
    for project in Datasource.ds.fetchedProjects {
      print(project.title)
      print(project.details)
      print(project.dueDate)
      print(project.estimatedCost)
      print(project.estimatedTime)
    }
    
    for task in Datasource.ds.fetchedTasks {
      print(task.title)
      print(task.details)
      print(task.dueDate)
      print(task.cost)
      print(task.time)
    }
    
  }
  
}

