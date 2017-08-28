//
//  ItemListCommonViewModel.swift
//  RCMVVMSampleLib
//
//  Created by Alberto Salas on 28/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

public enum ItemListViewModelError: Error {
	case ItemListViewModelErrorGeneral
}

public typealias LoadItemsAction = Action<Void, Void, ItemListViewModelError>

public class ItemListCommonViewModel {
	
	// Backend Client (Injected)
	let backendClient: BackendClient
	
	// Load Items Action
	public var loadItemsAction: LoadItemsAction! = nil
	
	// Serach String
	public var searchString: MutableProperty<String?> = MutableProperty("")
	
	// Model
	var items = [ItemListCellViewModel]()
	
	// MARK: - Inits
	
	init(withBackendClient backendClient: BackendClient) {
		
		self.backendClient = backendClient
		
		self.loadItemsAction = LoadItemsAction() { [unowned self] in
			return self.loadItems(searchString: self.searchString.value)
		}
		
		self.loadItemsAction <~ self.searchString.signal.rcmvvms_replaceValue((), ofType: Void.self)
		/*.throttle(1, on: QueueScheduler())
		.filter { $0.characters.count >= 3 }*/
		
	}
	
	public convenience init() {
		self.init(withBackendClient: BackendClientMoya())
	}
	
	// MARK: - Public methods
	
	public func getItemsCount() -> Int {
		return items.count
	}
	
	public func getItemViewModel(forIndex index: Int) -> ItemListCellViewModel {
		return items[index]
	}
	
	// MARK: - Private methods
	
	func loadItems(searchString: String?) -> SignalProducer<Void, ItemListViewModelError> {
		return backendClient.getItems(withSearchString: searchString).map { [weak self] (items) -> Void in
			self?.handleNewItems(items: items)
			}.mapError({ (error:BackendClientError) -> ItemListViewModelError in
				/* Manage and transform the error here */
				return .ItemListViewModelErrorGeneral
			})
	}
	
	func handleNewItems(items:[Item]) {
		self.items = items.map { ItemListCellViewModel(withItem: $0) }
	}
	
}
