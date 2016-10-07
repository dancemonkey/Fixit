//
//  Extensions.swift
//  Fixit
//
//  Created by Drew Lanning on 8/30/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import AVFoundation

let btnAnimTiming: Double = 0.05
class Utils {
  
  static func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
      deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
      execute: closure
    )
  }
  
  static func animateButton(_ view: UIView, withTiming timing: Double, completionClosure: (() -> ())?) {
    UIView.animate(withDuration: timing  ,
                   animations: {
                    view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
      },
                   completion: { finish in
                    UIView.animate(withDuration: timing/2){
                      view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }
                    if let closure = completionClosure {
                      closure()
                    }
    })
  }
}

protocol SaveDelegateData {
  func saveImage(_ image: UIImage?)
  func saveDate(_ date: Date?)
  func saveProject(_ project: Project?)
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

var clickSound: AVAudioPlayer? = nil
extension UIButton {
  override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    
    let path = Bundle.main.path(forResource: "click_04", ofType: "wav")!
    let url = URL(fileURLWithPath: path)
    do {
      let sound = try AVAudioPlayer(contentsOf: url)
      clickSound = sound
      clickSound?.prepareToPlay()
      clickSound?.play()
    } catch {
      print("error playing sound")
    }
  }
}

extension UITableViewCell {
  override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    
    let path = Bundle.main.path(forResource: "click_04", ofType: "wav")!
    let url = URL(fileURLWithPath: path)
    do {
      let sound = try AVAudioPlayer(contentsOf: url)
      clickSound = sound
      clickSound?.prepareToPlay()
      clickSound?.play()
    } catch {
      print("error playing sound")
    }
  }
}

extension Date {
  func dayOfTheWeek() -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.string(from: self)
  }
}
