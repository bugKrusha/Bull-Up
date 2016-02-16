//
//  NetworkManager.swift
//  Bull Up
//
//  Created by Jon-Tait Beason on 1/29/16.
//  Copyright © 2016 IOBI Education. All rights reserved.
//

import Foundation

enum DataType {
    case Symbols(NSData)
    case Search(NSData)
}

struct NetworkManager: NetworkConnectionDelegate {
    
    weak var delegate: NetworkManagerDelegate?
    
    func fetchDataForQuery(query: QueryType) {
        let composer = UrlComposer()
        guard let url = composer.returnUrlForQuery(query) else {
            delegate?.handleErrorForQuery(query, message: "Invalid Url.")
            return
        }
        
        let request = NSURLRequest(URL: url)
        NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            if let error = error {
                // respond based on query type
                self.delegate?.handleErrorForQuery(query,
                    message: error.localizedDescription)
                // FIX
                return
            }
            
            /* Needs a response for nil values for data and response*/
            guard let data = data, response = response as?
                NSHTTPURLResponse else {
                return
            }

            if response.statusCode == 200 {
                self.dataForQuery(query: query, data: data)
            } else {
                let errorMessage = NSLocalizedString("Network Error",
                    comment: "An error occurred. Try again later.")
                self.delegate?.handleErrorForQuery(query, message: errorMessage)
            }
        }.resume()
    }
    
    func dataForQuery(query query: QueryType, data: NSData) {
        switch query {
        case .Search(_):
            delegate?.dataForDataType(.Search(data))
        case .Symbols(_):
            delegate?.dataForDataType(.Symbols(data))
        }
    }
}