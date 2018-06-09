//
//  SummaryTableViewController.swift
//  Home Report
//
//  Created by Deborah Newberry on 6/8/18.
//  Copyright © 2018 Deborah Newberry. All rights reserved.
//

import UIKit
import CoreData

class SummaryTableViewController: UITableViewController {
    // MARK: Outlets
    @IBOutlet weak var sfHomesSoldLabel: UILabel!
    @IBOutlet weak var condosSoldLabel: UILabel!
    @IBOutlet weak var totalHomeSalesLabel: UILabel!
    
    @IBOutlet weak var minHomePriceLabel: UILabel!
    @IBOutlet weak var maxHomePriceLabel: UILabel!
    
    @IBOutlet weak var avgCondoPriceLabel: UILabel!
    @IBOutlet weak var avgSFHomePrice: UILabel!
    
    // MARK: Properties
    var managedObjectContext: NSManagedObjectContext! {
        didSet {
            return home = Home(context: managedObjectContext)
        }
    }
    var home: Home? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 2
    }
    
    // MARK: Functions
    func loadData() {
        totalHomeSalesLabel.text = home?.getTotalHomeSales(moc: managedObjectContext)
        condosSoldLabel.text = home?.getNumberCondoSold(moc: managedObjectContext)
        sfHomesSoldLabel.text = home?.getNumberSingleFamilyHomeSold(moc: managedObjectContext)
        
        minHomePriceLabel.text = home?.getHomePriceSold(priceType: "min", moc: managedObjectContext)
        maxHomePriceLabel.text = home?.getHomePriceSold(priceType: "max", moc: managedObjectContext)
        
        avgCondoPriceLabel.text = home?.getAverageHomePrice(homeType: HomeType.Condo.rawValue, moc: managedObjectContext)
        avgSFHomePrice.text = home?.getAverageHomePrice(homeType: HomeType.SingleFamily.rawValue, moc: managedObjectContext)
        
    }
}
