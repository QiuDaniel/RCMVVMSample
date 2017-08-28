//
//  BackendClientMoyaStubTests.swift
//  RCMVVMSampleLib
//
//  Created by Alberto Salas on 24/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import XCTest
@testable import RCMVVMSampleLib
import ObjectMapper
import ReactiveSwift

class BackendClientMoyaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testGetItemsMoya() {
		
		let itemsData = MoyaDummyServiceUtil.items
		guard let expedtedJson = String(data: itemsData, encoding: .utf8),
			let expectedValue = Mapper<Item>().mapArray(JSONString: expedtedJson) else {
				XCTFail()
				return
		}
		
		let bcms = BackendClientMoya()
		
		var exItems = expectation(description: "Items")
		var exCompleted = expectation(description: "Completed")
		
		bcms.getItemsMoya().start({ result in
			switch result {
			case let .value(value):
				XCTAssertEqual(value, expectedValue)
				exItems.fulfill()
			case .completed:
				exCompleted.fulfill()
			case let .failed(error):
				print(error)
			default:
				break
			}
		})
		
		waitForExpectations(timeout: 1, handler: nil)
		
		exItems = expectation(description: "Items")
		exCompleted = expectation(description: "Completed")
		
		bcms.getItemsMoya(withSearchString: "testString").start({ result in
			switch result {
			case let .value(value):
				XCTAssertEqual(value, expectedValue)
				exItems.fulfill()
			case .completed:
				exCompleted.fulfill()
			case let .failed(error):
				print(error)
			default:
				break
			}
		})
		
		waitForExpectations(timeout: 1, handler: nil)
		
	}
	
	func testGetItems() {
		
		let itemsData = [Item(reference: "1", name: "abcdef"), Item(reference: "2", name: "ghijkl")]
		let bc = BackendClientMock()
		bc.getItemsMoyaClosure = { _ in return BackendClientGetItemsResponse(value: itemsData) }
		
		var exItems = expectation(description: "Items")
		var exCompleted = expectation(description: "Completed")
		
		bc.getItems(withSearchString: "BC").start { event in
			switch event {
			case let .value(value):
				XCTAssertEqual(value, [itemsData[0]])
				exItems.fulfill()
			case .completed:
				exCompleted.fulfill()
			default:
				break
			}
		}
		
		waitForExpectations(timeout: 1, handler: nil)
		
		exItems = expectation(description: "Items")
		exCompleted = expectation(description: "Completed")
		
		bc.getItems(withSearchString: "JK").start { event in
			switch event {
			case let .value(value):
				XCTAssertEqual(value, [itemsData[1]])
				exItems.fulfill()
			case .completed:
				exCompleted.fulfill()
			default:
				break
			}
		}
		
		waitForExpectations(timeout: 1, handler: nil)
		
	}
	
	func testAddItemToJSONData() {
		//TODO
	}
	
}
