//
//  Item.swift
//  RCMVVMSampleLib
//
//  Created by Alberto Salas on 24/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import Foundation
import ObjectMapper

class Item: Equatable, Mappable {
    var reference: String!
    var name: String!
    var description: String?
    
    init(reference: String, name: String, description:String? = nil) {
        self.reference = reference
        self.name = name
        self.description = description
    }
    
    // MARK: - Equatable Protocol
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.reference == rhs.reference && lhs.name == rhs.name && lhs.description == rhs.description
    }
    
    // MARK: - Mappable (ObjectMapper) Protocol
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        reference   <- map["ref"]
        name        <- map["name"]
        description <- map["desc"]
    }
}
