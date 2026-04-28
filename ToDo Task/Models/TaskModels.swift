//
//  TaskModels.swift
//  ToDo Task
//
//  Created by fai on 04/17/26.
//

import Foundation
import SwiftUI

struct TaskItem: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
}

struct TaskGroup: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var symbolName: String
    var tasks: [TaskItem]
    var accentColor: TaskGroupColor = .green

    var completedCount: Int {
        tasks.filter(\.isCompleted).count
    }
    var pendingCount: Int {
        tasks.count - completedCount
    }
}

enum TaskGroupColor: String, Hashable, CaseIterable {
    case green, blue, yellow, purple, teal

    var light: Color {
        switch self {
        case .green:  return Color(.sRGB, red: 0.85, green: 0.95, blue: 0.85)
        case .blue:   return Color(.sRGB, red: 0.85, green: 0.92, blue: 1.0)
        case .yellow: return Color(.sRGB, red: 1.0, green: 0.95, blue: 0.85)
        case .purple: return Color(.sRGB, red: 0.91, green: 0.87, blue: 1.0)
        case .teal:   return Color(.sRGB, red: 0.85, green: 0.95, blue: 0.95)
        }
    }

    var vivid: Color {
        switch self {
        case .green:  return Color(.sRGB, red: 0.2, green: 0.7, blue: 0.3)
        case .blue:   return Color(.sRGB, red: 0.2, green: 0.5, blue: 0.9)
        case .yellow: return Color(.sRGB, red: 0.85, green: 0.65, blue: 0.15)
        case .purple: return Color(.sRGB, red: 0.5, green: 0.2, blue: 0.9)
        case .teal:   return Color(.sRGB, red: 0.0, green: 0.6, blue: 0.6)
        }
    }
}


// MOCK DATA
extension TaskGroup {
    static let sampleData: [TaskGroup] = [
        TaskGroup(title: "Groceries", symbolName: "storefront.circle.fill", tasks: [
            TaskItem(title: "Buy Apples"),
            TaskItem(title: "Buy Milk")
        ], accentColor: .green),

        TaskGroup(title: "Home", symbolName: "house.fill", tasks: [
            TaskItem(title: "Walk the dog", isCompleted: true),
            TaskItem(title: "Clean the kitchen")
        ], accentColor: .blue),

        TaskGroup(title: "Work", symbolName: "briefcase.fill", tasks: [
            TaskItem(title: "Finish report", isCompleted: true),
            TaskItem(title: "Email team"),
            TaskItem(title: "Review PR")
        ], accentColor: .purple),

        TaskGroup(title: "Personal", symbolName: "person.fill", tasks: [
            TaskItem(title: "Read chapter 5"),
            TaskItem(title: "Workout", isCompleted: true)
        ], accentColor: .yellow)
    ]
}
