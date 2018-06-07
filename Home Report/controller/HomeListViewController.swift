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
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        let selectedVal = sender.titleForSegment(at: sender.selectedSegmentIndex)
        self.isForSale = selectedVal == "For Sale"
        
        print(isForSale)
        self.loadData()
    }
    
    // MARK: TableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homes.count
    }
    
    // MARK: TableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeListTableViewCell
        cell.configureCell(homes[indexPath.row])
        return cell
    }
    
    // MARK: Custom Functions
    private func loadData() {
        self.homes = home!.getHomesByStatus(self.isForSale, self.managedObjectContext)
        self.tableView.reloadData()
    }
}
