//
//  Data.swift
//  TodoApp
//
//  Created by ChihHao on 2018-09-20.
//  Copyright © 2018 ChihHao. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object  {
    @objc dynamic var name: String = "" // dynamic dispatch allow this "name" variable to be montiored for change during run-time, and Realm can dynamically change the variable in database as well
    // dynamic patch comes from object-C API
    @objc dynamic var age: Int = 0
}
