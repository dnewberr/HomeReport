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
//    func getHomesByStatus(_ isForSale: Bool, _ moc: NSManagedObjectContext) -> [Home] {
//        let request: NSFetchRequest<Home> = Home.fetchRequest()
//        request.predicate = NSPredicate(format: "isForSale = %@", NSNumber(value: isForSale))
//
//        do {
//            let homes = try moc.fetch(request)
//            return homes
//        } catch {
//            fatalError("couldn't retrieve homes")
//        }
//    }
    
    func filterHomes(_ predicate: NSPredicate?, _ sortDescriptors: [NSSortDescriptor], _ isForSale: Bool, _ moc: NSManagedObjectContext) -> [Home] {
        let request: NSFetchRequest<Home> = Home.fetchRequest()
        let statusPredicate = NSPredicate(format: "isForSale = %@", NSNumber(value: isForSale))
        var predicates = [NSPredicate]()
        predicates.append(statusPredicate)
        
        if let filter = predicate {
            predicates.append(filter)
        }
        
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        request.predicate = compoundPredicate
        request.sortDescriptors = sortDescriptors
        
        do {
            let homes = try moc.fetch(request)
            return homes
        } catch {
            fatalError("couldn't filter homes")
        }
    }
}
