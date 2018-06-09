//
//  AppDelegate.swift
//  Home Report
//
//  Created by Deborah Newberry on 6/5/18.
//  Copyright © 2018 Deborah Newberry. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coreData = CoreDataStack()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        deleteRecords()
        checkDataStore()
        
        let managedObjectContext = coreData.persistentContainer.viewContext
        let tabBarController = self.window?.rootViewController as! UITabBarController
        
        let homeListViewController = (tabBarController.viewControllers?[0] as! UINavigationController).topViewController as! HomeListViewController
//        let summaryListViewController = (tabBarController.viewControllers?[1] as! UINavigationController).topViewController as! SummaryTableViewController
        let summaryListViewController = tabBarController.viewControllers?[1] as! SummaryTableViewController
        homeListViewController.managedObjectContext = managedObjectContext
        summaryListViewController.managedObjectContext = managedObjectContext
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) { }
    
    func applicationDidEnterBackground(_ application: UIApplication) { }
    
    func applicationWillEnterForeground(_ application: UIApplication) { }
    
    func applicationDidBecomeActive(_ application: UIApplication) { }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coreData.saveContext()
    }
    
    func checkDataStore() {
        let managedObjectContect = coreData.persistentContainer.viewContext
        
        do {
            let homeCount = try managedObjectContect.count(for: Home.fetchRequest())
            if homeCount == 0 {
                uploadSampleData()
            }
        } catch {
            fatalError("Error in counting home record")
        }
    }
    
    func uploadSampleData() {
        let url = Bundle.main.url(forResource: "homes", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
            let jsonArray = jsonResult.value(forKey: "home") as! NSArray
            
            for json in jsonArray {
                createHome(json as! [String: AnyObject])
            }
            
            coreData.saveContext()
        } catch {
            fatalError("Error uploading sample data")
        }
    }
    
    func createHome(_ homeData:[String:AnyObject]) {
        guard let city = homeData["city"] else {
            return
        }
        
        guard let price = homeData["price"] else {
            return
        }
        
        guard let bed = homeData["bed"] else {
            return
        }
        
        guard let bath = homeData["bath"] else {
            return
        }
        
        guard let sqft = homeData["sqft"] else {
            return
        }
        
        var image: UIImage?
        if let currentImage = homeData["image"] {
            image = UIImage(named: currentImage as! String)
        }
        
        guard let category = homeData["category"] else {
            return
        }
        let homeType = (category as! NSDictionary)["homeType"] as? String
        
        guard let status = homeData["status"] else {
            return
        }
        let isForSale = (status as! NSDictionary)["isForSale"] as? Bool
        
        let home = homeType?.caseInsensitiveCompare("condo") == .orderedSame
            ? Condo(context: coreData.persistentContainer.viewContext)
            : SingleFamily(context: coreData.persistentContainer.viewContext)
        
        if let unitsPerBuilding = homeData["unitsPerBuilding"] {
            (home as! Condo).unitsPerBuilding = unitsPerBuilding.int16Value
        }
        
        if let lotSize = homeData["lotSize"] {
            (home as! SingleFamily).lotSize = lotSize.int16Value
        }
        
        home.city = city as? String
        home.price = price as! Double
        home.bed = bed.int16Value
        home.bath = bath.int16Value
        home.sqft = sqft.int16Value
        home.homeType = homeType
        home.image = UIImageJPEGRepresentation(image!, 1.0)!
        home.isForSale = isForSale!
        
        if let saleHistories = homeData["saleHistory"] {
            addSaleHistory(saleHistories, home)
        }
    }
    
    func addSaleHistory(_ saleHistories: AnyObject, _ home: Home) {
        let saleHistoryData = home.saleHistory?.mutableCopy() as! NSMutableSet
        
        for saleDetails in saleHistories as! NSArray {
            let saleData = saleDetails as! [String:AnyObject]
            let saleHistory = SaleHistory(context: coreData.persistentContainer.viewContext)
            saleHistory.soldPrice = saleData["soldPrice"] as! Double
            
            let soldDateString = saleData["soldDate"] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            saleHistory.soldDate = dateFormatter.date(from: soldDateString)
            
            saleHistoryData.add(saleHistory)
            home.addToSaleHistory(saleHistory)
        }
    }
    
    func deleteRecords() {
        let moc = coreData.persistentContainer.viewContext
        let homeRequest: NSFetchRequest<Home> = Home.fetchRequest()
        let saleHistoryRequest: NSFetchRequest<SaleHistory> = SaleHistory.fetchRequest()
        
        
        do {
            try moc.execute(NSBatchDeleteRequest(fetchRequest: homeRequest as! NSFetchRequest<NSFetchRequestResult>))
            try moc.execute( NSBatchDeleteRequest(fetchRequest: saleHistoryRequest as! NSFetchRequest<NSFetchRequestResult>))
        } catch {
            fatalError("Error deleting records")
        }
    }
}

