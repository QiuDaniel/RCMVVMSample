//
//  AppDelegate.swift
//  RCMVVMSampleView
//
//  Created by Alberto Salas on 24/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import UIKit
import RCMVVMSampleLib

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		if let rootViewController = self.window?.rootViewController as? UITabBarController, let vcs = rootViewController.viewControllers {
			
			let cleanvcs: [UIViewController] = vcs.map { vc in
				if let vc = vc as? UINavigationController {
					return vc.viewControllers.first!
				} else {
					return vc
				}
			}
			
			// ViewModel Injection
			for vc in cleanvcs {
				switch vc {
				case let changesetVC as ItemListChangesetTableViewController:
					changesetVC.viewModelChangeset = ItemListChangesetViewModel()
				case let datasourceVC as ItemListReloadTableViewController:
					datasourceVC.viewModelReload = ItemListReloadViewModel()
				default: break
				}
			}
		}
		
        return true
    }


}

