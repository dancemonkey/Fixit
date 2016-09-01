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
  var delegate: TaskCheckboxDelegate!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    if complete {
      self.setImage(UIImage(named: "Complete"), forState: .Normal)
      self.imageView?.contentMode = .ScaleAspectFit
    }
  }
  
  func checkBox() {
    self.complete = !complete
    if complete {
      self.setImage(UIImage(named: "Complete"), forState: .Normal)
      self.imageView?.contentMode = .ScaleAspectFit
    } else if !complete {
      self.imageView!.image = nil
    }
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    delegate.boxChecked(self)
  }

}
