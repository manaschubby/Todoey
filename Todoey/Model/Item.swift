//
//  Item.swift
//  Todoey
//
//  Created by Manas Ashwin on 10/04/18.
//  Copyright © 2018 Manas Producers. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
