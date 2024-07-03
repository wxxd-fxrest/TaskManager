//
//  NewTask.swift
//  TaskManagerApp
//
//  Created by 밀가루 on 7/3/24.
//

import SwiftUI

struct NewTask: View {
    @Environment(\.dismiss) var dismiss
    
    @State var taskTitle: String = ""
    @State var taskDescription: String = ""
    @State var taskDate: Date = Date()
    
    // MARK: - Core Data Context
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var taskModel: TaskViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section{
                    TextField("입력해", text: $taskTitle)
                } header: {
                    Text("제목")
                }
                
                Section{
                    TextField("없어", text: $taskDescription)
                } header: {
                    Text("설명")
                }
                
                // Disabling Date for Edit Mode
                if taskModel.editTask == nil {
                    Section{
                        DatePicker("", selection: $taskDate)
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                    } header: {
                        Text("날짜")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("일정 추가")
            .navigationBarTitleDisplayMode(.inline)
            
            // MARK: - Disbaling Dismiss on Swipe
            .interactiveDismissDisabled()
            
            // MARK: - Action Buttons
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        if let task = taskModel.editTask {
                            task.taskTitle = taskTitle
                            task.taskDescription = taskDescription
                        } else {
                            let task = Task(context: context)
                            task.taskTitle = taskTitle
                            task.taskDescription = taskDescription
                            task.taskDate = taskDate
                        }
                        
                        // Saving
                        try? context.save()
                        
                        // Dismissing View
                        dismiss()
                    }
                    .disabled(taskTitle == "" || taskDescription == "")
                    .foregroundColor(taskTitle == "" || taskDescription == "" ? Color.gray : Color.black)
                    .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                    .foregroundColor(Color.black)
                }
            }
            // Loading Task data
            .onAppear {
                if let task = taskModel.editTask {
                    taskTitle = task.taskTitle ?? ""
                    taskDescription = task.taskDescription ?? ""
                }
            }
        }
    }
}
