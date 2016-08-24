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
    
    print(Datasource.ds.fetchedPhotos)
    print(Datasource.ds.fetchedProjects)
    print(Datasource.ds.fetchedTasks)
    
  }
  
}
