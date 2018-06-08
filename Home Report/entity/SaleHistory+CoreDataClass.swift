//
//  SaleHistory+CoreDataClass.swift
//  Home Report
//
//  Created by Deborah Newberry on 6/5/18.
//  Copyright © 2018 Deborah Newberry. All rights reserved.
//
//

import Foundation
import CoreData


public class SaleHistory: NSManagedObject {
    func getSoldHistory(_ home: Home, _ moc:NSManagedObjectContext) -> [SaleHistory] {
        let request: NSFetchRequest<SaleHistory> = SaleHistory.fetchRequest()
        request.predicate = NSPredicate(format: "home = %@", home)
        do {
            return try moc.fetch(request)
        } catch {
            fatalError("failure getting sale history")
        }
    }
}
