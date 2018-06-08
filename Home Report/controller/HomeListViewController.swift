//
//  HomeListViewController.swift
//  Home Report
//
//  Created by Deborah Newberry on 6/6/18.
//  Copyright © 2018 Deborah Newberry. All rights reserved.
//

import UIKit
import CoreData
class HomeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterTableViewControllerDelegate {
    // MARK: Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    weak var managedObjectContext: NSManagedObjectContext! {
        didSet {
            return home = Home(context: managedObjectContext)
        }
    }
    lazy var homes = [Home]()
    var home: Home? = nil
    var isForSale: Bool = true
    var sortDescriptors = [NSSortDescriptor]()
    var filterPredicate: NSPredicate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        let selectedValue = sender.titleForSegment(at: sender.selectedSegmentIndex)
        self.isForSale = selectedValue == "For Sale" ? true : false
        self.loadData()
    }
    
    
    // MARK: Tableview datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeListTableViewCell
        
        let currentHome = self.homes[indexPath.row]
        cell.configureCell(currentHome)
        
        return cell
    }
    
    // MARK: Private function
    private func loadData() {
        self.homes = home!.filterHomes(filterPredicate, sortDescriptors, isForSale, managedObjectContext)
        self.tableView.reloadData()
    }
    
    func updateData(_ filterBy: NSPredicate?, _ sortBy: NSSortDescriptor?) {
        if let filter = filterBy {
            self.filterPredicate = filter
        }
        
        if let sort = sortBy {
            self.sortDescriptors.append(sort)
        }
        
        self.tableView.reloadData()
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saleHistorySegue" {
            let destination = segue.destination as! SaleHistoryViewController
            destination.managedObjectContext = self.managedObjectContext
            
            let selected = self.tableView.indexPathForSelectedRow
            destination.home = self.homes[selected!.row]
        } else if segue.identifier == "filterSegue" {
            self.sortDescriptors = []
            self.filterPredicate = nil
            let destination = segue.destination as! FilterTableViewController
            destination.delegate = self
        }
    }
    
}
