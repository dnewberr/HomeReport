//
//  FilterTableViewController.swift
//  Home Report
//
//  Created by Deborah Newberry on 6/6/18.
//  Copyright © 2018 Deborah Newberry. All rights reserved.
//

import UIKit

protocol FilterTableViewControllerDelegate {
    func updateData(_ filterBy: NSPredicate?, _ sortBy: NSSortDescriptor?)
}

class FilterTableViewController: UITableViewController {
    // MARK: Outlets
    //SORT
    @IBOutlet weak var locationCell: UITableViewCell!
    @IBOutlet weak var priceLowHighCell: UITableViewCell!
    @IBOutlet weak var priceHighLowCell: UITableViewCell!
    
    // FILTER
    @IBOutlet weak var singleFamilyCell: UITableViewCell!
    @IBOutlet weak var condoCell: UITableViewCell!
    
    // MARK: Properties
    var sortDescriptor: NSSortDescriptor?
    var filterPredicate: NSPredicate?
    var delegate: FilterTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = tableView.cellForRow(at: indexPath)!
        selected.accessoryType = .checkmark
        
        switch selected {
            case locationCell:
                setSortDescriptor("city", isAscending: true)
            case priceLowHighCell:
                setSortDescriptor("price", isAscending: true)
            case priceHighLowCell:
                setSortDescriptor("price", isAscending: false)
            case singleFamilyCell, condoCell:
                setFilter(selected.textLabel!.text!)
            default:
                print("No cell selected")
        }
        
        if let delegate = self.delegate {
            delegate.updateData(self.filterPredicate, self.sortDescriptor)
            
        }
    }
    
    private func clearSortDescriptor() {
        self.sortDescriptor = nil
    }
    
    private func clearFilter() {
        self.filterPredicate = nil
    }
    
    private func setSortDescriptor(_ sortBy: String, isAscending: Bool) {
        self.sortDescriptor = NSSortDescriptor(key: sortBy, ascending: isAscending)
    }
    
    private func setFilter(_ filterBy: String) {
        self.filterPredicate = NSPredicate(format: "homeType = %@", filterBy)
    }
}
