//
//  Stock.swift
//  Bull Up
//
//  Created by Jon-Tait Beason on 1/30/16.
//  Copyright © 2016 IOBI Education. All rights reserved.
//

import Foundation

struct Stock {
    var name = ""
    var symbol = ""
    var open = ""
    var daysHigh = ""
    var daysLow = ""
    var volume = ""
    var averageDailyVolume = ""
    var yearHigh = ""
    var yearLow = ""
    var marketCap = ""
    var ebitda = ""
    var priceChange = ""
    var currency = ""
    var price = ""
    var percentChange: (change: String, isPositive: Bool?) = ("--", nil)
    
    init(quote: [String: AnyObject]) {
        self.name = quote["Name"] as? String ?? "--"
        self.symbol = quote["symbol"] as? String ?? "--"
        self.averageDailyVolume = quote["AverageDailyVolume"] as? String ?? "--"
        self.yearHigh = quote["YearHigh"] as? String ?? "--"
        self.yearLow = quote["YearLow"] as? String ?? "--"
        self.marketCap = quote["MarketCapitalization"] as? String ?? "--"
        self.open = quote["Open"] as? String ?? "--"
        self.daysHigh = quote["DaysHigh"] as? String ?? "--"
        self.daysLow = quote["DaysLow"] as? String ?? "--"
        self.volume = quote["Volume"] as? String ?? "--"
        self.priceChange = quote["Change"] as? String ?? "--"
        self.ebitda = quote["EBITDA"] as? String ?? "--"
        self.currency = quote["Currency"] as? String ?? "--"
        
        if let ask = quote["Ask"] as? String,
            price = formatString(ask) {
            self.price = price
        }
        
        if let percentChange = quote["PercentChange"] as? String {
            self.percentChange = (percentChange,
                percentChange.characters.contains("+"))
        }
    }
    
    private func formatString(input: String) -> String? {
        guard let input = stringAsDouble(input)
            else { return nil}
        return String(format: "%.02f", input)
    }
    
    private func stringAsDouble(input: String) -> Double? {
        return NSNumberFormatter().numberFromString(input)?
            .doubleValue
    }
}