//
//  Double+Extension.swift
//  Home Report
//
//  Created by Deborah Newberry on 6/6/18.
//  Copyright © 2018 Deborah Newberry. All rights reserved.
//

import Foundation

extension Double {
    var currencyFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self))!
    }
}
