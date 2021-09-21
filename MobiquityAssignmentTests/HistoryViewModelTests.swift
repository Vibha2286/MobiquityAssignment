//
//  HistoryViewModelTests.swift
//  MobiquityAssignmentTests
//
//  Created by Vibha Mangrulkar on 2021/09/17.
//

import XCTest

@testable import MobiquityAssignment

class HistoryViewModelTests: XCTestCase {

    var systemUnderTest: HistoryViewModel?
    
    override func setUpWithError() throws {
        self.systemUnderTest = HistoryViewModel()
    }

    override func tearDownWithError() throws {
        self.systemUnderTest = nil
        try super.tearDownWithError()
    }
    
    func testHistory() {
        XCTAssertNotNil(LocalStorageUtils.historyList)
        XCTAssertGreaterThan(LocalStorageUtils.historyList.count, 0, "History is available")
        systemUnderTest?.removeHistoryAtIndex(index: 0)
    }
    
    func testSetHistory() {
        XCTAssertNotNil(LocalStorageUtils.historyList)
        systemUnderTest?.historyData.append("dog")
        XCTAssertGreaterThan(LocalStorageUtils.historyList.count, 0, "History is available")
    }
}
