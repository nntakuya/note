//
//  Article+CoreDataProperties.swift
//  SlideMenuControllerSwift
//
//  Created by 仲松拓哉 on 05/02/2018.
//  Copyright © 2018 Yuji Hato. All rights reserved.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var content: String?

}
