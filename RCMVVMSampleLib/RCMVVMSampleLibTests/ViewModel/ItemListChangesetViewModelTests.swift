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
		
		let expectedSearchString = "expectedSearchString"
		let expectedItems = [Item]()
		
		let backendClientMockItems = BackendClientMock { searchString in
			XCTAssertEqual(searchString, expectedSearchString)
			return BackendClientGetItemsResponse(value: expectedItems)
		}
		
		let hniEx = expectation(description: "hni")
		
		let ilcvmMock = ItemListChangesetViewModelMock(withBackendClient: backendClientMockItems)
		ilcvmMock.searchString.value = expectedSearchString
		ilcvmMock.handleNewItemsClosure = { items in
			XCTAssertEqual(items, expectedItems)
			hniEx.fulfill()
		}
		
		ilcvmMock.loadItems()
		
		waitForExpectations(timeout: 1, handler: nil)
		
    }
	
	func testLoadItemsError() {
		
		let expectedSearchString = "expectedSearchString"
		let expectedError = BackendClientError.BackendClientGeneral
		
		let backendClientMockError = BackendClientMock { searchString in
			XCTAssertEqual(searchString, expectedSearchString)
			return BackendClientGetItemsResponse(error:.BackendClientGeneral)
		}
		
		let hnieEx = expectation(description: "hnie")
		
		let ilcvmMock = ItemListChangesetViewModelMock(withBackendClient: backendClientMockError)
		ilcvmMock.searchString.value = expectedSearchString
		ilcvmMock.handleBackendClientErrorClosure = { error in
			XCTAssertEqual(error, expectedError)
			hnieEx.fulfill()
			return ItemListChangesetViewModelError.ItemListChangesetViewModelGeneral
		}
		
		ilcvmMock.loadItems()
		
		waitForExpectations(timeout: 1, handler: nil)
		
	}
	
//	func testhandleItemsEvent() {
//		
//		//let expectedItems = [Item]()
//		
////		func observer(expectedEvent: LoadItemsActionsSignal.Event) -> LoadItemsActionsSignal.Observer {
////			return LoadItemsActionsSignal.Observer(action: { event in
////				XCTAssertEqual(event, nil)
////			})
////		}
////		LoadItemsActionsSignal.Observer(action: { event in
////			XCTAssertEqual(1, 1)
////		})
//		
//		func loadItemsPipe(expectedEvent: (LoadItemsActionsSignal.Event)?, completion:@escaping () -> Void) -> (LoadItemsActionsSignal, LoadItemsActionsSignal.Observer) {
//			let (signal, observer) = LoadItemsActionsSignal.pipe()
//			signal.observe { event in
//				if let expectedEvent = expectedEvent {
//					XCTAssertTrue(equalEvents(event, expectedEvent))
//				} else {
//					XCTFail()
//				}
//				completion()
//			}
//			return (signal, observer)
//		}
//		
//		
//		//func handleItemsEvent(event: ItemsSignalEvent, observer: LoadItemsActionsSignal.Observer)
//		let ilcvm = ItemListChangesetViewModel()
//		
//		let expectedItems = [Item]()
//		var event = ItemsSignalEvent.value(expectedItems)
//		
//		let soEx = expectation(description: "so")
//		
//		var (signal, observer) = loadItemsPipe(expectedEvent: nil, completion: { soEx.fulfill() })
//		
//		ilcvm.handleItemsEvent(event: event, observer: observer)
//		
//		waitForExpectations(timeout: 100, handler: nil)
//		
////		event = ItemsSignalEvent.failed(BackendClientError.BackendClientGeneral)
////		(signal, observer) = loadItemsPipe(expectedEvent: LoadItemsActionsSignal.Event.failed(ItemListChangesetViewModelError.ItemListChangesetViewModelGeneral))
////		ilcvm.handleItemsEvent(event: event, observer: observer)
//		
//		//let t = ItemsSignalEvent.value(expectedItems)
//		
//		
//	}
	
	func testLoadItems2() {
		
		let expectedItems = [Item]()
		let hiEx = expectation(description: "hi")
		let cEx = expectation(description: "c")
		
		let bc = BackendClientMock { _ in
			return BackendClientGetItemsResponse(value: expectedItems)
		}
		
		let ilcvm = ItemListChangesetViewModelMock(withBackendClient: bc)
		ilcvm.handleNewItemsClosure = { items in
			XCTAssertEqual(items, expectedItems)
			hiEx.fulfill()
		}
		
		ilcvm.loadItems2().startWithCompleted {
			cEx.fulfill()
		}
		
		waitForExpectations(timeout: 100, handler: nil)
		
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
