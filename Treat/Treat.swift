//
//  Treat.swift
//  Treat
//
//  Created by Liam Brozik on 3/5/19.
//  Copyright © 2019 iSchool. All rights reserved.
//

import Foundation

public class Treat: NSObject, NSCoding {
    var name: String!
    var category: String!
    var points: Int!
    
    init(name: String, points: Int, category: String) {
        self.name = name
        self.category = category
        self.points = points
    }
    
    private enum Key: String {
        case name = "name"
        case points = "points"
        case category = "category"
    }
    
    public func encode(with aCoder: NSCoder) {
        if let name = self.name, let points = self.points, let categorty = self.category {
            aCoder.encode(name, forKey: Key.name.rawValue)
            aCoder.encode(points, forKey: Key.points.rawValue)
            aCoder.encode(category, forKey: Key.category.rawValue)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: Key.name.rawValue) as! String
        points = aDecoder.decodeObject(forKey: Key.points.rawValue) as! Int
        category = aDecoder.decodeObject(forKey: Key.category.rawValue) as! String
        super.init()
    }
}
// Sample data link: https://api.myjson.com/bins/1002ja
