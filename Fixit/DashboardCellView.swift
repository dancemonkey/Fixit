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
    let formatter = NSNumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .CurrencyStyle
    formatter.locale = .currentLocale()
    
    Datasource.ds.fetchProjects()
    titleLbls[0].text = String(Datasource.ds.fetchedProjects.count) + " projects" // total # of projects
    titleLbls[1].text = formatter.stringFromNumber(Datasource.ds.fetchTotalDollars()) // dollars
    titleLbls[2].text = String(Datasource.ds.fetchTotalMinutes()) + " min." // minutes
    
  }
  
  func updateTaskView() {
    
  }
  
  func updateShoppingListView() {
    
  }
  
  func updateHitListView() {
    
  }
  
}
