import Foundation
import CoreData

public class Home: NSManagedObject {
    let soldPredicate: NSPredicate = NSPredicate(format: "isForSale = false")
    let request: NSFetchRequest<Home> = Home.fetchRequest()
    
    internal func filterHomes(_ predicate: NSPredicate?, _ sortDescriptors: [NSSortDescriptor], _ isForSale: Bool, _ moc: NSManagedObjectContext) -> [Home] {
        let request: NSFetchRequest<Home> = Home.fetchRequest()
        let statusPredicate = NSPredicate(format: "isForSale = %@", NSNumber(value: isForSale))
        var predicates = [NSPredicate]()
        predicates.append(statusPredicate)
        
        if let filter = predicate {
            predicates.append(filter)
        }
        
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        request.sortDescriptors = sortDescriptors
        
        do {
            let homes = try moc.fetch(request)
            return homes
        } catch {
            fatalError("couldn't filter homes")
        }
    }
    
    internal func getTotalHomeSales(moc: NSManagedObjectContext) -> String {
        request.predicate = soldPredicate
        request.resultType = .dictionaryResultType
        
        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.name = "totalSales"
        sumExpressionDescription.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "price")])
        sumExpressionDescription.expressionResultType = .doubleAttributeType
        
        request.propertiesToFetch = [sumExpressionDescription]
        
        do {
            let results = try moc.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as! [NSDictionary]
            let dictionary = results.first!
            let totalSales = dictionary["totalSales"] as! Double
            
            return totalSales.currencyFormatter
        }
        catch {
            fatalError("Error getting total home sales")
        }
    }
    
    internal func getNumberCondoSold(moc: NSManagedObjectContext) -> String {
        let typePredicate = NSPredicate(format: "homeType = 'Condo'")
        let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [soldPredicate, typePredicate])
        
        request.resultType = .countResultType
        request.predicate = predicate
        
        var count: NSNumber!
        do {
            let results = try moc.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as! [NSNumber]
            count = results.first
        }
        catch {
            fatalError("Error counting condo sold")
        }
        
        return count.stringValue
    }
    
    internal func getNumberSingleFamilyHomeSold(moc: NSManagedObjectContext) -> String {
        let typePredicate = NSPredicate(format: "homeType = 'Single Family'")
        let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [soldPredicate, typePredicate])
        
        request.predicate = predicate
        
        do {
            let count = try moc.count(for: request)
            
            if count != NSNotFound {
                return String(count)
            }
            else {
                fatalError("Error counting single family home sold")
            }
        }
        catch {
            fatalError("Error counting single family home sold")
        }
    }
    
    internal func getHomePriceSold(priceType: String, moc: NSManagedObjectContext) -> String {
        request.predicate = soldPredicate
        request.resultType = .dictionaryResultType
        
        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.name = priceType
        sumExpressionDescription.expression = NSExpression(forFunction: "\(priceType):", arguments: [NSExpression(forKeyPath: "price")])
        sumExpressionDescription.expressionResultType = .doubleAttributeType
        
        request.propertiesToFetch = [sumExpressionDescription]
        
        do {
            let results = try moc.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as! [NSDictionary]
            let dictionary = results.first!
            let homePrice = dictionary[priceType] as! Double
            
            return homePrice.currencyFormatter
        }
        catch {
            fatalError("Error getting \(priceType) home sales")
        }
    }
    
    internal func getAverageHomePrice(homeType: String, moc: NSManagedObjectContext) -> String {
        let typePredicate = NSPredicate(format: "homeType = %@", homeType)
        let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [soldPredicate, typePredicate])
        
        request.predicate = predicate
        request.resultType = .dictionaryResultType
        
        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.name = homeType
        sumExpressionDescription.expression = NSExpression(forFunction: "average:", arguments: [NSExpression(forKeyPath: "price")])
        sumExpressionDescription.expressionResultType = .doubleAttributeType
        
        request.propertiesToFetch = [sumExpressionDescription]
        
        do {
            let results = try moc.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as! [NSDictionary]
            let dictionary = results.first!
            let homePrice = dictionary[homeType] as! Double
            
            return homePrice.currencyFormatter
        }
        catch {
            fatalError("Error getting average \(homeType) price")
        }
    }
}
