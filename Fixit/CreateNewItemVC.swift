//
//  CreateNewItemVC.swift
//  Fixit
//
//  Created by Drew Lanning on 8/24/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class CreateNewItemVC: UIViewController, UIScrollViewDelegate {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.delegate = self
    
  }
  
  func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    print("about to scroll")
  }
  
}
