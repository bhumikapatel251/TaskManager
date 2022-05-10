//
//  TaskViewModel.swift
//  TaskManager
//
//  Created by Bhumika Patel on 10/05/22.
//

import SwiftUI
import CoreData

class TaskViewModel: ObservableObject {
    @Published var currentTab: String = "Today"
    //MARK: New Task Property
    @Published var openEditTask: Bool = false
    @Published var taskTitle: String = ""
    @Published var taskColor: String = "Yellow"
    @Published var taskDeadLine: Date = Date()
    @Published var taskType: String = "Basic"
    
    
}
