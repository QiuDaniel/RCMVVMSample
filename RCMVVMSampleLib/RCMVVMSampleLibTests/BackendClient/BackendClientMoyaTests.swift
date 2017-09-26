//
//  BackendClientMoyaStubTests.swift
//  RCMVVMSampleLib
//
//  Created by Alberto Salas on 24/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import XCTest
@testable import RCMVVMSampleLib
import ReactiveSwift
import Moya

class BackendClientMoyaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testHandleItemsRequest_value() {
		
		let itemsData = MoyaDummyServiceUtil.items
		let jsonDecoder = JSONDecoder()
		guard let expectedValue = try? jsonDecoder.decode([Item].self, from: itemsData) else {
			XCTFail()
			return
		}
		
		let bcms = BackendClientMoya()
		
		let exItems = expectation(description: "Items")
		let exCompleted = expectation(description: "Completed")
		
		let response = Response(statusCode: 200, data: itemsData)
		let sp = SignalProducer<Response, MoyaError>(value:response)
		
		bcms.handleItemsRequest(sp).start({ result in
			switch result {
			case let .value(value):
				XCTAssertEqual(value, expectedValue)
				exItems.fulfill()
			case .completed:
				exCompleted.fulfill()
			case .failed:
				XCTFail()
			default:
				break
			}
		})
		
		waitForExpectations(timeout: 1, handler: nil)
		
	}
	
	func testHandleItemsRequest_error() {
		
		let bcms = BackendClientMoya()
		let exItems = expectation(description: "Items")
		let expectedError = BackendClientError.BackendClientErrorGeneral
		let sp = SignalProducer<Response, MoyaError>(error:MoyaError.requestMapping(""))
		
		bcms.handleItemsRequest(sp).start({ result in
			switch result {
			case let .failed(error):
				exItems.fulfill()
				XCTAssertEqual(error, expectedError)
			default:
				XCTFail()
			}
		})
		
		waitForExpectations(timeout: 1, handler: nil)
		
	}
	
	func testGetItems_withSearchString() {
		
		let expectedValue = [Item(reference: "1", name: "abcdef"), Item(reference: "2", name: "ghijkl")]
		let bcm = BackendClientMock()
		bcm.getItemsMoyaClosure = { _ in return BackendClientGetItemsResponse(value: expectedValue) }
		
		let exItems = expectation(description: "Items")
		let exCompleted = expectation(description: "Completed")
		
		bcm.getItems(withSearchString: "JK").start { event in
			switch event {
			case let .value(value):
				XCTAssertEqual(value, [expectedValue[1]])
				exItems.fulfill()
			case .completed:
				exCompleted.fulfill()
			case .failed:
				XCTFail()
			default:
				break
			}
		}
		
		waitForExpectations(timeout: 1, handler: nil)
		
	}
	
}
