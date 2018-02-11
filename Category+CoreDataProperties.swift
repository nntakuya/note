//
//  Category+CoreDataProperties.swift
//  SlideMenuControllerSwift
//
//  Created by 仲松拓哉 on 11/02/2018.
//  Copyright © 2018 Yuji Hato. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var saveData: NSDate?
    @NSManaged public var sort_id: Int64
    @NSManaged public var id: Int16

}
