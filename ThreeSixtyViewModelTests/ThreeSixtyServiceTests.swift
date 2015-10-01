//
//  ThreeSixtyViewModelTests.swift
//  ThreeSixtyViewModelTests
//
//  Created by Brad Dillon on 9/12/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import XCTest
@testable import ThreeSixtyViewModel

class ThreeSixtyServiceTests: XCTestCase {
    
    var store = Store()
    
    override func setUp() {
        store = Store()
        super.setUp()
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func wait() {
        self.waitForExpectationsWithTimeout(3) { (error) -> Void in
            if let error = error {
                XCTFail("\(error)")
            }
        }
    }
    
    func testFetchSpeakers() {
        let expec = self.expectationWithDescription("fetch speakers")
        fetchSpeakers(store) { (speakers) -> Void in
            if speakers.count == 4 && speakers[0].name == "Sally Smith" {
                expec.fulfill()
            }
            else {
                XCTFail()
            }
        }
        wait()
    }

    func testFetchTalks() {
        let expec = self.expectationWithDescription("fetch talks")
        fetchTalks(store) { (talks) -> Void in
            if talks.count == 5 && talks[0].name == "How To Do The Stuff" {
                expec.fulfill()
            }
            else {
                XCTFail()
            }
        }
        wait()
    }
    
    func testFetchSpeakerDetails() {
        let expec = self.expectationWithDescription("fetch speaker")
        fetchSpeaker("10001", store: store) { (speaker) -> Void in
            if speaker.talks?.count > 0 {
                expec.fulfill()
            }
            else {
                XCTFail()
            }
        }
        wait()
    }
    
    func testFetchTalkDetails() {
        let expec = self.expectationWithDescription("fetch talk")
        fetchTalk("20001", store: store) { (talk) -> Void in
            if talk.location == "Room 1" {
                expec.fulfill()
            }
            else {
                XCTFail()
            }
        }
        wait()
    }
}
