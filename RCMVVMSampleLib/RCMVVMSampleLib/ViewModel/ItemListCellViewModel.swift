//
//  ItemListCellViewModel.swift
//  RCMVVMSampleLib
//
//  Created by Alberto Salas on 25/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import Foundation

public class ItemListCellViewModel: Equatable {
	
	private let item: Item
	
	public var name: String { return item.name }
	public var reference: String { return item.reference }
	
	init(withItem item: Item) {
		self.item = item
	}
	
	public init(name: String, reference: String) {
		self.item = Item(reference: reference, name: name)
	}
	
	// MARK: - Equatable Protocol
	
	public static func == (lhs: ItemListCellViewModel, rhs: ItemListCellViewModel) -> Bool {
		return lhs.item == rhs.item
	}
}
