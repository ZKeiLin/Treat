//
//  User+CoreDataProperties.swift
//  Treat
//
//  Created by Zhiqi Lin on 3/6/19.
//  Copyright © 2019 iSchool. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var points: Int32
    @NSManaged public var history: [Any]?
    @NSManaged public var tasks: [Any]?
//    @NSManaged public var treats: [Any]?

}
