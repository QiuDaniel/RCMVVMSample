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
import Result
import RCMVVMSampleLib

class ItemListChangesetTableViewController: UITableViewController {
	
	// ViewModel
	var viewModel: ItemListChangesetViewModel!
	
	// UI Outlets
	@IBOutlet weak var addButton: UIBarButtonItem!
	let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

		// Setup the Search Controller
		searchController.dimsBackgroundDuringPresentation = false
		definesPresentationContext = true
		tableView.tableHeaderView = searchController.searchBar
		
		// Changeset suscription -> Table updates
		viewModel.itemsChangeset.producer.startWithValues { edits in
			self.tableView.update(with: edits)
		}
		
		// Create CocoaAction from addItemAction, adding a test item
		let addItemCA = CocoaAction(viewModel.addItemAction) { (sender: UIBarButtonItem) -> ItemListCellViewModel in
			return ItemListCellViewModel(name: "Item Added Name", reference: "Item Added Reference")
		}
		// Bind the CocoaAction to the addButton.
		// It will handle the button's enabling/disabling and the action
		addButton.reactive.pressed = addItemCA
		
		// Bind viewDidAppear event with the loading of items
//		viewModel.loadItemsAction <~ self.reactive.trigger(for: #selector(ItemListChangesetTableViewController.viewDidAppear(_:))).map({ (_) -> String? in
//			return nil
//		})
		
		viewModel.loadItemsAction <~ self.reactive.trigger(for: #selector(ItemListChangesetTableViewController.viewDidAppear(_:))).rcmvvms_replaceValue(nil, ofType: String?.self)
		
		// Enable the addItem button 5 seconds after the view appears
		Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
			self.viewModel.addItemCondition.value = true
		}
		
//		let searchStringsSignal = searchController.searchBar.reactive.continuousTextValues
//			.skipNil()
//			.throttle(1, on: QueueScheduler())
//			.filter { $0.characters.count >= 3 }
//		viewModel.searchString <~ searchStringsSignal
		viewModel.searchString <~ searchController.searchBar.reactive.continuousTextValues
		viewModel.searchString <~ searchController.searchBar.reactive.cancelButtonClicked.rcmvvms_replaceValue(nil, ofType: String?.self)
		
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

}
