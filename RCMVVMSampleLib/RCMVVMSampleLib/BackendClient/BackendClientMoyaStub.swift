//
//  BackendClientMoyaStub.swift
//  RCMVVMSampleLib
//
//  Created by Alberto Salas on 24/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import Foundation
import ReactiveSwift
import Moya
import Moya_ObjectMapper

class BackendClientMoyaStub: BackendClient {
	
	let provider: MoyaProvider<MoyaDummyService>
	
	init(withMoyaProvider moyaProvider:MoyaProvider<MoyaDummyService>) {
		self.provider = moyaProvider
	}
	
	convenience init() {
		self.init(withMoyaProvider: MoyaProvider<MoyaDummyService>(stubClosure: MoyaProvider.immediatelyStub))
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
		
		return provider.reactive.request(.getItems(searchString: searchString))
			.mapArray(Item.self)
			.mapError { moyaError in
				/* Handle and transform errors here */
				return BackendClientError.BackendClientGeneral
		}
		
	}
	
}
