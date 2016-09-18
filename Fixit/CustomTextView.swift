//
//  CustomTextView.swift
//  Fixit
//
//  Created by Drew Lanning on 9/13/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {
  
  let placeholderText = "More details"
  let defaultColor = UIColor.black
  let placeholderColor = UIColor.lightGray
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.text = placeholderText
    self.textColor = placeholderColor
  }
  
}
