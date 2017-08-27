//
//  ItemTableViewCell.swift
//  RCMVVMSampleView
//
//  Created by Alberto Salas on 25/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import UIKit
import RCMVVMSampleLib

class ItemTableViewCell: UITableViewCell {

	var viewModel: ItemListCellViewModel! {
		didSet {
			textLabel?.text = viewModel.name
			detailTextLabel?.text = viewModel.reference
		}
	}

}
