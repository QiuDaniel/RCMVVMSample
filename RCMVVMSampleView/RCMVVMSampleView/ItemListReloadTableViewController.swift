//
//  ItemListDatasourceTableViewController.swift
//  RCMVVMSampleView
//
//  Created by Alberto Salas on 28/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import RCMVVMSampleLib

class ItemListReloadTableViewController: ItemListCommonTableViewController {
	
	// ViewModel
	var viewModelReload: ItemListReloadViewModel! {
		didSet {
			self.viewModel = viewModelReload
		}
	}
	
	// MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        bindTableView(tableView, action: viewModelReload.loadItemsAction)
		
    }
	
	// MARK: - Setup and binding methods
	
	// Changeset suscription -> Table updates
	func bindTableView(_ tableView:UITableView, action:LoadItemsAction) {
		tableView.reactive.reloadData <~ action.completed
	}
	
	// Additional bindings for loadItems Action
	override func bindLoadItems(_ loadItemsAction: LoadItemsAction) {
		super.bindLoadItems(loadItemsAction)
		
		// This triggers loadItemsAction whenever user uses refreshControl
		// And activates the refreshControl when loadItemsAction is triggered from anywhere else
		tableView.refreshControl?.reactive.refresh = CocoaAction<UIRefreshControl>(loadItemsAction)
	}

}
