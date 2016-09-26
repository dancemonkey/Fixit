//
//  DueDatePickerVC.swift
//  Fixit
//
//  Created by Drew Lanning on 9/6/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class DueDatePickerVC: UIViewController {
  
  var delegate: SaveDelegateData!
  var startDate: Date? = nil
  
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var dayOfWeek: UILabel!
  @IBOutlet weak var removeDueDateBtn: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.datePicker.addTarget(self, action: #selector(DueDatePickerVC.datePickerChanged), for: .valueChanged)
    
    removeDueDateBtn.isEnabled = false
    removeDueDateBtn.setTitleColor(.lightGray, for: .normal)
    
    if let date = startDate {
      datePicker.setDate(date, animated: true)
      removeDueDateBtn.isEnabled = true
      removeDueDateBtn.setTitleColor(.red, for: .normal)
    }
    
    dayOfWeek.text = datePicker.date.dayOfTheWeek()
    
  }
  
  func datePickerChanged() {
    dayOfWeek.text = datePicker.date.dayOfTheWeek()
  }
  
  @IBAction func donePressed(_ sender: UIButton) {
    Utils.animateButton(sender, withTiming: btnAnimTiming) {
      self.delegate.saveDate(self.datePicker.date)
      _ = self.navigationController?.popViewController(animated: true)
    }
  }
  
  @IBAction func removeDueDatePressed(_ sender: UIButton) {
    Utils.animateButton(sender, withTiming: btnAnimTiming) {
      self.delegate.saveDate(nil)
      _ = self.navigationController?.popViewController(animated: true)
    }
  }
  
}
