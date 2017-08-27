//
//  BackendClient.swift
//  RCMVVMSampleLib
//
//  Created by Alberto Salas on 24/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import Foundation
import ReactiveSwift

enum BackendClientError: Error {
	case BackendClientGeneral
}

typealias BackendClientGetItemsResponse = SignalProducer<[Item], BackendClientError>

protocol BackendClient {
	
	func getItems(withSearchString searchString: String?) -> BackendClientGetItemsResponse
	
}
