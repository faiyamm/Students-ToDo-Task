//
//  TaskModels.swift
//  ToDo Task
//
//  Created by fai on 04/17/26.
//

import Foundation
import SwiftUI

enum TaskPriority: Int, Hashable, CaseIterable, Comparable {
    case high = 0, medium = 1, low = 2

    var label: String {
        switch self {
        case .high:   return "High"
        case .medium: return "Medium"
        case .low:    return "Low"
        }
    }

    var symbolName: String {
        switch self {
        case .high:   return "exclamationmark.3"
        case .medium: return "equal"
        case .low:    return "arrow.down"
        }
    }

    var color: Color {
        switch self {
        case .high:   return Color(.sRGB, red: 0.9, green: 0.25, blue: 0.25)
        case .medium: return Color(.sRGB, red: 0.95, green: 0.6, blue: 0.15)
        case .low:    return Color(.sRGB, red: 0.4, green: 0.6, blue: 0.85)
        }
    }

    static func < (lhs: TaskPriority, rhs: TaskPriority) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

struct TaskItem: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
    var priority: TaskPriority = .medium
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

    mutating func sortByPriority() {
        tasks.sort { $0.priority < $1.priority }
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
            TaskItem(title: "Buy Apples", priority: .low),
            TaskItem(title: "Buy Milk", priority: .medium)
        ], accentColor: .green),

        TaskGroup(title: "Home", symbolName: "house.fill", tasks: [
            TaskItem(title: "Walk the dog", isCompleted: true, priority: .high),
            TaskItem(title: "Clean the kitchen", priority: .medium)
        ], accentColor: .blue),

        TaskGroup(title: "Work", symbolName: "briefcase.fill", tasks: [
            TaskItem(title: "Finish report", isCompleted: true, priority: .high),
            TaskItem(title: "Email team", priority: .low),
            TaskItem(title: "Review PR", priority: .medium)
        ], accentColor: .purple),

        TaskGroup(title: "Personal", symbolName: "person.fill", tasks: [
            TaskItem(title: "Read chapter 5", priority: .low),
            TaskItem(title: "Workout", isCompleted: true, priority: .medium)
        ], accentColor: .yellow)
    ]
}
