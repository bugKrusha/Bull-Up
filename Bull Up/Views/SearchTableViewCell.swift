//
//  SearchTableViewCell.swift
//  Bull Up
//
//  Created by Jon-Tait Beason on 1/31/16.
//  Copyright © 2016 IOBI Education. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var exchangeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Helper Methods 
    func configureCellForQuote(searchResult: SearchResult) {
        exchangeLabel.text = searchResult.exchange
        symbolLabel.text = searchResult.symbol
        nameLabel.text = searchResult.name
    }
}
