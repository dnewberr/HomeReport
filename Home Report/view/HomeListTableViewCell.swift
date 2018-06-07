//
//  HomeListTableViewCell.swift
//  Home Report
//
//  Created by Deborah Newberry on 6/6/18.
//  Copyright © 2018 Deborah Newberry. All rights reserved.
//

import UIKit

class HomeListTableViewCell: UITableViewCell {
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bedsLabel: UILabel!
    @IBOutlet weak var bathsLabel: UILabel!
    @IBOutlet weak var sqftLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(_ home: Home) {
        self.cityLabel.text = home.city
        self.categoryLabel.text = home.homeType
        
        self.priceLabel.text = home.price.currencyFormatter
        self.bedsLabel.text = String(home.bed)
        self.bathsLabel.text = String(home.bath)
        self.sqftLabel.text = String(home.sqft)
        
        self.homeImageView.image = UIImage(data: home.image! as Data)
        self.homeImageView.layer.borderWidth = 1
        self.homeImageView.layer.cornerRadius = 4
        self.homeImageView.clipsToBounds = true
    }
}
