//
//  CheckBoxBtn.swift
//  Fixit
//
//  Created by Drew Lanning on 9/1/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class CheckBoxBtn: UIButton {

  var complete: Bool = false
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func checkBox() {
    if complete == false {
      self.setImage(UIImage(named: "Complete"), forState: .Normal)
      self.imageView?.contentMode = .ScaleAspectFit
      self.complete = true
    } else if complete == true {
      self.complete = false
      self.setImage(nil, forState: .Normal)
    }
  }
  
  func setCompleteImage() {
    if complete {
      self.setImage(UIImage(named: "Complete"), forState: .Normal)
      self.imageView?.contentMode = .ScaleAspectFit
    } else if !complete {
      self.setImage(nil, forState: .Normal)
    }
  }

}
