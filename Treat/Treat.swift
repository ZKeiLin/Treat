//
//  Treat.swift
//  Treat
//
//  Created by Liam Brozik on 3/5/19.
//  Copyright © 2019 iSchool. All rights reserved.
//

import Foundation

class Treat :NSObject{
    var name: String
    var category: String
    var points: Int
    
    init(name: String, points: Int, category: String) {
        self.name = name
        self.category = category
        self.points = points
    }
}
// Sample data link: https://api.myjson.com/bins/1002ja
