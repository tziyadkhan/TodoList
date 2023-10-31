//
//  ToDoList+CoreDataProperties.swift
//  ToDoList
//
//  Created by Ziyadkhan on 19.10.23.
//
//

import Foundation
import CoreData


extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var title: String?

}

extension ToDoList : Identifiable {

}
