//
//  Todo+CoreDataProperties.swift
//  TodoList
//
//  Created by Dwistari on 19/02/25.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?

}

extension Todo : Identifiable {

}
