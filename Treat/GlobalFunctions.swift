//
//  GlobalFunctions.swift
//  Treat
//
//  Created by Kelden Lin on 3/8/19.
//  Copyright © 2019 iSchool. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct DataFunc {
    static func fetchData() -> User? {
        let fetchRequest : NSFetchRequest<User> = User.fetchRequest()
        do {
            var result = try PersistenceService.context.fetch(fetchRequest)
            print("THERE ARE \(result.count) USER PROFILES")
            
            // No user profile is found
            if result.count == 0 {
                print("Creating initial user")
                let userProfile : UserProfile = UserProfile(name: "Me") // Default Data, would change to a field user can enter information
                let user = User(context: PersistenceService.context)
                user.name = userProfile.name
                user.points = Int32(userProfile.points)
                user.history = userProfile.history
                user.tasks = userProfile.tasks
                user.treats = userProfile.treats
                PersistenceService.saveContext() // Save newly created user
                result = try PersistenceService.context.fetch(fetchRequest) // Fetch the CoreData again with the new user
            }
            
            for data in result{
                print(data.name)
                for t in data.tasks! {
                    print(t.toString())
                }
            }
            
            return result[0]
        } catch {
            print("FATAL: Couldn't fetch Coredta")
            return nil
        }
    }
}
