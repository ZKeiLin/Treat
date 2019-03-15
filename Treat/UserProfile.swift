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
        
        let firstTask = Task(name: "Pull down to create new tasks", points: 10)
        self.tasks.append(firstTask)
    }
    
//    func addPoints(_ step : Int) { self.points += step }
//
//    func getLevel() -> Int {
//        return Int(floor(Float(xp) / XP_PER_LEVEL))
//    }
//
//    func completeTask(_ task : Task) {
//        addPoints(task.points!)
//        self.xp += points
//        if let idx = self.tasks.firstIndex(where: { $0 === task }) { self.tasks.remove(at: idx) } // Remove task from list
//        self.history.append(task)
//    }
//
//    func useTreat(_ treat : Treat) {
//        if points - treat.points >= 0 {
//            addPoints(treat.points * -1)
//            self.history.append(treat)
//        }
//    }
//
//    func printTasks() -> String {
//        var returnString = ""
//        for t in self.tasks { returnString += "\(t.toString())\n" }
//        return returnString
//    }
}
