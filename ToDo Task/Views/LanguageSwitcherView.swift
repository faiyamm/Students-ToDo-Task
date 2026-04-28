//
//  LanguageSwitcherView.swift
//  ToDo Task
//
//  Created by fai on 04/27/26.
//

import SwiftUI

struct LanguageSwitcherView: View {
    @ObservedObject var viewModel: LocaleViewModel
    @Binding var isPresented: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Section header
                HStack(spacing: 10) {
                    Image(systemName: "globe")
                        .font(.title2)
                        .foregroundStyle(TaskGroupColor.blue.vivid)
                    Text(viewModel.localized("language"))
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.primary)
                    Spacer()
                }
                .padding(.bottom, 4)

                // Language buttons
                VStack(spacing: 8) {
                    ForEach(viewModel.availableLanguages) { language in
                        LanguageButton(
                            language: language,
                            isSelected: viewModel.currentLanguage == language,
                            localizedName: localizedName(for: language)
                        ) {
                            viewModel.switchLanguage(to: language)
                        }
                    }
                }

                Spacer()
            }
            .padding()
            .background(Color(.systemGray6).opacity(0.3))
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private func localizedName(for language: SupportedLanguage) -> String {
        switch language {
        case .english:    return viewModel.localized("english")
        case .spanish:    return viewModel.localized("spanish")
        case .portuguese: return viewModel.localized("portuguese")
        case .arabic:     return viewModel.localized("arabic")
        }
    }
}

// MARK: - Language Button

struct LanguageButton: View {
    let language: SupportedLanguage
    let isSelected: Bool
    let localizedName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(language.flag)
                    .font(.title2)

                VStack(alignment: .leading, spacing: 2) {
                    Text(localizedName)
                        .font(.system(.body, weight: .medium))
                        .foregroundStyle(isSelected ? TaskGroupColor.blue.vivid : .primary)
                    Text(language.displayName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(TaskGroupColor.blue.vivid)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? TaskGroupColor.blue.light : Color(.systemGray6).opacity(0.5))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        isSelected ? TaskGroupColor.blue.vivid.opacity(0.3) : Color.clear,
                        lineWidth: 1.5
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
