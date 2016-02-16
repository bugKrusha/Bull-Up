//
//  StockManager.swift
//  Bull Up
//
//  Created by Jon-Tait Beason on 1/29/16.
//  Copyright © 2016 IOBI Education. All rights reserved.
//

import Foundation

struct StockManager: ManageStocks {
    
    private enum StringConstants: String {
        case Symbols = "Symbols"
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    private var changes = false
    
    private(set) lazy var symbols:[String] = {
        guard let symbolsArray = self.defaults.arrayForKey(StringConstants.Symbols.rawValue),
            let symbols = symbolsArray as? [String]
            else {
                return  []
        }
        return symbols
    }()
    
    // Q: Why mutating?
    mutating func symbolExist(symbol: String) -> Bool {
        return symbols.contains(symbol)
    }
    
    mutating func addQuoteForSymbol(symbol symbol: String) {
        symbols.append(symbol)
        saveChanges()
    }
    
    mutating func removeSymbolAtIndex(index index: Int) {
        symbols.removeAtIndex(index)
        saveChanges()
    }
    
    mutating func saveChanges() {
        defaults.setValue(symbols, forKey: StringConstants.Symbols.rawValue)
    }
}

extension Bool {
    mutating func flip() {
        self = !self
    }
}