//
//  BackendClientMoyaStub.swift
//  RCMVVMSampleLib
//
//  Created by Alberto Salas on 24/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import Moya

class BackendClientMoya: BackendClient {
	
	let provider: MoyaProvider<MoyaDummyService>
	let jsonDecoder: JSONDecoder
	let jsonEncoder: JSONEncoder
	
	init(withMoyaProvider moyaProvider:MoyaProvider<MoyaDummyService>, jsonDecoder: JSONDecoder, jsonEncoder: JSONEncoder) {
		self.provider = moyaProvider
		self.jsonDecoder = jsonDecoder
		self.jsonEncoder = jsonEncoder
	}
	
	convenience init() {
		self.init(withMoyaProvider: MoyaProvider<MoyaDummyService>(stubClosure: MoyaProvider.immediatelyStub), jsonDecoder: JSONDecoder(), jsonEncoder: JSONEncoder())
	}
	
	func getItems(withSearchString searchString: String? = nil) -> BackendClientGetItemsResponse {
		
		var r = getItemsMoya(withSearchString: searchString)
		
		/* Just to make things work */
		/* filter should be applied at the backend */
		if let searchString = searchString, !searchString.isEmpty {
			r = r.flatten().filter({ item in
				return item.name.lowercased().range(of: searchString.lowercased()) != nil
			}).collect()
		}
		
		return r
	}
	
	func getItemsMoya(withSearchString searchString: String? = nil) -> BackendClientGetItemsResponse {
		
		let moyaRequest = provider.reactive.request(.getItems(searchString: searchString)).retry(upTo: 3)
		return handleItemsRequest(moyaRequest)
		
	}
	
	//Testable
	func handleItemsRequest(_ itemsRequest:SignalProducer<Response, MoyaError>) -> BackendClientGetItemsResponse {
		
		return itemsRequest
			.mapError { moyaError in // I want to use "attemptMap" (where Error == AnyError)
				return AnyError(moyaError)
			}.attemptMap { response in
				return try self.jsonDecoder.decode([Item].self, from: response.data)
			}.mapError { anyError in
				/* Handle and transform errors here */
				return BackendClientError.BackendClientErrorGeneral
			}
		
	}
	
	func addItem(_ item: Item) {
		
		/* Add item to MoyaService's sampleData to make things work */
		/* This should be sent to the server */
		MoyaDummyServiceUtil.items = addItem(item, toJSONData: MoyaDummyServiceUtil.items, withEncoding: .utf8)
		
	}
	
	func addItem(_ item: Item, toJSONData jsonData: Data, withEncoding encoding: String.Encoding) -> Data {
		var items = try! jsonDecoder.decode([Item].self, from: jsonData)
		items.insert(item, at: 0)
		return try! jsonEncoder.encode(items)
	}
	
}
