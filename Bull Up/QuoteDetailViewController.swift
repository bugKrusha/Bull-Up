//
//  QuoteDetailViewController.swift
//  Bull Up
//
//  Created by Jon-Tait Beason on 2/4/16.
//  Copyright © 2016 IOBI Education. All rights reserved.
//

import UIKit

class QuoteDetailViewController: UIViewController {
    
    // MARK: - Variables 
    var stock: Stock?
    let numberOfRows = 4
    
    // MARK: - Outlets
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var daysHighLabel: UILabel!
    @IBOutlet weak var daysLowLabel: UILabel!
    @IBOutlet weak var yearLowLabel: UILabel!
    @IBOutlet weak var yearHighLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var averageDailyVolumeLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var ebitdaLabel: UILabel!

    // MARK: - Actions
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - UI
    func configureUI() {
        guard let stock = stock else { return }
        let percentChange = stock.percentChange
        if let positiveChange = percentChange.isPositive {
            
            if positiveChange {
                priceChangeLabel.textColor = .lightGreenColor()
                priceLabel.textColor = .lightGreenColor()
            }
    
            if stock.priceChange == "--" {
                priceChangeLabel.text = percentChange.change
            } else {
                priceChangeLabel.text = stock.priceChange + "(\(percentChange.change))"
            }
        }
        
        nameLabel.text = stock.name
        symbolLabel.text = stock.symbol
        priceLabel.text = stock.price
        daysHighLabel.text = stock.daysHigh
        daysLowLabel.text = stock.daysLow
        yearHighLabel.text = stock.yearHigh
        yearLowLabel.text = stock.yearLow
        volumeLabel.text = stock.volume
        averageDailyVolumeLabel.text = stock.averageDailyVolume
        marketCapLabel.text = stock.marketCap
        ebitdaLabel.text = stock.ebitda
        currencyLabel.text = stock.currency
    }
}
