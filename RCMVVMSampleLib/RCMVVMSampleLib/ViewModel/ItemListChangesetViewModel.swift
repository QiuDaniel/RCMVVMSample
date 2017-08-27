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

typealias ItemsSignalEvent = Signal<[Item], BackendClientError>.Event
typealias LoadItemsActionsSignal = Signal<Void, ItemListChangesetViewModelError>

public class ItemListChangesetViewModel {
	
	// Backend Client (Injected)
	let backendClient: BackendClient
	
	// Action (with condition) Example
	public let addItemCondition: MutableProperty<Bool> = MutableProperty(false)
	public var addItemAction: Action<ItemListCellViewModel, Void, NoError>! = nil
	
	public var loadItemsAction: Action<String?, Void, ItemListChangesetViewModelError>! = nil
	
	// Serach String
	public var searchString: MutableProperty<String?> = MutableProperty("")
	
	// Model Changeset
	public let itemsChangeset = MutableProperty([Edit<ItemListCellViewModel>]())
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
		self.addItemAction = Action<ItemListCellViewModel, Void, NoError>(enabledIf: addItemCondition) { (item: ItemListCellViewModel) in
			return SignalProducer { [weak self] observer, lifetime in
				self?.items.insert(item, at: 0)
				observer.sendCompleted()
			}
		}
		
//		self.loadItemsAction = Action<Void, Void, ItemListChangesetViewModelError>() { _ in
//			return SignalProducer { [weak self] observer, lifetime in
//				self?.loadItems(observer: observer)
//			}
//		}
		
		self.loadItemsAction = Action<String?, Void, ItemListChangesetViewModelError>() { searchString in
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
	
	// Load Items from BackendClient
//	public func loadItems() {
//		backendClient.getItems(withSearchString: searchString.value).start() { [weak self] result in
//			switch result {
//			case let .value(items):
//				self?.handleNewItems(items: items)
//			case let .failed(error):
//				self?.handleBackendClientError(error: error)
//			default:
//				break
//			}
//		}
//	}
	
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
	
//	func loadItems(observer: LoadItemsActionsSignal.Observer) {
//		backendClient.getItems(withSearchString: searchString.value).start() { [weak self] event in
//			self?.handleItemsEvent(event: event, observer: observer)
//		}
//	}
//	
//	func handleItemsEvent(event: ItemsSignalEvent, observer: LoadItemsActionsSignal.Observer) {
//		switch event {
//		case let .value(items):
//			handleNewItems(items: items)
//		case let .failed(error):
//			observer.send(error: handleBackendClientError(error: error))
//		case .interrupted:
//			observer.sendInterrupted()
//		case .completed:
//			observer.sendCompleted()
//		}
//	}

	func handleNewItems(items:[Item]) {
		self.items = items.map { ItemListCellViewModel(withItem: $0) }
	}

//	func handleBackendClientError(error:BackendClientError) -> ItemListChangesetViewModelError {
//		/* Manage and transform the error here */
//		return .ItemListChangesetViewModelGeneral
//	}
	
}
