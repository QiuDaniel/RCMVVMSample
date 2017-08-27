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

class BackendClientMoyaStubTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testGetItems() {
		
		let expectedData = MoyaDummyServiceUtil.getItemsResposeData()
		guard let expedtedJson = String(data: expectedData, encoding: .utf8),
			let expectedValue = Mapper<Item>().mapArray(JSONString: expedtedJson) else {
				XCTFail()
				return
		}
		
		let bcms = BackendClientMoyaStub()
		
		let exItems = expectation(description: "Items")
		let exCompleted = expectation(description: "Completed")
		
		bcms.getItems().start({ result in
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
		
		waitForExpectations(timeout: 10, handler: nil)
		
	}
	
}
