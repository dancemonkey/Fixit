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
import CircleMenu

class DashboardVC: UIViewController, CircleMenuDelegate {
  
  @IBOutlet var dashboardButtons: [UIButton]!
  @IBOutlet weak var projectCell: DashboardCellView!
  @IBOutlet weak var taskCell: DashboardCellView!
  @IBOutlet weak var shoppingListCell: DashboardCellView!
  @IBOutlet weak var hitListCell: DashboardCellView!
  @IBOutlet weak var addNewButton: CircleMenu!
  
  let segueStrings = ["goToProjects","goToTasks","goToShoppingList","goToHitList"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addNewButton.delegate = self
  
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    projectCell.updateProjectView()
    taskCell.updateTaskView()
    shoppingListCell.updateShoppingListView()
    hitListCell.updateHitListView()
    
    // TODO: populate Dasboard Cells with data from fetch
    
  }
  
  @IBAction func buttonTapped(sender: UIButton) {
    performSegueWithIdentifier(segueStrings[sender.tag], sender: sender)
  }
  
  func setCircleMenuButtons() {
    
  }
  
  func circleMenu(circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
    if atIndex == 0 {
      button.addTarget(self, action: #selector(addProject(_:)), forControlEvents: .TouchUpInside)
      button.setImage(UIImage(named: "ProjectIconSmall"), forState: .Normal)
      button.backgroundColor = UIColor.init(red: 16/255.0, green: 81/255.0, blue: 165/255.0, alpha: 1.0)
    } else if atIndex == 1 {
      button.addTarget(self, action: #selector(addTask(_:)), forControlEvents: .TouchUpInside)
      button.setImage(UIImage(named: "TaskIconSmall"), forState: .Normal)
      button.backgroundColor = UIColor.init(red: 16/255.0, green: 81/255.0, blue: 165/255.0, alpha: 1.0)
    }
    
  }
  
  func addProject(sender: UIButton) {
    Utils.delay(0.5) {
      self.performSegueWithIdentifier("newProject", sender: self)
    }
  }
  
  func addTask(sender: UIButton) {
    Utils.delay(0.5) { 
      self.performSegueWithIdentifier("newTask", sender: self)
    }
  }
  
}


