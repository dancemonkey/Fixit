//
//  Extensions.swift
//  Fixit
//
//  Created by Drew Lanning on 8/30/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class Utils {
  
  static func delay(delay: Double, closure: ()->()) {
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(),
      closure
    )
  }
}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
  return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
  return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }

protocol SaveDelegateData {
  func saveFromDelegate(data: AnyObject)
}

class BottomBorderTextField : UITextField {
  
  override func drawRect(rect: CGRect) {
    
    let startingPoint   = CGPoint(x: rect.minX, y: rect.maxY)
    let endingPoint     = CGPoint(x: rect.maxX, y: rect.maxY)
    
    let path = UIBezierPath()
    
    path.moveToPoint(startingPoint)
    path.addLineToPoint(endingPoint)
    path.lineWidth = 2.0
    
    tintColor.setStroke()
    
    path.stroke()
  }
}