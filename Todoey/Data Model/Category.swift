//
//  Category.swift
//  Todoey
//
//  Created by David Goodman on 10/8/18.
//  Copyright © 2018 David Goodman. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    
    let items = List<Item>()
    
}
