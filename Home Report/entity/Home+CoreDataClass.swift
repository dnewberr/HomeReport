//
//  Home+CoreDataClass.swift
//  Home Report
//
//  Created by Deborah Newberry on 6/5/18.
//  Copyright © 2018 Deborah Newberry. All rights reserved.
//
//

import Foundation
import CoreData


public class Home: NSManagedObject {
    func getHomesByStatus(_ isForSale: Bool, _ moc: NSManagedObjectContext) -> [Home] {
        let request: NSFetchRequest<Home> = Home.fetchRequest()
        request.predicate = NSPredicate(format: "isForSale = %@", NSNumber(value: isForSale))
        
        do {
            let homes = try moc.fetch(request)
            return homes
        } catch {
            fatalError("couldn't retrieve homes")
        }
    }
}
