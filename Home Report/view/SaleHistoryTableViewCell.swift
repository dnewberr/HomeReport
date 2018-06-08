//
//  SaleHistoryTableViewCell.swift
//  Home Report
//
//  Created by Deborah Newberry on 6/7/18.
//  Copyright © 2018 Deborah Newberry. All rights reserved.
//

import UIKit

class SaleHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var soldDateLabel: UILabel!
    @IBOutlet weak var soldPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ saleHistory: SaleHistory) {
        self.soldDateLabel.text = saleHistory.soldDate?.toString
        self.soldPriceLabel.text = saleHistory.soldPrice.currencyFormatter
    }
}
