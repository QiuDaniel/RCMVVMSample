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

public typealias ItemsChangeset = [Edit<ItemListCellViewModel>]

public class ItemListChangesetViewModel: ItemListCommonViewModel {
	
	// Model Changeset
	public let itemsChangeset = MutableProperty(ItemsChangeset())
	// Model
	override var items: [ItemListCellViewModel] {
		didSet {
			itemsChangeset.value = Changeset.edits(from: oldValue, to: items)
		}
	}
	
}
