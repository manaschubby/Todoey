//
//  Category.swift
//  Todoey
//
//  Created by Manas Ashwin on 10/04/18.
//  Copyright © 2018 Manas Producers. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
}
