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
    print("button \(segueStrings[sender.tag]) tapped")
  }
  
}

