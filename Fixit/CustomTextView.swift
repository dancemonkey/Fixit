//
//  CustomTextView.swift
//  Fixit
//
//  Created by Drew Lanning on 9/13/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class CustomTextView: UITextView, UITextViewDelegate {
  
  let placeholderText = "Notes"
  let defaultColor = UIColor.black
  let placeholderColor = UIColor.lightGray
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.text = placeholderText
    self.textColor = placeholderColor
    self.isEditable = false
    self.dataDetectorTypes = .all
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CustomTextView.editTextRecognizer))
    self.addGestureRecognizer(tapRecognizer)
    
  }
  
  func editTextRecognizer() {
    self.dataDetectorTypes = []
    self.isEditable = true
    self.becomeFirstResponder()
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    self.isEditable = false
    self.dataDetectorTypes = .all
  }
  
}
