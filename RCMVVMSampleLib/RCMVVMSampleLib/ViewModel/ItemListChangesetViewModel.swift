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

public typealias AddItemAction = Action<ItemListCellViewModel, Void, NoError>
public typealias ItemsChangeset = [Edit<ItemListCellViewModel>]

public class ItemListChangesetViewModel: ItemListCommonViewModel {
	
	// Action (with condition) Example
	public let addItemCondition: MutableProperty<Bool> = MutableProperty(false)
	public var addItemAction: AddItemAction! = nil
	
	// Model Changeset
	public let itemsChangeset = MutableProperty(ItemsChangeset())
	// Model
	override var items: [ItemListCellViewModel] {
		didSet {
			itemsChangeset.value = Changeset.edits(from: oldValue, to: items)
		}
	}
	
	// MARK: - Inits
	
	override init(withBackendClient backendClient: BackendClient) {
		
		super.init(withBackendClient: backendClient)
		
		//ReactiveSwift Action to add an item
		self.addItemAction = AddItemAction(enabledIf: addItemCondition) { (item: ItemListCellViewModel) in
			return SignalProducer { [weak self] observer, lifetime in
				self?.backendClient.addItem(item.item)
				observer.sendCompleted()
			}
		}
		
		self.loadItemsAction <~ self.addItemAction.completed
		
	}
	
	public convenience init() {
		self.init(withBackendClient: BackendClientMoya())
	}
	
}
