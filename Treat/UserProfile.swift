//
//  UserProfile.swift
//  Treat
//
//  Created by Liam Brozik on 3/5/19.
//  Copyright © 2019 iSchool. All rights reserved.
//

import Foundation

class UserProfile {
    var name : String
    var points : Int
    var level : Int?
    
    var history : [Any]
    
    var tasks : [Task]
    var treats : [Treat]
    
    init(name: String) {
        self.name = name
        self.points = 0
        self.level = 0
        self.history = []
        self.tasks = []
        self.treats = []
        
        let firstTask = Task(name: "Pull down to create new tasks", points: 10)
        tasks.append(firstTask)
        
        
    }
}
