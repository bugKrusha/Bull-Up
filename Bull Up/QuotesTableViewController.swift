//
//  QuotesViewController.swift
//  Bull Up
//
//  Created by Jon-Tait Beason on 1/31/16.
//  Copyright © 2016 IOBI Education. All rights reserved.
//

import UIKit



class QuotesTableViewController: UIViewController, SegueHandlerType {
    
    // MARK: - Variables
    var stockManager = StockManager()
    var networkManager = NetworkManager()
    var parser = Parser()
    var stocks = [Stock]()
    var selectedIndex: Int?
    var initialLoad = true
    
    enum SegueIdentifier: String {
        case ShowSearch = "Show Search"
        case UnwindToQuotes = "Unwind To QuotesVC"
        case ShowQuoteDetail = "Show Quote Detail"
    }
    
    // MARK: - Outlets
    @IBOutlet weak var quotesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tapToAddQuoteButton: UIButton!
    @IBOutlet weak var tapToReloadButton: UIButton!
    
    
    // MARK: - Actions
    @IBAction func tapToReload(sender: UIButton) {
        loadSymbols()
    }

    @IBAction func addQuote(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier(.ShowSearch, sender: self)
    }
    
    @IBAction func unwindToQuotesVC(segue: UIStoryboardSegue) {
        let source = segue.sourceViewController
        let segueIdentifier = segueIdentifierForSegue(segue)
        
        switch segueIdentifier {
        case .UnwindToQuotes:
            guard let source = source as? SearchTableViewController,
                selectedSymbol = source.selectedSymbol
                else { return }
            addQuoteForSymbol(selectedSymbol)
        default: break
        }
    }
    
    @IBAction func tapToAddQuotes(sender: UIButton) {
        performSegueWithIdentifier(.ShowSearch, sender: self)
    }
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        parser.delegate = self
        networkManager.delegate = self
        setUpUIForLoading()
        loadSymbols()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        stockManager.saveChanges()
    }
    
    // MARK: - UI 
    private func setUpUIForLoading() {
        Main {
            self.tapToAddQuoteButton.hidden = true
            self.quotesTableView.hidden = true
            self.tapToReloadButton.hidden = true
            self.activityIndicator.startAnimating()
        }
    }
    
    // MARK: - Helper Methods
    private func loadSymbols() {
        setUpUIForLoading()
        let symbols = stockManager.symbols
        if symbols.isEmpty {
            noSymbolsToLoad()
            return
        }
        networkManager.fetchDataForQuery(.Symbols(symbols))
    }
    
    private func addQuoteForSymbol(symbol: String) {
        guard !stockManager.symbolExist(symbol)
            else { return }
        stockManager.addQuoteForSymbol(symbol: symbol)
        networkManager.fetchDataForQuery(.Symbols([symbol]))
    }
    
    private func noSymbolsToLoad() {
        Main {
            self.tapToAddQuoteButton.hidden = false
            self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var destination = segue.destinationViewController
        
        if let navcon = destination as? UINavigationController {
            destination = navcon.visibleViewController!
        }
        
        let segueIdentifier = segueIdentifierForSegue(segue)
        switch segueIdentifier {
        case .ShowQuoteDetail:
            /* DOESN'T WORK :weary: */
            guard let destination = destination as? QuoteDetailViewController,
                selectedIndexPath = quotesTableView.indexPathForSelectedRow
                else { return }
            
            destination.stock = stocks[selectedIndexPath.row]
            quotesTableView.deselectRowAtIndexPath(selectedIndexPath, animated:  false)
        default: break
        }
    }
    
    // MARK:- Helper Methods
    func showAlertWithMessage(message: String) {
        let alertController = UIAlertController(title: "Error",
            message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK",
            style: .Default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Reload", style: .Default, handler: { action in
            self.loadSymbols()
        }))
        
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alertController, animated: true,
                completion: nil)
        }
    }
}

extension QuotesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Quotes TableView Cell") as! QuotesTableViewCell
        let stock = stocks[indexPath.row]
        cell.configureCellForQuote(stock)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            stockManager.removeSymbolAtIndex(index: indexPath.row)
            stocks.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}

extension QuotesTableViewController: NetworkManagerDelegate, ParserDelegate {
    // MARK: - Network Manager
    func handleErrorWithMessage(message message: String) {
        print(message)
    }
    
    func dataForDataType(dataType: DataType) {
        parser.quotesForDataType(dataType)
    }
    
    // MARK: Parser
    func resultsReturned(results results: ResultType) {
        switch results {
        case let .Symbols(stocks):
            self.stocks += stocks
            Main {
                self.quotesTableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.quotesTableView.hidden = false
            }
            
            if initialLoad { initialLoad.flip() }
        default: break
        }
    }

    func handleErrorForQuery(query: QueryType, message: String) {
        showAlertWithMessage(message)
        Main {
            self.activityIndicator.stopAnimating()
            self.tapToReloadButton.hidden = false
            guard !self.initialLoad else { return }
            self.quotesTableView.hidden = false
        }
    }
}

