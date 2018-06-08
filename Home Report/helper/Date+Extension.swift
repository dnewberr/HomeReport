
//
//  Date+Extention.swift
//  Home Report
//
//  Created by Deborah Newberry on 6/7/18.
//  Copyright © 2018 Deborah Newberry. All rights reserved.
//

import Foundation

extension Date {
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self)
    }
}
