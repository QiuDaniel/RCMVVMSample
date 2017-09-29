//
//  Item.swift
//  RCMVVMSampleLib
//
//  Created by Alberto Salas on 24/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import Foundation

class Item: Codable {
    var reference: String
    var name: String
    var description: String?
    
    init(reference: String, name: String, description:String? = nil) {
        self.reference = reference
        self.name = name
        self.description = description
    }
	
	// MARK: - Codable Protocol
	
	private enum CodingKeys : String, CodingKey {
		case reference = "ref"
		case name
		case description = "desc"
	}
}

extension Item: Equatable {
	
	// MARK: - Equatable Protocol
	
	static func == (lhs: Item, rhs: Item) -> Bool {
		return lhs.reference == rhs.reference && lhs.name == rhs.name && lhs.description == rhs.description
	}
	
}
