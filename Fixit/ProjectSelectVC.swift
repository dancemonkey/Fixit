//
//  ProjectSelectVC.swift
//  Fixit
//
//  Created by Drew Lanning on 9/5/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class ProjectSelectVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  var projects: [Project]!
  var delegate: SaveDelegateData!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    Datasource.ds.fetchProjects()
    self.projects = Datasource.ds.fetchedProjects

  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.projects.count
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCellWithIdentifier("listProjectCell") {
      cell.textLabel?.text = projects[indexPath.row].title
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    delegate.saveFromDelegate(projects[indexPath.row])
    self.navigationController?.popViewControllerAnimated(true)
  }
  
}
