//
//  CreditScoreUITests.swift
//  CreditScoreUITests
//
//  Created by Nur Ismail on 2020/03/03.
//  Copyright © 2020 NMI. All rights reserved.
//

import XCTest

extension XCUIApplication {
    
    var isDisplayingDashboard: Bool {
        return otherElements["dashboardView"].exists
    }
}

class CreditScoreUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testShowingDashboard() {
        // Launch app
        app.launch()
        
        // Make sure we're displaying dashboard view
        XCTAssertTrue(app.isDisplayingDashboard)
    }

    func testScoreLabels() {
        // Launch app
        app.launch()
        
        // Make sure we're displaying dashboard view
        XCTAssertTrue(app.isDisplayingDashboard)
        
        sleep(2)    // Short delay so that the update of label values reflect correctly in the test
        
        //NOTE: These values based on data returned from an api call. So if data changes on the backend then these tests might fail!
        XCTAssertEqual(app.staticTexts["scoreLabel"].label, "514")
        
        XCTAssertEqual(app.staticTexts["maxScoreLabel"].label, "out of 700")
    }

    //TODO Add additional tests here...

}
