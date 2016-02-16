//
//  SearchResult.swift
//  Bull Up
//
//  Created by Jon-Tait Beason on 1/30/16.
//  Copyright © 2016 IOBI Education. All rights reserved.
//

import Foundation

struct SearchResult {
    var name = ""
    var symbol = ""
    var exchange = ""
    
    init(quote: [String: AnyObject]) {
        self.name = quote["name"] as? String ?? "--"
        self.symbol = quote["symbol"] as? String ?? "--"
        self.exchange = quote["exchDisp"] as? String ?? "--"
    }
}