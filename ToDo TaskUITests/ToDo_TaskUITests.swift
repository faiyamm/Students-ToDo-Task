//
//  ToDo_TaskUITests.swift
//  ToDo TaskUITests
//
//  Created by fai on 04/17/26.
//

import XCTest

final class ToDo_TaskUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    // Start the name with the word 'test'
    // validateTaskCompletedTest -> Incorrect
    // testValidateTaskCompleted -> Correct

    func testLaunchEnglish() {
        app.launchArguments = ["-AppleLanguages", "(en)"]
        app.launch()

        // search for the accesibility ID of that text
        let header = app.staticTexts["Welcome_text_subtitle"]

        // verify that the text is shown in the correct language
        XCTAssertTrue(header.exists, "The text is not found in English")
    }

    func testLaunchSpanish() {
        app.launchArguments = ["-AppleLanguages", "(es)"]
        app.launch()

        let header = app.staticTexts["Welcome_text_subtitle"]

        XCTAssertTrue(header.exists, "The text is not found in Spanish")
    }

    func testLaunchPortuguese() {
        app.launchArguments = ["-AppleLanguages", "(pt-BR)"]
        app.launch()

        let header = app.staticTexts["Welcome_text_subtitle"]

        XCTAssertTrue(header.exists, "The text is not found in Portuguese")
    }

    func testLaunchArabic() {
        app.launchArguments = ["-AppleLanguages", "(ar)"]
        app.launch()

        let header = app.staticTexts["Welcome_text_subtitle"]

        XCTAssertTrue(header.exists, "The text is not found in Arabic")
    }

    func testWelcomeTitleExists() {
        app.launch()

        let title = app.staticTexts["Welcome_text_title"]

        XCTAssertTrue(title.exists, "Welcome title should be visible on launch")
    }

    func testLanguageSwitcherButtonExists() {
        app.launch()

        let globeButton = app.buttons["Language_switcher_button"]

        XCTAssertTrue(globeButton.exists, "Language switcher button should be visible")
    }
}
