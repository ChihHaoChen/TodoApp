//
//  Item.swift
//  TodoApp
//
//  Created by ChihHao on 2018-09-20.
//  Copyright © 2018 ChihHao. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object  {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    @objc dynamic var color: String = "0xFFFFFF"
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") // define the inversed relationship to the category
}
