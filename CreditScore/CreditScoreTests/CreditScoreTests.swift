//
//  CreditScoreTests.swift
//  CreditScoreTests
//
//  Created by Nur Ismail on 2020/03/03.
//  Copyright © 2020 NMI. All rights reserved.
//

import XCTest
@testable import CreditScore

class CreditScoreTests: XCTestCase {
    let sampleCreditDataJSON =
    """
    {"accountIDVStatus":"PASS","creditReportInfo":{"score":514,"scoreBand":4,"clientRef":"CS-SED-655426-708782","status":"MATCH","maxScoreValue":700,"minScoreValue":0,"monthsSinceLastDefaulted":-1,"hasEverDefaulted":false,"monthsSinceLastDelinquent":1,"hasEverBeenDelinquent":true,"percentageCreditUsed":44,"percentageCreditUsedDirectionFlag":1,"changedScore":0,"currentShortTermDebt":13758,"currentShortTermNonPromotionalDebt":13758,"currentShortTermCreditLimit":30600,"currentShortTermCreditUtilisation":44,"changeInShortTermDebt":549,"currentLongTermDebt":24682,"currentLongTermNonPromotionalDebt":24682,"currentLongTermCreditLimit":null,"currentLongTermCreditUtilisation":null,"changeInLongTermDebt":-327,"numPositiveScoreFactors":9,"numNegativeScoreFactors":0,"equifaxScoreBand":4,"equifaxScoreBandDescription":"Excellent","daysUntilNextReport":9},"dashboardStatus":"PASS","personaType":"INEXPERIENCED","coachingSummary":{"activeTodo":false,"activeChat":true,"numberOfTodoItems":0,"numberOfCompletedTodoItems":0,"selected":true},"augmentedCreditScore":null}
    """

    var sampleCreditData: CreditData? = nil
    
    // This method is called before the invocation of each test method in the class.
    override func setUp() {
        super.setUp()
        
        // Using a fixed json string here for testing purposes, but could instead do an actual api call!
        let jsonData = sampleCreditDataJSON.data(using: .utf8)!
        
        sampleCreditData = try? JSONDecoder().decode(CreditData.self, from: jsonData)
    }

    func testMaxScoreValue() {
        let model = CreditDataViewModel(creditData: sampleCreditData)
        
        XCTAssert(model.score <= model.maxScoreValue, "score cannot be more than maxScoreValue")
    }

    //TODO Add additional tests here...
}
