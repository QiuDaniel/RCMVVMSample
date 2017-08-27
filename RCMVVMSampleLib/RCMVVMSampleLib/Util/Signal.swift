//
//  Signal.swift
//  RCMVVMSampleLib
//
//  Created by Alberto Salas on 27/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import Foundation
import ReactiveSwift

public extension Signal {
	
	public func rcmvvms_replaceValue<T>(_ value: T, ofType _:T.Type) -> Signal<T, Error> {
		return self.map { _ in return value }
	}
	
}
