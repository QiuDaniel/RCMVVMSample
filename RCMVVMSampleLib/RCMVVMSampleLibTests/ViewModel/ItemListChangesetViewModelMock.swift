//
//  ItemListChangesetViewModelMock.swift
//  RCMVVMSampleLib
//
//  Created by Alberto Salas on 25/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import Foundation
@testable import RCMVVMSampleLib

class ItemListChangesetViewModelMock: ItemListChangesetViewModel {
	
	var handleNewItemsClosure: (([Item]) -> Void)?
	var handleBackendClientErrorClosure: ((BackendClientError) -> ItemListChangesetViewModelError)?
	var handleItemsEventClosure: ((ItemsSignalEvent, LoadItemsActionsSignal.Observer) -> Void)?
	
	override func handleNewItems(items:[Item]) {
		if let handleNewItemsClosure = handleNewItemsClosure {
			handleNewItemsClosure(items)
		} else {
			super.handleNewItems(items: items)
		}
	}
	
	override func handleBackendClientError(error:BackendClientError) -> ItemListChangesetViewModelError {
		if let handleBackendClientErrorClosure = handleBackendClientErrorClosure {
			return handleBackendClientErrorClosure(error)
		} else {
			return super.handleBackendClientError(error: error)
		}
	}
	
	override func handleItemsEvent(event: ItemsSignalEvent, observer: LoadItemsActionsSignal.Observer) {
		if let handleItemsEventClosure = handleItemsEventClosure {
			return handleItemsEventClosure(event, observer)
		} else {
			return super.handleItemsEvent(event: event, observer: observer)
		}
	}
	
}
