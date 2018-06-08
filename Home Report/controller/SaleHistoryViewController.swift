//
//  SaleHistoryViewController.swift
//  Home Report
//
//  Created by Deborah Newberry on 6/7/18.
//  Copyright © 2018 Deborah Newberry. All rights reserved.
//

import UIKit
import CoreData
class SaleHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    lazy var soldHistory = [SaleHistory]()
    var home: Home?
    weak var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        
        if let image = home?.image {
            self.imageView.image = UIImage(data: image)
            self.imageView.layer.borderWidth = 1
            self.imageView.layer.cornerRadius = 4
        }
        
        self.tableView.tableFooterView = UIView()
    }

    // MARK: Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.soldHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! SaleHistoryTableViewCell
        cell.configure(soldHistory[indexPath.row])
        return cell
    }
    
    // MARK: Functions
    func loadData() {
        self.soldHistory = SaleHistory(context: self.managedObjectContext!).getSoldHistory(self.home!, self.managedObjectContext!)
        self.tableView.reloadData()
    }
}
