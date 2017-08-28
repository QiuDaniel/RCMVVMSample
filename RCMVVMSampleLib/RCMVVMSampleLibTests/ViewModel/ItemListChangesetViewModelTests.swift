//
//  ItemListChangesetViewModelTests.swift
//  RCMVVMSampleLib
//
//  Created by Alberto Salas on 25/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import XCTest
import ReactiveSwift
@testable import RCMVVMSampleLib

class ItemListChangesetViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testLoadItemsOK() {
		
		let expectedSearchString = "test"
		let expectedItems = [Item]()
		let hniEx = expectation(description: "hni")
		let cEx = expectation(description: "c")
		
		let bc = BackendClientMock()
		bc.getItemsClosure = { searchString in
			XCTAssertEqual(searchString, expectedSearchString)
			return BackendClientGetItemsResponse(value: expectedItems)
		}
		
		let ilcvm = ItemListChangesetViewModelMock(withBackendClient: bc)
		ilcvm.handleNewItemsClosure = { items in
			XCTAssertEqual(items, expectedItems)
			hniEx.fulfill()
		}
		
		ilcvm.loadItems(searchString: expectedSearchString).startWithCompleted {
			cEx.fulfill()
		}
		
		waitForExpectations(timeout: 1, handler: nil)
		
	}
	
	func testLoadItemsError() {
		
		let expectedSearchString = "test"
		let expectedError = ItemListChangesetViewModelError.ItemListChangesetViewModelGeneral
		let eEx = expectation(description: "e")
		
		let bc = BackendClientMock()
		bc.getItemsClosure = { searchString in
			XCTAssertEqual(searchString, expectedSearchString)
			return BackendClientGetItemsResponse(error: BackendClientError.BackendClientGeneral)
		}
		
		let ilcvm = ItemListChangesetViewModelMock(withBackendClient: bc)
		ilcvm.handleNewItemsClosure = { items in
			XCTFail()
		}
		
		ilcvm.loadItems(searchString: expectedSearchString).startWithFailed { error in
			XCTAssertEqual(error, expectedError)
			eEx.fulfill()
		}
		
		waitForExpectations(timeout: 1, handler: nil)
		
	}
	
}

// Since it's not possible to extend Signal.Event to conform Equatable (with Swift 3), let's do it with a function

func equalVoidEvents<Error:Swift.Error & Equatable>(_ le: Signal<Void, Error>.Event, _ re: Signal<Void, Error>.Event) -> Bool {
	switch (le, re) {
	case (.value, .value):
		return true
	default:
		return equalEventsNotCheckingValues(le, re)
	}
}

func equalEquatableEvents<T: Equatable, Error:Swift.Error & Equatable>(_ le: Signal<T, Error>.Event, _ re: Signal<T, Error>.Event) -> Bool {
	switch (le, re) {
	case (let .value(lv), let .value(rv)):
		return lv == rv
	default:
		return equalEventsNotCheckingValues(le, re)
	}
}

func equalEventsNotCheckingValues<T, Error:Swift.Error & Equatable>(_ le: Signal<T, Error>.Event, _ re: Signal<T, Error>.Event) -> Bool {
	switch (le, re) {
	case (let .failed(lerror), let .failed(rerror)):
		return lerror == rerror
	case (.interrupted, .interrupted):
		return true
	case (.completed, .completed):
		return true
	default:
		return false
	}
}
