//
//  ItemListChangesetViewModel.swift
//  RCMVVMSampleLib
//
//  Created by Alberto Salas on 25/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import Foundation
import Changeset
import ReactiveSwift
import Result

public enum ItemListChangesetViewModelError: Error {
	case ItemListChangesetViewModelGeneral
}

public typealias AddItemAction = Action<ItemListCellViewModel, Void, NoError>
public typealias LoadItemsAction = Action<String?, Void, ItemListChangesetViewModelError>
public typealias ItemsChangeset = [Edit<ItemListCellViewModel>]

//typealias ItemsSignalEvent = Signal<[Item], BackendClientError>.Event
//typealias LoadItemsActionsSignal = Signal<Void, ItemListChangesetViewModelError>

public class ItemListChangesetViewModel {
	
	// Backend Client (Injected)
	let backendClient: BackendClient
	
	// Action (with condition) Example
	public let addItemCondition: MutableProperty<Bool> = MutableProperty(false)
	public var addItemAction: AddItemAction! = nil
	
	public var loadItemsAction: LoadItemsAction! = nil
	
	// Serach String
	public var searchString: MutableProperty<String?> = MutableProperty("")
	
	// Model Changeset
	public let itemsChangeset = MutableProperty(ItemsChangeset())
	// Model
	private var items: [ItemListCellViewModel] = [] {
		didSet {
			itemsChangeset.value = Changeset.edits(from: oldValue, to: items)
		}
	}
	
	// MARK: - Inits
	
	init(withBackendClient backendClient: BackendClient) {
		
		self.backendClient = backendClient
		
		//ReactiveSwift Action with a ItemListCellViewModel as Input
		self.addItemAction = AddItemAction(enabledIf: addItemCondition) { (item: ItemListCellViewModel) in
			return SignalProducer { [weak self] observer, lifetime in
				self?.items.insert(item, at: 0)
				observer.sendCompleted()
			}
		}
		
		self.loadItemsAction = LoadItemsAction() { searchString in
			return self.loadItems(searchString: searchString)
		}
		
		self.loadItemsAction <~ self.searchString.signal
			/*.throttle(1, on: QueueScheduler())
			.filter { $0.characters.count >= 3 }*/
		
	}
	
	public convenience init() {
		self.init(withBackendClient: BackendClientMoyaStub())
	}
	
	// MARK: - Public methods
	
	public func getItemsCount() -> Int {
		return items.count
	}
	
	public func getItemViewModel(forIndex index: Int) -> ItemListCellViewModel {
		return items[index]
	}
	
	// MARK: - Private methods
	
	func loadItems(searchString: String?) -> SignalProducer<Void, ItemListChangesetViewModelError> {
		return backendClient.getItems(withSearchString: searchString).map { [weak self] (items) -> Void in
			self?.handleNewItems(items: items)
		}.mapError({ (error:BackendClientError) -> ItemListChangesetViewModelError in
			/* Manage and transform the error here */
			return .ItemListChangesetViewModelGeneral
		})
	}

	func handleNewItems(items:[Item]) {
		self.items = items.map { ItemListCellViewModel(withItem: $0) }
	}
	
}
