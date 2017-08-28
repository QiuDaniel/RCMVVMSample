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
	
	// MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
		
		bindTableView(tableView, property: viewModelChangeset.itemsChangeset)
		
    }
	
	// MARK: - Setup and binding methods
	
	// Changeset suscription -> Table updates
	func bindTableView(_ tableView:UITableView, property:MutableProperty<ItemsChangeset>) {
		property.producer.startWithValues { edits in
			tableView.update(with: edits)
		}
	}
	
	

}
