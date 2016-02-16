//
//  Protocols.swift
//  Bull Up
//
//  Created by Jon-Tait Beason on 1/29/16.
//  Copyright © 2016 IOBI Education. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkConnectionDelegate {
    func fetchDataForQuery(query: QueryType)
}

protocol NetworkManagerDelegate: class {
    func dataForDataType(dataType: DataType)
    func handleErrorForQuery(query: QueryType, message: String)
}

protocol ManageStocks {
    mutating func addQuoteForSymbol(symbol symbol: String)
    mutating func removeSymbolAtIndex(index index: Int)
}

protocol Quote {
    var name: String { get set }
    var symbol: String { get set }
}

protocol ParserDelegate: class {
    func resultsReturned(results results: ResultType)
    func handleErrorWithMessage(message message: String)
    
}


protocol SegueHandlerType {
    typealias SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where
    Self: UIViewController,
    SegueIdentifier.RawValue == String {
    
    // Overload on UIKit's 'performSegueWithIdentifier'
    func performSegueWithIdentifier(segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        performSegueWithIdentifier(segueIdentifier.rawValue, sender: self)
    }
    
     /// segueIdentifierForSegue: Map a
     /// "StoryboardSegue" to the  segue identifier
     /// enum that it represents.
    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier,
            segueIdentifier = SegueIdentifier(rawValue: identifier) else {
                fatalError("Couldn't handle segue identifier \(segue.identifier)")
        }
        return segueIdentifier
    }
}




