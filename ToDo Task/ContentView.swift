//
//  ContentView.swift
//  ToDo Task
//
//  Created by fai on 04/17/26.
//

import SwiftUI

struct ContentView: View {
    @State private var taskGroups = TaskGroup.sampleData
    @State private var selectedGroup: TaskGroup?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    var totalCompleted: Int { taskGroups.map(\.completedCount).reduce(0, +) }
    var totalPending: Int { taskGroups.map(\.pendingCount).reduce(0, +) }

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // SIDEBAR
            VStack(spacing: 0) {
                // Dashboard stats
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        StatCard(
                            value: "\(totalCompleted)",
                            label: "Completed",
                            color: .green
                        )
                        StatCard(
                            value: "\(totalPending)",
                            label: "Pending",
                            color: .blue
                        )
                    }
                    HStack(spacing: 12) {
                        StatCard(
                            value: "\(taskGroups.count)",
                            label: "Groups",
                            color: .yellow
                        )
                        StatCard(
                            value: "\(totalCompleted + totalPending)",
                            label: "Total Tasks",
                            color: .purple
                        )
                    }
                }
                .padding()

                // Group list
                List(selection: $selectedGroup) {
                    ForEach(taskGroups) { group in
                        NavigationLink(value: group) {
                            HStack(spacing: 12) {
                                Image(systemName: group.symbolName)
                                    .font(.title3)
                                    .foregroundStyle(group.accentColor.vivid)
                                    .frame(width: 32, height: 32)
                                    .background(group.accentColor.light)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(group.title)
                                        .fontWeight(.medium)
                                    Text("\(group.completedCount)/\(group.tasks.count) done")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Text("\(group.pendingCount)")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(group.accentColor.vivid)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(group.accentColor.light)
                                    .clipShape(Capsule())
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .listStyle(.sidebar)
            }
            .navigationTitle("ToDo App")
            .background(Color(.systemGray6).opacity(0.5))
        } detail: {
            if let group = selectedGroup {
                if let index = taskGroups.firstIndex(where: { $0.id == group.id }) {
                    TaskGroupDetailView(groups: $taskGroups[index])
                }
            } else {
                ContentUnavailableView("Select a Group", systemImage: "sidebar.left")
            }
        }
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let value: String
    let label: String
    let color: TaskGroupColor

    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(color.vivid)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(color.light)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
