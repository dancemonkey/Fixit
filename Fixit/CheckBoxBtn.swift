//
//  CheckBoxBtn.swift
//  Fixit
//
//  Created by Drew Lanning on 9/1/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class CheckBoxBtn: UIButton {

  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func completeTask() {
    self.setImage(UIImage(named: "Complete"), forState: .Normal)
    self.imageView?.contentMode = .ScaleAspectFill
  }
  
  func incompleteTask() {
    self.setImage(nil, forState: .Normal)
  }

}
