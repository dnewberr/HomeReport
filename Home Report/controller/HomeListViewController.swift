//
//  HomeListViewController.swift
//  Home Report
//
//  Created by Deborah Newberry on 6/6/18.
//  Copyright © 2018 Deborah Newberry. All rights reserved.
//

import UIKit
import CoreData
class HomeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        let selectedValue = sender.titleForSegment(at: sender.selectedSegmentIndex)
        isForSale = selectedValue == "For Sale" ? true : false
        loadData()
    }
    
    
    // MARK: Tableview datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeListTableViewCell
        
        let currentHome = homes[indexPath.row]
        cell.configureCell(currentHome)
        
        return cell
    }
    
    // MARK: Private function
    private func loadData() {
        homes = home!.getHomesByStatus(isForSale, managedObjectContext)
        tableView.reloadData()
    }
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saleHistorySegue" {
            let destination = segue.destination as! SaleHistoryViewController
            destination.managedObjectContext = self.managedObjectContext
            
            let selected = self.tableView.indexPathForSelectedRow
            destination.home = self.homes[selected!.row]
        }
     }

}
