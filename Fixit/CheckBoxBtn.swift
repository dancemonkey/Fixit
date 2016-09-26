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
    layer.borderColor = UIColor(red:0.35, green:0.23, blue:0.00, alpha:1.0).cgColor
    layer.masksToBounds = false
  }
  
  func completeTask() {
    Utils.animateButton(self, withTiming: btnAnimTiming) { 
      self.layer.backgroundColor = UIColor(red:0.35, green:0.23, blue:0.00, alpha:1.0).cgColor
    }
  }
  
  func incompleteTask() {
    layer.backgroundColor = UIColor.white.cgColor
  }
  
  override var bounds: CGRect {
    didSet {
      layer.cornerRadius = self.frame.width/2
    }
  }

}
