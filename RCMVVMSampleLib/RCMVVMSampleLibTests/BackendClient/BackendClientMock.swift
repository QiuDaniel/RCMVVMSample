//
//  BackendClientMock.swift
//  RCMVVMSampleLib
//
//  Created by Alberto Salas on 25/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import Foundation
@testable import RCMVVMSampleLib

class BackendClientMock: BackendClientMoya {
	var getItemsClosure: ((String?) -> BackendClientGetItemsResponse)?
	var getItemsMoyaClosure: ((String?) -> BackendClientGetItemsResponse)?
	var addItemClosure: ((Item) -> Void)?
	
	override func getItems(withSearchString searchString: String?) -> BackendClientGetItemsResponse {
		return getItemsClosure?(searchString) ?? super.getItems(withSearchString: searchString)
	}
	
	override func getItemsMoya(withSearchString searchString: String? = nil) -> BackendClientGetItemsResponse {
		return getItemsMoyaClosure?(searchString) ?? super.getItemsMoya(withSearchString: searchString)
	}
	
	override func addItem(_ item: Item) {
		self.addItemClosure?(item) ?? super.addItem(item)
	}
}
