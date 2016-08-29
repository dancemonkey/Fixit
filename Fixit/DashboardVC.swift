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
  
  @IBOutlet var dashboardButtons: [UIButton]!
  @IBOutlet weak var projectCell: DashboardCellView!
  @IBOutlet weak var taskCell: DashboardCellView!
  @IBOutlet weak var shoppingListCell: DashboardCellView!
  @IBOutlet weak var hitListCell: DashboardCellView!

  let segueStrings = ["goToProjects","goToTasks","goToShoppingList","goToHitList"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    projectCell.updateProjectView()
    // TODO: populate Dasboard Cells with data from fetch
    
  }
  
  @IBAction func buttonTapped(sender: UIButton) {
    performSegueWithIdentifier(segueStrings[sender.tag], sender: sender)
  }
  
}


