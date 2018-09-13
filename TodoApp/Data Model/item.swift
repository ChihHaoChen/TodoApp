//
//  item.swift
//  TodoApp
//
//  Created by ChihHao on 2018-09-13.
//  Copyright © 2018 ChihHao. All rights reserved.
//

import Foundation

class Item: Codable  { // Encodable => to have data with this class being able to be stored with encoder
    var title: String = ""
    var done: Bool = false
}
