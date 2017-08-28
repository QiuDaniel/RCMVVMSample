//
//  ItemListCommonTableViewController.swift
//  RCMVVMSampleView
//
//  Created by Alberto Salas on 28/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import RCMVVMSampleLib

class ItemListCommonTableViewController: UITableViewController {
	
	// ViewModel
	var viewModel: ItemListCommonViewModel!
	
	// UI Outlets
	@IBOutlet weak var addButton: UIBarButtonItem!
	let searchController = UISearchController(searchResultsController: nil)
	
	// MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
		
		bindLoadItems(viewModel.loadItemsAction)
		
		bindErrors(viewModel.loadItemsAction)
		
		setupSearchController(searchController)
		
		bindSearchController(searchController, withMutableProperty: viewModel.searchString)
		
		bindAddItemButton(addButton, action: viewModel.addItemAction, condition: viewModel.addItemCondition)

    }
	
	// MARK: - Setup and binding methods

	// Bind Load Items Action with events
	func bindLoadItems(_ loadItemsAction: LoadItemsAction) {
		// ViewDidAppear event
		loadItemsAction <~ self.reactive.trigger(for: #selector(viewDidAppear(_:)))
	}
	
	// Bind Errors
	func bindErrors(_ loadItemsAction: LoadItemsAction) {
		loadItemsAction.errors.observeValues { [unowned self] error in
			self.showViewModelError(error)
		}
	}
	
	// Setup the Search Controller
	func setupSearchController(_ searchController: UISearchController) {
		//Setup properties
		searchController.dimsBackgroundDuringPresentation = false
		definesPresentationContext = true
		tableView.tableHeaderView = searchController.searchBar
	}
	
	// Bind SeachController with a property
	func bindSearchController(_ searchController: UISearchController, withMutableProperty mutableProperty:MutableProperty<String?>) {
		
		//Bind viewModel.searchString with the searchBar values and the cancel button
		mutableProperty <~ searchController.searchBar.reactive.continuousTextValues
		
		//Empty property when user click on Cancel button
		//cancelButtonClicked signal: https://github.com/ReactiveCocoa/ReactiveCocoa/pull/3504
		mutableProperty <~ searchController.searchBar.reactive.cancelButtonClicked.rcmvvms_replaceValue(nil, ofType: String?.self)
		
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
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.getItemsCount()
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
		cell.viewModel = viewModel.getItemViewModel(forIndex: indexPath.row)
		return cell
	}
	
	// MARK: - Util methods
	
	private func showViewModelError(_ error:ItemListViewModelError) {
		/* Localize and show the error message */
	}

}
