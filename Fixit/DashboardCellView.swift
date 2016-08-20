//
//  DashboardCellView.swift
//  Fixit
//
//  Created by Drew Lanning on 8/19/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class DashboardCellView: UIView, UIGestureRecognizerDelegate {

  @IBOutlet weak var headingLbl: UILabel!
  @IBOutlet weak var secondHeadingLbl: UILabel!
  @IBOutlet weak var thirdHeadingLbl: UILabel!
  
  
  func updateView(labels: String...) {

    // configure labels with arguments passed in
    
  }
  
  override func awakeFromNib() {

  }

}
