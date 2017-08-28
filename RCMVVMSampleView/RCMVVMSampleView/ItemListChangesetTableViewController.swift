//
//  ItemListChangesetTableViewController.swift
//  RCMVVMSampleView
//
//  Created by Alberto Salas on 25/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import RCMVVMSampleLib

class ItemListChangesetTableViewController: ItemListCommonTableViewController {
	
	// ViewModel
	var viewModelChangeset: ItemListChangesetViewModel! {
		didSet {
			self.viewModel = viewModelChangeset
		}
	}
	
	// UI Outlets
	@IBOutlet weak var addButton: UIBarButtonItem!
	
	// MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
		
		bindTableView(tableView, property: viewModelChangeset.itemsChangeset)
		
		bindAddItemButton(addButton, action: viewModelChangeset.addItemAction, condition: viewModelChangeset.addItemCondition)
		
    }
	
	// MARK: - Setup and binding methods
	
	// Changeset suscription -> Table updates
	func bindTableView(_ tableView:UITableView, property:MutableProperty<ItemsChangeset>) {
		property.producer.startWithValues { edits in
			tableView.update(with: edits)
		}
	}
	
	// Bind AddItem Button
	func bindAddItemButton(_ addButton: UIBarButtonItem, action: AddItemAction, condition: MutableProperty<Bool>) {
		
		// Create CocoaAction from addItemAction, adding a test item
		let addItemCA = CocoaAction(action) { (sender: UIBarButtonItem) -> ItemListCellViewModel in
			return ItemListCellViewModel(name: "Item Added Name", reference: "Item Added Reference")
		}
		
		// Bind the CocoaAction to the addButton.
		// It will handle the button's enabling/disabling and the action
		addButton.reactive.pressed = addItemCA
		
		// Enable the addItem button 5 seconds after the view appears
		Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
			condition.value = true
		}
		
	}

}
