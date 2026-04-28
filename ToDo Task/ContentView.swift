//
//  ContentView.swift
//  ToDo Task
//
//  Created by fai on 04/17/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var localeManager: LocaleManager
    @State private var taskGroups = TaskGroup.sampleData
    @State private var selectedGroup: TaskGroup?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var showLanguageSwitcher = false

    var totalCompleted: Int { taskGroups.map(\.completedCount).reduce(0, +) }
    var totalPending: Int { taskGroups.map(\.pendingCount).reduce(0, +) }

    var body: some View {
        let vm = LocaleViewModel(localeManager: localeManager)

        NavigationSplitView(columnVisibility: $columnVisibility) {
            // SIDEBAR
            ScrollView {
                VStack(spacing: 16) {
                    // Welcome banner
                    WelcomeBanner(viewModel: vm)

                    // Dashboard stats
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            StatCard(
                                value: "\(totalCompleted)",
                                label: vm.localized("completed"),
                                color: .green
                            )
                            StatCard(
                                value: "\(totalPending)",
                                label: vm.localized("pending"),
                                color: .blue
                            )
                        }
                        HStack(spacing: 12) {
                            StatCard(
                                value: "\(taskGroups.count)",
                                label: vm.localized("groups"),
                                color: .yellow
                            )
                            StatCard(
                                value: "\(totalCompleted + totalPending)",
                                label: vm.localized("total_tasks"),
                                color: .purple
                            )
                        }
                    }

                    // Group list
                    VStack(spacing: 8) {
                        ForEach(taskGroups) { group in
                            GroupRow(group: group, isSelected: selectedGroup?.id == group.id, vm: vm)
                                .onTapGesture { selectedGroup = group }
                        }
                    }

                    // Locale-specific formats
                    LocaleFormatsView(
                        viewModel: vm,
                        completedTasks: totalCompleted,
                        totalTasks: totalCompleted + totalPending
                    )
                }
                .padding()
            }
            .navigationTitle(vm.localized("app_title"))
            .toolbar {
                Button {
                    showLanguageSwitcher = true
                } label: {
                    Image(systemName: "globe")
                        .font(.body.weight(.medium))
                        .foregroundStyle(TaskGroupColor.blue.vivid)
                }
            }
            .sheet(isPresented: $showLanguageSwitcher) {
                LanguageSwitcherView(viewModel: vm, isPresented: $showLanguageSwitcher)
                    .environment(\.layoutDirection, localeManager.currentLanguage.layoutDirection)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            .background {
                ZStack {
                    Color(.systemGray6).opacity(0.5)
                    if localeManager.currentLanguage == .arabic {
                        ArabicPatternView()
                    }
                }
            }
        } detail: {
            if let group = selectedGroup {
                if let index = taskGroups.firstIndex(where: { $0.id == group.id }) {
                    TaskGroupDetailView(groups: $taskGroups[index])
                        .environmentObject(localeManager)
                }
            } else {
                ContentUnavailableView(
                    vm.localized("select_a_group"),
                    systemImage: "sidebar.left"
                )
            }
        }
    }
}

// MARK: - Welcome Banner

struct WelcomeBanner: View {
    @ObservedObject var viewModel: LocaleViewModel

    private var lang: SupportedLanguage { viewModel.currentLanguage }

    private var localeImage: some View {
        VStack(spacing: 4) {
            Text(lang.flag)
                .font(.system(size: 28))
            Image(systemName: lang.bannerIcon)
                .font(.title3)
                .foregroundStyle(lang.bannerColor.vivid)
        }
        .frame(width: 52, height: 52)
        .background(lang.bannerColor.light.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    var body: some View {
        HStack(spacing: 14) {
            if !viewModel.isRTL {
                localeImage
            }

            VStack(alignment: viewModel.horizontalAlignment, spacing: 4) {
                Text(viewModel.localized("welcome_message"))
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(lang.bannerColor.vivid)
                Text(viewModel.localized("locale_banner_description"))
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                        .foregroundStyle(lang.bannerColor.vivid.opacity(0.7))
                    Text(viewModel.todaysDate)
                        .font(.system(.caption2, design: .rounded, weight: .medium))
                        .foregroundStyle(lang.bannerColor.vivid.opacity(0.8))
                }
                .padding(.top, 1)
            }

            if viewModel.isRTL {
                localeImage
            }
        }
        .frame(maxWidth: .infinity, alignment: viewModel.isRTL ? .trailing : .leading)
        .padding(14)
        .background(lang.bannerColor.light)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Group Row

struct GroupRow: View {
    let group: TaskGroup
    let isSelected: Bool
    let vm: LocaleViewModel

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: group.symbolName)
                .font(.title3)
                .foregroundStyle(group.accentColor.vivid)
                .frame(width: 32, height: 32)
                .background(group.accentColor.light)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: vm.horizontalAlignment, spacing: 2) {
                Text(group.title)
                    .fontWeight(.medium)
                Text(vm.localized("done_count", group.completedCount, group.tasks.count))
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
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? group.accentColor.light.opacity(0.5) : .white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    isSelected ? group.accentColor.vivid.opacity(0.3) : Color(.systemGray5),
                    lineWidth: 1
                )
        )
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
