//
//  LocaleManager.swift
//  ToDo Task
//
//  Created by fai on 04/27/26.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Supported Language

enum SupportedLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case spanish = "es"
    case portuguese = "pt-BR"
    case arabic = "ar"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english:    return "English"
        case .spanish:    return "Español"
        case .portuguese: return "Português"
        case .arabic:     return "العربية"
        }
    }

    var flag: String {
        switch self {
        case .english:    return "🇺🇸"
        case .spanish:    return "🇪🇸"
        case .portuguese: return "🇧🇷"
        case .arabic:     return "🇸🇦"
        }
    }

    var locale: Locale {
        Locale(identifier: rawValue)
    }

    var isRTL: Bool {
        self == .arabic
    }

    var layoutDirection: LayoutDirection {
        isRTL ? .rightToLeft : .leftToRight
    }

    var bannerIcon: String {
        switch self {
        case .english:    return "building.columns.fill"
        case .spanish:    return "sun.max.fill"
        case .portuguese: return "leaf.fill"
        case .arabic:     return "star.and.crescent.fill"
        }
    }

    var bannerColor: TaskGroupColor {
        switch self {
        case .english:    return .blue
        case .spanish:    return .yellow
        case .portuguese: return .green
        case .arabic:     return .teal
        }
    }
}

// MARK: - Locale Manager

class LocaleManager: ObservableObject {
    @Published var currentLanguage: SupportedLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "app_language")
            loadBundle()
        }
    }

    private var localizedBundle: Bundle = .main

    init() {
        let saved = UserDefaults.standard.string(forKey: "app_language") ?? "en"
        self.currentLanguage = SupportedLanguage(rawValue: saved) ?? .english
        loadBundle()
    }

    // MARK: - Bundle Loading

    private func loadBundle() {
        guard let path = Bundle.main.path(forResource: currentLanguage.rawValue, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            localizedBundle = .main
            return
        }
        localizedBundle = bundle
    }

    // MARK: - Localized String Lookup

    func localized(_ key: String) -> String {
        localizedBundle.localizedString(forKey: key, value: nil, table: nil)
    }

    func localized(_ key: String, _ args: CVarArg...) -> String {
        let format = localizedBundle.localizedString(forKey: key, value: nil, table: nil)
        return String(format: format, arguments: args)
    }

    // MARK: - Number Formatting

    func formattedNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = currentLanguage.locale
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }

    func formattedPercentage(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = currentLanguage.locale
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    func formattedCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = currentLanguage.locale
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    // MARK: - Date Formatting

    func formattedDate(_ date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.locale = currentLanguage.locale
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    func formattedTime(_ date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.locale = currentLanguage.locale
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    func formattedDateTime(_ date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.locale = currentLanguage.locale
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
