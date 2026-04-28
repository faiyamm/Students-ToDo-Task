//
//  LocaleViewModel.swift
//  ToDo Task
//
//  Created by fai on 04/27/26.
//

import Foundation
import SwiftUI
import Combine

class LocaleViewModel: ObservableObject {
    @Published var localeManager: LocaleManager

    private var cancellables = Set<AnyCancellable>()

    init(localeManager: LocaleManager) {
        self.localeManager = localeManager

        // Forward changes from LocaleManager to trigger view updates
        localeManager.objectWillChange
            .sink { [weak self] in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    // MARK: - Current State

    var currentLanguage: SupportedLanguage {
        localeManager.currentLanguage
    }

    var availableLanguages: [SupportedLanguage] {
        SupportedLanguage.allCases
    }

    // MARK: - Localized Strings

    func localized(_ key: String) -> String {
        localeManager.localized(key)
    }

    func localized(_ key: String, _ args: CVarArg...) -> String {
        let format = localeManager.localized(key)
        return String(format: format, arguments: args)
    }

    // MARK: - Formatted Date

    var todaysDate: String {
        localeManager.formattedDate()
    }

    var currentTime: String {
        localeManager.formattedTime()
    }

    // MARK: - Formatted Numbers

    func formattedNumber(_ number: Double) -> String {
        localeManager.formattedNumber(number)
    }

    func formattedPercentage(_ value: Double) -> String {
        localeManager.formattedPercentage(value)
    }

    func formattedCurrency(_ value: Double) -> String {
        localeManager.formattedCurrency(value)
    }

    var formattedDateTime: String {
        localeManager.formattedDateTime()
    }

    // MARK: - Actions

    func switchLanguage(to language: SupportedLanguage) {
        withAnimation(.easeInOut(duration: 0.3)) {
            localeManager.currentLanguage = language
        }
    }
}
