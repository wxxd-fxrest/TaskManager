//
//  File.swift
//  TaskManager
//
//  Created by 밀가루 on 7/3/24.
//

import SwiftUI

// Task Model
struct Task: Identifiable {
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}
