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

var taskColor : [UIColor] = [UIColor(red:0.29, green:0.53, blue:0.91, alpha:1.0), UIColor(red:0.09, green:0.75, blue:0.73, alpha:1.0), UIColor.orange, UIColor.red]
let XP_PER_LEVEL : Float = 500.0 // XP Per level


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
                // segue as popover
                // all this info is going to be on the view controller
                let user = User(context: PersistenceService.context)
                user.name = userProfile.name
                user.points = Int32(userProfile.points)
                user.history = userProfile.history
                user.tasks = userProfile.tasks
                user.treats = userProfile.treats
                
                // tap "done" and run fetchrequest again
                // ignore the next 2 lines
                PersistenceService.saveContext() // Save newly created user
                result = try PersistenceService.context.fetch(fetchRequest) // Fetch the CoreData again with the new user
            }
            
            print("USERNAME: \(result[0].name!)")
            return result[0]
        } catch {
            print("FATAL: Couldn't fetch Coredta")
            return nil
        }
    }
    
    static func eraseData() {
        let context:NSManagedObjectContext = PersistenceService.persistentContainer.viewContext
//        let names = PersistenceService.persistentContainer.managedObjectModel.entities.map({ (entity) -> String in
//            return entity.name!
//        })
//
//        print(names)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.returnsObjectsAsFaults = false
        print(fetchRequest)

        do
        {
            let results = try context.fetch(fetchRequest)
            print("results: \(results)")
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                print("deleted \(managedObjectData)")
                context.delete(managedObjectData)
            }
            try! context.save()
        } catch let error as NSError {
            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
        }
    }
    
    static func getXp(_ user : User?) -> Int {
        var returnXp : Int = 0
        for t in user!.history! {
            switch t {
            case is Task: let ta = t as! Task; returnXp += Int(ta.points!)
            default: let tr = t as! Treat; returnXp += Int(tr.points!)
            }
        }
        return returnXp
    }
    
    static func getPercentXp(_ user : User?) -> Float {
        return Float(getXp(user)).truncatingRemainder(dividingBy: XP_PER_LEVEL) / XP_PER_LEVEL
    }
    
    static func getLevel(_ user : User?) -> Int {
        return Int(floor(Float(getXp(user)) / XP_PER_LEVEL)) + 1 // Default level 1
    }
    
    static func createLoadAlert(_ alertMsg : String) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: alertMsg, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        return alert
    }
}
