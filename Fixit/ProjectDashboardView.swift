//
//  ProjectDashboardView.swift
//  Fixit
//
//  Created by Drew Lanning on 8/28/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class ProjectDashboardView: DashboardCellView {
  
  func updateView() {
    
    titleLbls[0].text = String(Datasource.ds.fetchedProjects.count) + " project"
    
  }
  
  
}
