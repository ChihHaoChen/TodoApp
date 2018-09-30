//
//  Category.swift
//  TodoApp
//
//  Created by ChihHao on 2018-09-20.
//  Copyright © 2018 ChihHao. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color: String = "0xFFFFFF"
    let items = List<Item>() // List is a container used to store to-many relationship

    // let array: Array<Int> = [1, 2, 3]  => another way to initialize an array
}
