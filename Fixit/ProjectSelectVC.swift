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
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.projects.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "listProjectCell") {
      cell.textLabel?.text = projects[(indexPath as NSIndexPath).row].title
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate.saveFromDelegate(projects[(indexPath as NSIndexPath).row])
    _ = self.navigationController?.popViewController(animated: true)
  }
  
}
