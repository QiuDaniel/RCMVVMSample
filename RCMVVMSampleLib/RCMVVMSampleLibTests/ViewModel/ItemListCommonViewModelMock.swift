//
//  ItemListChangesetViewModelMock.swift
//  RCMVVMSampleLib
//
//  Created by Alberto Salas on 25/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import Foundation
@testable import RCMVVMSampleLib

class ItemListCommonViewModelMock: ItemListCommonViewModel {
	
	var handleNewItemsClosure: (([Item]) -> Void)?
	
	override func handleNewItems(items:[Item]) {
		if let handleNewItemsClosure = handleNewItemsClosure {
			handleNewItemsClosure(items)
		} else {
			super.handleNewItems(items: items)
		}
	}
	
}
