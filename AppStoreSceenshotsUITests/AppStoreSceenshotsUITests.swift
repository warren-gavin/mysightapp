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

class AppStoreScreenshotsUITests: XCTestCase {
    func testCreatingScreenshots() throws {
        // UI tests must launch the application that they test
        let app = XCUIApplication()
        setupSnapshot(app)

        app.launch()

        XCUIDevice.shared.orientation = .landscapeLeft
        XCUIDevice.shared.orientation = .portrait

        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared.orientation = .landscapeLeft
        }

        app.buttons["Tritan"].tap()

        let cvdSeveritySlider = app.sliders["cvd severity"]
        cvdSeveritySlider.adjust(toNormalizedSliderPosition: 0.0)
        createScreenshot(1, "normal-color-vision")

        cvdSeveritySlider.adjust(toNormalizedSliderPosition: 1.0)
        createScreenshot(2, "Tritan")

        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared.orientation = .landscapeLeft
        }

        app.buttons["add new profile"].tap()

        let severityAnalysisSlider = app.sliders["severity analysis"]
        severityAnalysisSlider.adjust(toNormalizedSliderPosition: 0.0)

        app.snapshot(3, "next cvd analysis", in: \.buttons)

        app.buttons["next cvd analysis"].tap()
        app.buttons["next cvd analysis"].tap()
        severityAnalysisSlider.adjust(toNormalizedSliderPosition: 0.0)

        while (app.buttons.matching(identifier: "save cvd profile").count == 0) {
            app.buttons["next cvd analysis"].tap()
        }

        app.textFields["save as field"].typeText("James")
        createScreenshot(4, "save-new-profile")

        app.buttons["save cvd profile"].tap()
        createScreenshot(5, "new-profile-view")

        XCUIDevice.shared.orientation = .portrait

        app/*@START_MENU_TOKEN@*/.buttons["select image"]/*[[".buttons[\"photo.on.rectangle.angled\"]",".buttons[\"select image\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.scrollViews.otherElements.images["Photo, January 13, 7:41 PM"]/*[[".otherElements[\"Photos\"].scrollViews.otherElements",".otherElements[\"Photo, January 13, 7:41 PM, Photo, March 30, 2018, 8:14 PM, Photo, August 08, 2012, 10:55 PM, Photo, August 08, 2012, 10:29 PM, Photo, August 08, 2012, 7:52 PM, Photo, October 09, 2009, 10:09 PM, Photo, March 13, 2011, 12:17 AM\"].images[\"Photo, January 13, 7:41 PM\"]",".images[\"Photo, January 13, 7:41 PM\"]",".scrollViews.otherElements"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Deutan"].tap()
        app.buttons["James"].tap()
        createScreenshot(6, "low-severity-image")

        cvdSeveritySlider.adjust(toNormalizedSliderPosition: 1.0)
        createScreenshot(7, "high-severity-image")

        app/*@START_MENU_TOKEN@*/.buttons["dismiss"]/*[[".buttons[\"Close\"]",".buttons[\"dismiss\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
}
