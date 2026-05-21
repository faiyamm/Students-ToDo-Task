//
//  ToDo_TaskTests.swift
//  ToDo TaskTests
//
//  Created by fai on 04/17/26.
//

import XCTest
@testable import ToDo_Task

final class ToDo_TaskTests: XCTestCase {

    // MARK: - Unit Test: Adding a Task

    func testAddingTask() {
        var group = TaskGroup(title: "Shopping", symbolName: "cart", tasks: [])
        group.tasks.append(TaskItem(title: "Buy Groceries"))

        XCTAssertEqual(group.tasks.count, 1)
        XCTAssertEqual(group.tasks[0].title, "Buy Groceries")
    }

    // MARK: - Unit Test: Default Task Values

    func testTaskDefaultValues() {
        let task = TaskItem(title: "New Task")

        XCTAssertFalse(task.isCompleted, "A new task should not be completed by default")
        XCTAssertEqual(task.priority, .medium, "Default priority should be medium")
    }

    // MARK: - Unit Test: Marking a Task as Completed

    func testMarkTaskCompleted() {
        var task = TaskItem(title: "Walk the Dog")
        task.isCompleted = true

        XCTAssertTrue(task.isCompleted, "Task should be marked as completed")
    }

    // MARK: - Unit Test: Sort by Priority

    func testSortByPriority() {
        var group = TaskGroup(title: "Work", symbolName: "briefcase", tasks: [
            TaskItem(title: "Low task", priority: .low),
            TaskItem(title: "High task", priority: .high),
            TaskItem(title: "Medium task", priority: .medium)
        ])

        group.sortByPriority()

        XCTAssertEqual(group.tasks[0].priority, .high, "First task should be high priority")
        XCTAssertEqual(group.tasks[1].priority, .medium, "Second task should be medium priority")
        XCTAssertEqual(group.tasks[2].priority, .low, "Third task should be low priority")
    }

    // MARK: - Unit Test: Pending and Completed Counts

    func testGroupTaskCounts() {
        let group = TaskGroup(title: "Home", symbolName: "house", tasks: [
            TaskItem(title: "Task 1", isCompleted: true),
            TaskItem(title: "Task 2", isCompleted: false),
            TaskItem(title: "Task 3", isCompleted: false)
        ])

        XCTAssertEqual(group.completedCount, 1)
        XCTAssertEqual(group.pendingCount, 2)
    }
}
