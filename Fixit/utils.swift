//
//  Extensions.swift
//  Fixit
//
//  Created by Drew Lanning on 8/30/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class Utils {
  
  static func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
      deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
      execute: closure
    )
  }
}

protocol SaveDelegateData {
  func saveImage(_ image: UIImage?)
  func saveDate(_ date: Date?)
  func saveProject(_ project: Project)
}

class BottomBorderTextField : UITextField {
  
  override func draw(_ rect: CGRect) {
    
    let startingPoint   = CGPoint(x: rect.minX, y: rect.maxY)
    let endingPoint     = CGPoint(x: rect.maxX, y: rect.maxY)
    
    let path = UIBezierPath()
    
    path.move(to: startingPoint)
    path.addLine(to: endingPoint)
    path.lineWidth = 2.0
    
    tintColor.setStroke()
    
    path.stroke()
  }
}

extension Date {
  func dayOfTheWeek() -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.string(from: self)
  }
}
