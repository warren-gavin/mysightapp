//
//  AppStoreScreenshotsUITests.swift
//  AppStoreScreenshotsUITests
//
//  Created by Warren Gavin on 15/01/2022.
//

import XCTest

func createScreenshot(_ index: Int, _ name: String) {
    snapshot("\(index)-\(name.replacingOccurrences(of: " ", with: "-"))")
}

extension XCUIApplication {
    func snapshot(_ index: Int, _ name: String, in keyPath: KeyPath<XCUIApplication, XCUIElementQuery>) {
        self[keyPath: keyPath][name].tap()
        createScreenshot(index, name)
    }
}

final class AppStoreScreenshotsUITests: XCTestCase {
    func testCreatingScreenshots() throws {
        var snapshotIndex = 1

        // UI tests must launch the application that they test
        let app = XCUIApplication()
        setupSnapshot(app, waitForAnimations: false)

        app.launch()

//        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared.orientation = .landscapeRight
//        }
//        else {
//            XCUIDevice.shared.orientation = .portrait
//        }

        app.buttons["Tritan"].tap()

        let cvdSeveritySlider = app.sliders["cvd severity"]
        cvdSeveritySlider.adjust(toNormalizedSliderPosition: 0.0)
        createScreenshot(snapshotIndex, "normal-color-vision")
        snapshotIndex += 1

        cvdSeveritySlider.adjust(toNormalizedSliderPosition: 1.0)
        createScreenshot(snapshotIndex, "Tritan")
        snapshotIndex += 1

        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared.orientation = .landscapeRight
        }
        else {
            XCUIDevice.shared.orientation = .portrait
        }

        print("--wg-- \(app.buttons)")
        app.buttons["add new profile"].tap()

        let severityAnalysisSlider = app.sliders["severity analysis"]
        severityAnalysisSlider.adjust(toNormalizedSliderPosition: 0.0)

        app.snapshot(snapshotIndex, "next cvd analysis", in: \.buttons)
        snapshotIndex += 1

        app.buttons["next cvd analysis"].tap()
        app.buttons["next cvd analysis"].tap()
        severityAnalysisSlider.adjust(toNormalizedSliderPosition: 0.0)

        while (app.buttons.matching(identifier: "save cvd profile").count == 0) {
            app.buttons["next cvd analysis"].tap()
        }

        app.textFields["save as field"].typeText("James")
        if app.buttons["Continue"].exists {
            app.buttons["Continue"].tap()
        }
        createScreenshot(snapshotIndex, "save-new-profile")
        snapshotIndex += 1

        app.buttons["save cvd profile"].tap()
        createScreenshot(snapshotIndex, "new-profile-view")
        snapshotIndex += 1

        XCUIDevice.shared.orientation = .portrait

        app/*@START_MENU_TOKEN@*/.buttons["select image"]/*[[".buttons[\"photo.on.rectangle.angled\"]",".buttons[\"select image\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.scrollViews.otherElements.images.firstMatch.tap()
        app.buttons["Deutan"].tap()
        app.buttons["James"].tap()
        createScreenshot(snapshotIndex, "low-severity-image")
        snapshotIndex += 1

        cvdSeveritySlider.adjust(toNormalizedSliderPosition: 1.0)
        createScreenshot(snapshotIndex, "high-severity-image")
        snapshotIndex += 1

        app/*@START_MENU_TOKEN@*/.buttons["dismiss"]/*[[".buttons[\"Close\"]",".buttons[\"dismiss\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
}
