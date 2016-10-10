//
//  ViewController.swift
//  Fixit
//
//  Created by Drew Lanning on 8/18/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData
import CircleMenu
import UserNotifications

class DashboardVC: UIViewController, CircleMenuDelegate {
  
  @IBOutlet var dashboardButtons: [UIButton]!
  @IBOutlet weak var projectCell: DashboardCellView!
  @IBOutlet weak var taskCell: DashboardCellView!
  @IBOutlet weak var shoppingListCell: DashboardCellView!
  @IBOutlet weak var hitListCell: DashboardCellView!
  @IBOutlet weak var addNewButton: CircleMenu!
  
  let segueStrings = ["goToProjects","goToTasks","goToShoppingList","goToHitList"]
  var animatedCells: [DashboardCellView]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addNewButton.delegate = self
  
    self.navigationItem.titleView = UIImageView(image: UIImage(named: "Fixit Small White"))
    self.navigationItem.titleView?.contentMode = .scaleAspectFit
    self.navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    projectCell.updateProjectView()
    taskCell.updateTaskView()
    shoppingListCell.updateShoppingListView()
    hitListCell.updateHitListView()
    
    animatedCells = [projectCell, taskCell, shoppingListCell, hitListCell]
  
    updateBadge()
  }
  
  @IBAction func buttonTapped(_ sender: UIButton) {
    
    Utils.animateButton(animatedCells[sender.tag], withTiming: 0.05) {
      self.performSegue(withIdentifier: self.segueStrings[sender.tag], sender: sender)
    }
    
  }
  
  func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
    if atIndex == 0 {
      button.addTarget(self, action: #selector(addProject(_:)), for: .touchUpInside)
      button.setImage(UIImage(named: "ProjectIconSmall"), for: .normal)
      button.backgroundColor = UIColor.init(red: 16/255.0, green: 81/255.0, blue: 165/255.0, alpha: 1.0)
    } else if atIndex == 1 {
      button.addTarget(self, action: #selector(addTask(_:)), for: .touchUpInside)
      button.setImage(UIImage(named: "TaskIconSmall"), for: .normal)
      button.backgroundColor = UIColor.init(red: 16/255.0, green: 81/255.0, blue: 165/255.0, alpha: 1.0)
    }
    
  }
    
  func addProject(_ sender: UIButton) {
    Utils.delay(0.5) {
      self.performSegue(withIdentifier: "newProject", sender: self)
    }
  }
  
  func addTask(_ sender: UIButton) {
    Utils.delay(0.5) { 
      self.performSegue(withIdentifier: "newTask", sender: self)
    }
  }
  
  @IBAction func infoBtnPressed(_ sender: UIButton) {
    let alert = UIAlertController(title: "Attribution", message: "Background graphic created by Akira and is distributed under the Creative Commons Attribution 4.0 license. \n \n Icons were created by Catalin Fertu and are available at https://dribbble.com/shots/1634821-440-Free-Icons. \n\n CircleMenu was created by Ramotion and is released under the MIT license. Source can be found at https://github.com/Ramotion/circle-menu.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
}

extension UIViewController: UNUserNotificationCenterDelegate {
  
  @available(iOS 10.0, *)
  public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
    completionHandler( [.alert, .badge, .sound])
  }
  
  @available(iOS 10.0, *)
  public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
    print("Tapped in notification")
  }
  
  func updateBadge() {
    if #available(iOS 10.0, *) {
      let content = UNMutableNotificationContent()
      content.badge = NSNumber(value: Datasource.ds.fetchDueTaskCount() + Datasource.ds.fetchOverdueTaskCount())
      let request = UNNotificationRequest(identifier: "badgeUpdate", content: content, trigger: nil)
      UNUserNotificationCenter.current().add(request) { error in
        UNUserNotificationCenter.current().delegate = self
        if error != nil {
          print("error in notification")
        }
      }
    } else {
      UIApplication.shared.applicationIconBadgeNumber = Datasource.ds.fetchDueTaskCount() + Datasource.ds.fetchOverdueTaskCount()
    }
  }
  
}


