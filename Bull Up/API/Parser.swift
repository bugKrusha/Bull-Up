//
//  Parser.swift
//  Bull Up
//
//  Created by Jon-Tait Beason on 1/29/16.
//  Copyright © 2016 IOBI Education. All rights reserved.
//

import Foundation

enum Result<T> {
    case Error(NSError)
    case Value(T)
}

enum ResultType {
    case Symbols([Stock])
    case Search([SearchResult])
}

struct Parser {
    weak var delegate: ParserDelegate?
    
    func quotesForDataType(dataType: DataType) {
        switch dataType {
        case let .Search(data):
            serialize(data: data) { result in
                self.parseSearchResult(result)
            }
        case let .Symbols(data):
            serialize(data: data) { result in
                self.parseQuotes(result)
            }
        }
    }
    
    /// serialize: accepts JSON data to be serialized
    /// - Parameter data: Sson data downloaded from the web
    /// - Parameter callBack: AJclosure that takes Result as a
    /// parameter. This closure handles a parsing error if one occurs.
    private func serialize(data data: NSData, callBack: (Result<[String: AnyObject]>) -> ()) {
        do {
            let objects = try NSJSONSerialization
                .JSONObjectWithData(data, options: .AllowFragments)
            if let node = objects as? [String: AnyObject] {
                callBack(.Value(node))
            }
        } catch let caught as NSError {
            callBack(.Error(caught))
        }
    }
    
    /// parseSearchResult: Parses Json from search results.
    private func parseSearchResult(result: Result<[String: AnyObject]>) {
            
        switch result {
        case let .Value(value):
            guard let quoteDictionary = value["ResultSet"]
                as? [String: AnyObject],
                quoteArray = quoteDictionary["Result"]
            as? [[String: AnyObject]] else { return }
            
            let stocks: [SearchResult] = quoteArray.map { quote in
                return SearchResult(quote: quote)
            }
            guard !stocks.isEmpty else {
                delegate?.handleErrorWithMessage(message: "No Results Found.")
                return
            }
            delegate?.resultsReturned(results: .Search(stocks))
        // FIX
        case let .Error(error):
            delegate?.handleErrorWithMessage(message: error.localizedDescription)
        }
        
    }
    
    /// parseSearchQuotes: Parses Json for a set of symbols.
    private func parseQuotes(result: Result<[String: AnyObject]>) {
        switch result {
        case let .Value(value):
            guard let queryDictionary = value["query"]
                as? [String: AnyObject],
                resultDictionary = queryDictionary["results"]
                as? [String: AnyObject] else { return }
            
            var stocks = [Stock]()
            if let quoteArray = resultDictionary["quote"] as? [[String: AnyObject]] {
                stocks = mapQuotes(quoteArray)
            } else if let quote = resultDictionary["quote"] as? [String: AnyObject] {
                stocks = mapQuotes([quote])
            }
            delegate?.resultsReturned(results: .Symbols(stocks))
            
        // FIX
        case let .Error(error):
            delegate?.handleErrorWithMessage(message: error.localizedDescription)
        }
    }
    
    private func mapQuotes(results: [[String: AnyObject]]) -> [Stock] {
        return results.map { quote  in
            return Stock(quote: quote)
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
