//
//  SearchViewController.swift
//  Bull Up
//
//  Created by Jon-Tait Beason on 1/31/16.
//  Copyright © 2016 IOBI Education. All rights reserved.
//

import UIKit

func Main(block: Void -> Void) {
    dispatch_async(dispatch_get_main_queue(), block)
}

class SearchTableViewController: UIViewController, SegueHandlerType {
    
    enum SegueIdentifier: String {
        case UnwindToQuotes = "Unwind To QuotesVC"
    }
    
    // MARK: - Variables
    var parser = Parser()
    var networkManager = NetworkManager()
    var searchResults = [SearchResult]()
    var selectedSymbol: String?

    // MARK: - Outlets
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchTextFieldBoundary: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - Actions
    @IBAction func editingChanged(sender: UITextField) {
        if let text = sender.text where !text.isEmpty {
            networkManager.fetchDataForQuery(.Search(text))
            networkActivityStarted()
        } else {
            searchResults = []
            Main {
                self.searchTableView.hidden = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(
            true, completion: nil)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        parser.delegate = self
        networkManager.delegate = self
        searchTextField.delegate = self
        searchTextField.becomeFirstResponder()
        customizeUI()
    }

    // MARK: Helper Methods 
    private func networkActivityStarted() {
        searchResults.removeAll()
        Main {
            self.searchTableView.hidden = true
            self.activityIndicator.startAnimating()
            self.messageLabel.text = "Loading..."
        }
    }
    
    private func networkActivityStopped() {
        Main {
            self.activityIndicator.stopAnimating()
            self.searchTableView.hidden = false
            self.searchTableView.reloadData()
            self.messageLabel.text = "Search for company name or symbol."
        }
    }
    
    private func customizeUI() {
        searchTableView.hidden = true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        searchTextField.resignFirstResponder()
    }
}

extension SearchTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Search TableView Cell",
            forIndexPath: indexPath) as! SearchTableViewCell
        let searchResult = searchResults[indexPath.row]
        cell.configureCellForQuote(searchResult)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let symbol = searchResults[indexPath.row].symbol
        if symbol.rangeOfString("^") == nil {
            selectedSymbol = symbol
        }
        performSegueWithIdentifier(.UnwindToQuotes, sender: self)
    }
}

extension SearchTableViewController: NetworkManagerDelegate, ParserDelegate {
    // MARK: - Network Manager
    
    func handleErrorForQuery(query: QueryType, message: String) {
        switch query {
        case .Search(_):
            handleErrorWithMessage(message: message)
        default: break
        }
    }
    func handleErrorWithMessage(message message: String) {
        Main {
            self.messageLabel.text = message
            self.activityIndicator.stopAnimating()
        }
    }
    
    func dataForDataType(dataType: DataType) {
        parser.quotesForDataType(dataType)
    }
    
    // MARK: Parser
    func resultsReturned(results results: ResultType) {
        switch results {
        case let .Search(searchResults):
            self.searchResults = searchResults
            networkActivityStopped()
        default: break
        }
    }
}

extension SearchTableViewController: UITextFieldDelegate {}

