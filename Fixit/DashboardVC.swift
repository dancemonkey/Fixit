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
    
    // TODO: populate Dasboard Cells with data from fetch
    
  }
  
  @IBAction func buttonTapped(sender: UIButton) {
    performSegueWithIdentifier(segueStrings[sender.tag], sender: sender)
  }
  
  func setCircleMenuButtons() {
    
  }
  
  func circleMenu(circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
    button.addTarget(self, action: #selector(buttonPressedTest(_:)), forControlEvents: .TouchUpInside)
  }
  
  func buttonPressedTest(sender: UIButton) {
    // now have view change based on button pressed
    Utils.delay(0.5) {
      self.performSegueWithIdentifier("newProject", sender: self)
    }
  }
  
}


