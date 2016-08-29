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
  @IBOutlet weak var image: UIImage?
  
  func updateView(labels: String..., image: UIImage?) {
    
  }
  
  override func awakeFromNib() {

  }

}

extension DashboardCellView {
  
  func updateProjectView() {
    
    titleLbls[0].text = String(Datasource.ds.fetchedProjects.count) + " project"
    
  }
  
  func updateTaskView() {
    
  }
  
  func updateShoppingListView() {
    
  }
  
  func updateHitListView() {
    
  }
  
}
