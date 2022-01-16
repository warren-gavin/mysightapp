//
//  AppStoreScreenshotsUITests.swift
//  AppStoreScreenshotsUITests
//
//  Created by Warren Gavin on 15/01/2022.
//

import XCTest

func createScreenshot(_ name: String) {
    snapshot(name.replacingOccurrences(of: " ", with: "-"))
}

extension XCUIApplication {
    func snapshot(_ name: String, in keyPath: KeyPath<XCUIApplication, XCUIElementQuery>) {
        self[keyPath: keyPath][name].tap()
        createScreenshot(name)
    }
}

class AppStoreScreenshotsUITests: XCTestCase {
    func testCreatingScreenshots() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        setupSnapshot(app)

        app.launch()

        app.snapshot("add new profile", in: \.buttons)
        app.buttons["cancel"].tap()

        app.snapshot("Protan", in: \.buttons)
        app.snapshot("Tritan", in: \.buttons)
        app.snapshot("Deutan", in: \.buttons)

        let cameraViewImage = app.images["camera view"]
        cameraViewImage.tap()
        createScreenshot("no-control-panel")
        cameraViewImage.tap()

        let controlPanelSlider = app.sliders["control panel"]
        controlPanelSlider.swipeLeft()
        controlPanelSlider.swipeLeft()

        app/*@START_MENU_TOKEN@*/.buttons["select image"]/*[[".buttons[\"photo.on.rectangle.angled\"]",".buttons[\"select image\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.scrollViews.otherElements.images["Photo, January 13, 7:41 PM"]/*[[".otherElements[\"Photos\"].scrollViews.otherElements",".otherElements[\"Photo, January 13, 7:41 PM, Photo, March 30, 2018, 8:14 PM, Photo, August 08, 2012, 10:55 PM, Photo, August 08, 2012, 10:29 PM, Photo, August 08, 2012, 7:52 PM, Photo, October 09, 2009, 10:09 PM, Photo, March 13, 2011, 12:17 AM\"].images[\"Photo, January 13, 7:41 PM\"]",".images[\"Photo, January 13, 7:41 PM\"]",".scrollViews.otherElements"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        createScreenshot("low-severity-image")

        controlPanelSlider.swipeRight()
        controlPanelSlider.swipeRight()
        createScreenshot("high-severity-image")

        app/*@START_MENU_TOKEN@*/.buttons["dismiss"]/*[[".buttons[\"Close\"]",".buttons[\"dismiss\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
}
