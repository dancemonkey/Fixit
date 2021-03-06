//
//  MaterialView.swift
//  DecisionsDecisons
//
//  Created by Drew Lanning on 7/23/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

private var materialKey = false
extension UIView {

  @IBInspectable var materialDesign: Bool {
    get  {
      return materialKey
    }
    set {
      materialKey = newValue
      
      if materialKey {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 0
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 2.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowColor = UIColor.black.cgColor
      } else {
        self.layer.cornerRadius = 0
        self.layer.shadowOpacity = 0
        self.layer.shadowRadius = 0
        self.layer.shadowColor = nil
      }
    }
  }

}
