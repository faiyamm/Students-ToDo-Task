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

    // MARK: - UI Test: Completing a Task

    func testMarkTaskCompleted() {
        app.launch()

        // Navigate to the Home group (has "Clean the kitchen" pending)
        let homeGroup = app.buttons["group_row_Home"]
        XCTAssertTrue(homeGroup.waitForExistence(timeout: 3.0), "Home group should be visible on the main screen")
        homeGroup.tap()

        // Tap the checkmark button to complete "Clean the kitchen"
        let checkmark = app.buttons["task_checkmark_Clean the kitchen"]
        XCTAssertTrue(checkmark.waitForExistence(timeout: 3.0), "Task checkmark should be visible")
        checkmark.tap()

        // Verify the element still exists (now shows filled checkmark)
        XCTAssertTrue(app.buttons["task_checkmark_Clean the kitchen"].exists, "Task should be marked as completed")
    }

    // MARK: - Integration Test: Adding and Viewing Tasks

    func testAddingAndDisplayingTasks() {
        app.launch()

        // Navigate to the Groceries group
        let groceriesGroup = app.buttons["group_row_Groceries"]
        XCTAssertTrue(groceriesGroup.waitForExistence(timeout: 3.0), "Groceries group should be visible")
        groceriesGroup.tap()

        // Tap the + button to add a new task
        let addButton = app.buttons["add_task_button"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 2.0), "Add task button should be present in the toolbar")

        let fieldCountBefore = app.textFields.count
        addButton.tap()

        // Type in the new empty text field that appeared
        let newField = app.textFields.element(boundBy: fieldCountBefore)
        XCTAssertTrue(newField.waitForExistence(timeout: 2.0), "A new text field should appear after tapping +")
        newField.tap()
        newField.typeText("Walk the Dog")

        // Verify the text was entered correctly
        XCTAssertEqual(newField.value as? String, "Walk the Dog", "New task should show the entered text")
    }
}
