//
//  Diary+CoreDataProperties.swift
//  FoodTracker
//
//  Created by 一戸悠河 on 2017/02/15.
//  Copyright © 2017年 Apple Inc. All rights reserved.
//

import Foundation
import CoreData


extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var foodName: String?
    @NSManaged public var img: String?
    @NSManaged public var studyTime: Int16

}
