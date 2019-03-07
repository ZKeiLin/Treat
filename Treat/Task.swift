//
//  Task.swift
//  Treat
//
//  Created by Liam Brozik on 3/5/19.
//  Copyright © 2019 iSchool. All rights reserved.
//

import Foundation

public class Task : NSObject, NSCoding{
    
    var name: String?
    var points: Int?
    
    init(name: String, points: Int) {
        self.name = name
        self.points = points
    }
    
    private enum Key: String {
        case name = "name"
        case points = "points"
    }
    
    public func encode(with aCoder: NSCoder) {
        if let name = self.name, let points = self.points {
            aCoder.encode(name, forKey: Key.name.rawValue)
            aCoder.encode(points, forKey: Key.points.rawValue)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: Key.name.rawValue) as? String
        points = aDecoder.decodeObject(forKey: Key.points.rawValue) as? Int
        
        super.init()
    }
}
