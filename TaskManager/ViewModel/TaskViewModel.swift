//
//  TaskViewModel.swift
//  TaskManager
//
//  Created by 밀가루 on 7/3/24.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    // Sample Tasks
    @Published var storedTasks: [Task] = [
        Task(taskTitle: "다이어트", taskDescription: "제발 좀 해", taskDate: .init(timeIntervalSince1970: 1700570600)),
        Task(taskTitle: "운동", taskDescription: "아침 조깅", taskDate: .init(timeIntervalSince1970: 1700593200)),
        Task(taskTitle: "공부", taskDescription: "Swift 공부", taskDate: .init(timeIntervalSince1970: 1700596800)),
        Task(taskTitle: "요리", taskDescription: "저녁 준비", taskDate: .init(timeIntervalSince1970: 1700600400)),
        Task(taskTitle: "청소", taskDescription: "집 청소하기", taskDate: .init(timeIntervalSince1970: 1700604000)),
        Task(taskTitle: "독서", taskDescription: "책 읽기", taskDate: .init(timeIntervalSince1970: 1700607600))
    ]
    
    // MARK: - Current Week Days
    @Published var currentWeek: [Date] = []
    
    // MARK: - Current Day
    @Published var currentDay: Date = Date()
    
    // MARK: - Filtering Today Tasks
    @Published var filteredTasks: [Task]?
    
    // MARK: - Intializing
    init() {
        fetchCurrentWeek()
        filterTodayTasks()
    }
    
    // MARK: - Filter Today Tasks
    func filterTodayTasks() {
        DispatchQueue.global(qos: .userInteractive).async {
            let calendar = Calendar.current
            let filtered = self.storedTasks.filter {
                return calendar.isDate($0.taskDate, inSameDayAs: self.currentDay)
            }
                .sorted { task1, task2 in
                    return task2.taskDate < task1.taskDate
                }
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTasks = filtered
                }
            }
        }
    }
    
    func fetchCurrentWeek() {
        let today = Date()
        let calendar = Calendar.current
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (1...7).forEach{ day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
    }
    
    // MARK: - Extracting Date
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    // MARK: - Checking if current Date is Today
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    // MARK: - Checking if the currentHour is task Hour
    func isCurrentHour(date: Date) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        
        return hour == currentHour
    }
}
