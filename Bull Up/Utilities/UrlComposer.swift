//
//  UrlComposer.swift
//  Bull Up
//
//  Created by Jon-Tait Beason on 1/27/16.
//  Copyright © 2016 IOBI Education. All rights reserved.
//

import Foundation

enum QueryType {
    case Symbols([String])
    case Search(String)
}

struct UrlComposer {
    
    /// returnUrlForQuery: returns a url based on on the Query type.
    /// Search can be done with name, quotes etc but a symbol search
    /// requires valid symbols.
    func returnUrlForQuery(query: QueryType) -> NSURL? {
        switch query {
        case let .Symbols(symbols):
            let urlString = createUrlStringForSymbols(symbols)
            guard validUrlString(urlString) else { return nil }
            return NSURL(string: urlString)
        
        case let .Search(quote):
            let quoteWithoutSpace = quote.stringByReplacingOccurrencesOfString(" ", withString: "")
            let urlString = StringConstants.searchUrlPrefix + quoteWithoutSpace +
                StringConstants.searchUrlSuffix
            guard validUrlString(urlString) else { return nil }
            return NSURL (string: urlString)
        }
    }
    
    private func validUrlString(string: String) -> Bool {
        if let _ = string.stringByAddingPercentEncodingWithAllowedCharacters(
            NSCharacterSet.URLHostAllowedCharacterSet()) {
            return true
        }
        return false
    }
    
    private func createUrlStringForSymbols(symbols: [String]) -> String {
        var urlString = ""
        
        // sample symbls array ["ARI", "ARO", "CAF", "CAE"]
        // necessary to add separator between each symbol
        // as mandated by Yahoo Finance API
        let n = symbols.count - 1
        for (index, symbol) in symbols.enumerate() {
            switch index {
            case n:
                urlString = urlString + StringConstants.border +
                    symbol + StringConstants.border
            default:
                urlString = urlString + StringConstants.border +
                    symbol + StringConstants.border + StringConstants.separator
            }
        }
        return StringConstants.symbolsUrlPrefix +
            urlString + StringConstants.symbolsUrlSuffix
    }
}

extension UrlComposer {
    private struct StringConstants {
        static let symbolsUrlPrefix = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20("
        static let symbolsUrlSuffix = ")%0A%09%09&env=http%3A%2F%2Fdatatables.org%2Falltables.env&format=json"
        static let searchUrlPrefix = "http://d.yimg.com/autoc.finance.yahoo.com/autoc?query="
        static let searchUrlSuffix = "&region=US&lang=en-US"
        static let border = "%22"
        static let separator = "%2C"
    }
}