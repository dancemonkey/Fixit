//
//  CreateNewItemVC.swift
//  Fixit
//
//  Created by Drew Lanning on 8/24/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class CreateNewItemVC: UIViewController {
  
  var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView = UIScrollView(frame: view.bounds)
    scrollView.backgroundColor = UIColor.redColor()
    scrollView.contentSize = contentView.bounds.size
    scrollView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
    scrollView.addSubview(contentView)
    view.addSubview(scrollView)
    
  }
  
}
