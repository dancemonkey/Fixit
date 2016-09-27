//
//  Datasource.swift
//  Fixit
//
//  Created by Drew Lanning on 8/21/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Foundation
import CoreData

enum fetches: String {
  case Projects = "Project"
  case Tasks = "Task"
  case Photos = "Photo"
}

class Datasource {
  
  static let ds = Datasource()
  
  var fetchedProjects = [Project]()
  var fetchedTasks = [Task]()
  var fetchedPhotos = [Photo]()
  
  func fetchProjects() {
    let fetchReq = NSFetchRequest<Project>(entityName: fetches.Projects.rawValue)
    let sortDesc = NSSortDescriptor(key: "startDate", ascending: true)
    fetchReq.sortDescriptors = [sortDesc]
    
    do {
      let results = try appDelegate.managedObjectContext.fetch(fetchReq)
      self.fetchedProjects = results
    } catch {
      print(error)
    }
  }
  
  func fetchTasks() {
    let fetchReq = NSFetchRequest<Task>(entityName: fetches.Tasks.rawValue)
    let sortDesc = NSSortDescriptor(key: "dueDate", ascending: true)
    fetchReq.sortDescriptors = [sortDesc]
    
    do {
      let results = try appDelegate.managedObjectContext.fetch(fetchReq)
      self.fetchedTasks = results
    } catch {
      print(error)
    }
  }
  
  func fetchOverdueTaskCount() -> Int {
    self.fetchTasks()
    let overdue = self.fetchedTasks.filter { (task) -> Bool in
      if task.completed == false {
        if let date = task.dueDate {
          return Calendar.current.startOfDay(for: date) < Calendar.current.startOfDay(for: Date())
        }
      }
      return false
    }
    return overdue.count
  }
  
  func fetchDueTaskCount() -> Int {
    self.fetchTasks()
    let due = self.fetchedTasks.filter { (task) -> Bool in
      if task.completed == false, let date = task.dueDate {
        return Calendar.current.startOfDay(for: date) == Calendar.current.startOfDay(for: Date())
      }
      return false
    }
    return due.count
  }
  
  func fetchPhotos() {
    let fetchReq = NSFetchRequest<Photo>(entityName: fetches.Photos.rawValue)
    let sortDesc = NSSortDescriptor(key: "creationDate", ascending: true)
    fetchReq.sortDescriptors = [sortDesc]
    
    do {
      let results = try appDelegate.managedObjectContext.fetch(fetchReq)
      self.fetchedPhotos = results
    } catch {
      print(error)
    }
  }
  
  func fetchTotalDollars() -> Double {
    self.fetchProjects()
    
    let newTotal = fetchedProjects.reduce(0.0) { (value: Double, project: Project) -> Double in
      if let cost = project.estimatedCost {
        return cost.doubleValue + value
      }
      return value
    }
    return newTotal
  }
  
  func fetchTotalMinutes() -> Int {
    self.fetchProjects()
    
    let totalTime = fetchedProjects.reduce(0) { (value: Int, project: Project) -> Int in
      if let minutes = project.estimatedTime {
        return Int(minutes.int32Value) + value
      }
      return value
    }
    return totalTime
  }
  
  func fetchTotalDays() -> Double {
    self.fetchProjects()
    
    let totalTime: Double = fetchedProjects.reduce(0.0) { (value: Double, project: Project) -> Double in
      if let minutes = project.estimatedTime {
        return Double(minutes.doubleValue) + value
      }
      return value
    }
    return totalTime
  }
  
}
