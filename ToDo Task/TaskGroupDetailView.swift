//
//  TaskGroupDetailView.swift
//  ToDo Task
//
//  Created by fai on 04/17/26.
//

import SwiftUI

struct TaskGroupDetailView: View {
    @EnvironmentObject var localeManager: LocaleManager
    @Binding var groups: TaskGroup

    var body: some View {
        let vm = LocaleViewModel(localeManager: localeManager)

        ScrollView {
            // Header stats
            HStack(spacing: 12) {
                MiniStat(
                    icon: "checkmark.circle.fill",
                    value: groups.completedCount,
                    label: vm.localized("done"),
                    color: .green
                )
                MiniStat(
                    icon: "circle",
                    value: groups.pendingCount,
                    label: vm.localized("pending"),
                    color: groups.accentColor
                )
            }
            .padding(.horizontal)
            .padding(.top, 8)

            // Group description
            Text(vm.localized("group_description", groups.tasks.count))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(vm.textAlignment)
                .frame(maxWidth: .infinity, alignment: vm.isRTL ? .trailing : .leading)
                .padding(.horizontal)
                .padding(.top, 4)

            // Task list
            LazyVStack(spacing: 8) {
                ForEach($groups.tasks) { $task in
                    TaskRow(task: $task, color: groups.accentColor, placeholder: vm.localized("task_title"))
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)

            // Mark All as Done CTA
            if groups.pendingCount > 0 {
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        for index in groups.tasks.indices {
                            groups.tasks[index].isCompleted = true
                        }
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                        Text(vm.localized("mark_all_done"))
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(14)
                    .foregroundStyle(.white)
                    .background(groups.accentColor.vivid)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
        }
        .background {
            ZStack {
                Color(.systemGray6).opacity(0.3)
                if localeManager.currentLanguage == .arabic {
                    ArabicPatternView()
                }
            }
        }
        .navigationTitle(groups.title)
        .toolbar {
            Button {
                withAnimation {
                    groups.tasks.append(TaskItem(title: ""))
                }
            } label: {
                Label(vm.localized("add_task"), systemImage: "plus.circle.fill")
                    .foregroundStyle(groups.accentColor.vivid)
            }
        }
    }
}

// MARK: - Task Row

struct TaskRow: View {
    @Environment(\.layoutDirection) var layoutDirection
    @Binding var task: TaskItem
    let color: TaskGroupColor
    var placeholder: String = "Task Title"

    private var isRTL: Bool { layoutDirection == .rightToLeft }

    var body: some View {
        HStack(spacing: 12) {
            if !isRTL {
                checkmarkIcon
            }

            TextField(placeholder, text: $task.title)
                .strikethrough(task.isCompleted)
                .foregroundStyle(task.isCompleted ? .secondary : .primary)
                .multilineTextAlignment(isRTL ? .trailing : .leading)

            if isRTL {
                checkmarkIcon
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(task.isCompleted ? color.light.opacity(0.5) : .white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(color.light, lineWidth: 1.5)
        )
    }

    private var checkmarkIcon: some View {
        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
            .font(.title3)
            .foregroundStyle(task.isCompleted ? color.vivid : .gray.opacity(0.4))
            .onTapGesture {
                withAnimation(.spring(response: 0.3)) {
                    task.isCompleted.toggle()
                }
            }
    }
}

// MARK: - Mini Stat

struct MiniStat: View {
    @Environment(\.layoutDirection) var layoutDirection
    let icon: String
    let value: Int
    let label: String
    let color: TaskGroupColor

    private var isRTL: Bool { layoutDirection == .rightToLeft }

    var body: some View {
        HStack(spacing: 10) {
            if !isRTL {
                statIcon
            }

            VStack(alignment: isRTL ? .trailing : .leading, spacing: 2) {
                Text("\(value)")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(color.vivid)
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if isRTL {
                statIcon
            }
        }
        .frame(maxWidth: .infinity, alignment: isRTL ? .trailing : .leading)
        .padding(14)
        .background(color.light)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var statIcon: some View {
        Image(systemName: icon)
            .font(.title2)
            .foregroundStyle(color.vivid)
    }
}
