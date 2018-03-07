//
//  Article+CoreDataProperties.swift
//  SlideMenuControllerSwift
//
//  Created by 仲松拓哉 on 06/02/2018.


import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var content: String?
    @NSManaged public var category_id: Int64
    @NSManaged public var saveDate: NSDate?

}
