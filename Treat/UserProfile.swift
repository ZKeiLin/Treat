//
//  UserProfile.swift
//  Treat
//
//  Created by Liam Brozik on 3/5/19.
//  Copyright © 2019 iSchool. All rights reserved.
//

import Foundation
import UIKit

class UserProfile {
    let XP_PER_LEVEL : Float = 500.0

    var name : String
    var img : Data
    var points : Int
    var xp : Int
    
    var history : [Any]
    
    var tasks : [Task]
    var treats : [Treat]
    
    init(name: String) {
        self.name = name
        self.points = 0
        self.xp = 0
        
        self.history = []
        self.tasks = []
        self.treats = []
        self.img = UIImage(named: "defaultProfilePic")!.pngData()!
        
        let createTask = Task(name: "Pull down to create new tasks", points: 10)
        let completeTask = Task(name: "Swipe this task to complete it", points: 10)
        self.tasks.append(contentsOf: [createTask, completeTask])
    }
}
