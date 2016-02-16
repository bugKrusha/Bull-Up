//
//  QuotesTableViewCell.swift
//  Bull Up
//
//  Created by Jon-Tait Beason on 1/31/16.
//  Copyright © 2016 IOBI Education. All rights reserved.
//

import UIKit

class QuotesTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Helper Methods 
    func configureCellForQuote(stock: Stock) {
        symbolLabel.text = stock.symbol
        nameLabel.text = stock.name
        priceLabel.text = stock.price

        if let positiveChange = stock.percentChange.isPositive where positiveChange {
            priceLabel.textColor = UIColor.lightGreenColor()
        }
    }
}

extension UIColor {
    class func lightGreenColor() -> UIColor {
        return UIColor(red:0.16, green:0.8, blue:0.71, alpha:1.0)
    }
    class func lightPinkColor() -> UIColor {
        return UIColor(red:0.95, green:0.61, blue:0.61, alpha:1.0)
    }
    class func darkGreenColor() -> UIColor {
        return UIColor(red:0.13, green:0.43, blue:0.39, alpha:1.0)
    }
}