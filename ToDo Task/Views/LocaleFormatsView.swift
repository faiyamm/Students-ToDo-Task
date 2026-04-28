//
//  LocaleFormatsView.swift
//  ToDo Task
//
//  Created by fai on 04/27/26.
//

import SwiftUI

struct LocaleFormatsView: View {
    @ObservedObject var viewModel: LocaleViewModel
    let completedTasks: Int
    let totalTasks: Int

    private var completionRate: Double {
        totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) : 0
    }

    var body: some View {
        VStack(spacing: 10) {
            // Section header
            HStack(spacing: 8) {
                Image(systemName: "textformat.123")
                    .font(.caption)
                    .foregroundStyle(TaskGroupColor.purple.vivid)
                Text(viewModel.localized("locale_formats"))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
                Spacer()
            }

            // Date & Time
            FormatRow(
                icon: "calendar.badge.clock",
                label: viewModel.localized("date_and_time"),
                value: viewModel.formattedDateTime,
                color: .blue
            )

            // Current Time
            FormatRow(
                icon: "clock.fill",
                label: viewModel.localized("current_time"),
                value: viewModel.currentTime,
                color: .green
            )

            // Total tasks as formatted number
            FormatRow(
                icon: "number",
                label: viewModel.localized("total_tasks_count"),
                value: viewModel.formattedNumber(Double(totalTasks)),
                color: .yellow
            )

            // Completion rate as percentage
            FormatRow(
                icon: "chart.pie.fill",
                label: viewModel.localized("completion_rate"),
                value: viewModel.formattedPercentage(completionRate),
                color: .purple
            )
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color(.systemGray5), lineWidth: 1)
        )
    }
}

// MARK: - Format Row

struct FormatRow: View {
    let icon: String
    let label: String
    let value: String
    let color: TaskGroupColor

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color.vivid)
                .frame(width: 20)

            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .font(.system(.caption, design: .rounded, weight: .semibold))
                .foregroundStyle(color.vivid)
        }
        .padding(.vertical, 4)
    }
}
