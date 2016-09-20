//
//  Outline View.swift
//  Fixit
//
//  Created by Drew Lanning on 9/20/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

private var outlineKey = false

extension UIView {
  @IBInspectable var outlineView: Bool {
    get  {
      return outlineKey
    }
    set {
      outlineKey = newValue
      
      if outlineKey {
        self.layer.masksToBounds = true
        self.layer.borderColor =  UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
      } else {
        self.layer.borderWidth = 0.0
      }
    }
  }
}
