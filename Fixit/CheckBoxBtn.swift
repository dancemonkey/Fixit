//
//  CheckBoxBtn.swift
//  Fixit
//
//  Created by Drew Lanning on 9/1/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class CheckBoxBtn: UIButton {
  
  private var _doneIndicator: UIView?
  
  var doneIndicator: UIView! {
    get {
      if _doneIndicator == nil {
        let doneInd = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width*0.8, height: self.frame.height*0.8))
        doneInd.center = convert(self.center, from: self.superview)
        doneInd.backgroundColor = UIColor(red:0.35, green:0.23, blue:0.00, alpha:1.0)
        doneInd.layer.cornerRadius = doneInd.frame.width/2
        doneInd.layer.masksToBounds = true
        doneInd.isUserInteractionEnabled = false
        addSubview(doneInd)
        _doneIndicator = doneInd
      }
      return _doneIndicator
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.borderWidth = 1.0
    layer.borderColor = UIColor(red:0.35, green:0.23, blue:0.00, alpha:1.0).cgColor
    layer.masksToBounds = false
  }
  
  func completeTask() {
    Utils.animateButton(self, withTiming: btnAnimTiming) { 
      //self.layer.backgroundColor = UIColor(red:0.35, green:0.23, blue:0.00, alpha:1.0).cgColor
      let _ = self.doneIndicator
    }
  }
  
  func incompleteTask() {
    //layer.backgroundColor = UIColor.white.cgColor
    if _doneIndicator != nil {
      doneIndicator.backgroundColor = UIColor.white
      _doneIndicator = nil
    }
  }
  
  override var bounds: CGRect {
    didSet {
      layer.cornerRadius = self.frame.width/2
    }
  }
  
//  func addDoneIndicator() {
      // CREATE FRAME AFTER ADDING TO UIBUTTON
//    innerCircle = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width * 0.8, height: self.frame.height * 0.8))
//    innerCircle.layer.cornerRadius = (innerCircle.frame.width)/2
//    innerCircle.isUserInteractionEnabled = false
//    innerCircle.layer.masksToBounds = true
//    self.addSubview(innerCircle)
//  }

}
