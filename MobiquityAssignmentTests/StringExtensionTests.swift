//
//  StringExtensionTests.swift
//  MobiquityAssignmentTests
//
//  Created by Vibha Mangrulkar on 2021/09/17.
//

import XCTest
@testable import MobiquityAssignment

class StringExtensionTests: XCTestCase {
    
    func testRemoveSpaceFromString() {
        let string = "Flickr Image"
        XCTAssertEqual(string.removeSpaceFromString, "FlickrImage", "There was no space removed from the strings")
    }
}
