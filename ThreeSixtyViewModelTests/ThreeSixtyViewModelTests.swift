//
//  ThreeSixtyViewModelTests.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 9/13/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import XCTest
@testable import ThreeSixtyViewModel

class ThreeSixtyViewModelTests: XCTestCase {
    
    var store = Store()
    
    override func setUp() {
        store = Store()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTalkList() {
        let list = TalkListViewModel(store: self.store)
        
        XCTAssertEqual(list.numberOfTalks(), 0)
        
        let expect = self.expectationWithDescription("Talk list refresh")
        
        list.refresh {
            expect.fulfill()
            
            XCTAssertEqual(list.numberOfTalks(), 5)
            
            let firstRow = list.talkViewModelAtIndex(0)
            
            XCTAssertEqual(firstRow.name.value, "How To Do The Stuff")
        }
        
        self.waitForExpectationsWithTimeout(3) { 
            XCTAssertNil($0)
        }
    }
    
    func testTalkDetails() {
        let expect = self.expectationWithDescription("Talk fetch")
        
        fetchTalks(store) { (talks) -> Void in
            
            let details = TalkDetailsViewModel(store: self.store, talk: talks[0])
            
            details.name.bind { XCTAssertEqual($0, "How To Do The Stuff") }
            details.location.bind { XCTAssertEqual($0, "Room 1") }
            
            XCTAssertEqual(details.name.value, "How To Do The Stuff")
            XCTAssertEqual(details.location.value, "")
                        
            details.refresh { expect.fulfill() }
        }
        
        self.waitForExpectationsWithTimeout(3) {
            XCTAssertNil($0)
        }
    }
    
    func testSpeakerList() {
        
    }
}
