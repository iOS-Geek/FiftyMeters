//
//  Session+CoreDataProperties.swift
//  FiftyMeters
//
//  Created by Manish Anand on 04/09/16.
//  Copyright © 2016 Manish Anand. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Session {

    @NSManaged var date: NSDate?
    @NSManaged var dateString: String?

}
