//
//  BackendClientMock.swift
//  RCMVVMSampleLib
//
//  Created by Alberto Salas on 25/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import Foundation
@testable import RCMVVMSampleLib

class BackendClientMock: BackendClient {
	let getItemsClosure: ((String?) -> BackendClientGetItemsResponse)?
	
	init(getItemsClosure: ((String?) -> BackendClientGetItemsResponse)? = nil) {
		self.getItemsClosure = getItemsClosure
	}
	
	func getItems(withSearchString searchString: String?) -> BackendClientGetItemsResponse {
		return getItemsClosure!(searchString)
	}
}
