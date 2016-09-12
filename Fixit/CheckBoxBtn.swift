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
    layer.borderWidth = 2.0
    layer.borderColor = UIColor.lightGrayColor().CGColor
    layer.cornerRadius = self.frame.width/2
    layer.masksToBounds = false
  }
  
  func completeTask() {
    self.setImage(UIImage(named: "Complete"), forState: .Normal)
    self.imageView?.contentMode = .ScaleAspectFill
  }
  
  func incompleteTask() {
    self.setImage(nil, forState: .Normal)
  }

}
