//
//  ExchangeManager.swift
//  Valute
//
//  Created by Drago on 5/29/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import Foundation

final class ExchangeManager {
    
    static let shared = ExchangeManager()
    private init() {
        //fetchCurrencyRates()
    }
    
    private var defaultCurrencyCode: String = "USD"
    private var ratesPerUSD = [String: Decimal]()
    private var lastUpdated: Date?
    private var isDownloading: Bool = false
    
    func rate(for targetCC: String, versus sourceCC: String, callback: @escaping (Decimal?, ExchangeError?) -> Void) {
        guard
            let sourcePerUSD = ratesPerUSD[sourceCC],
            let targetPerUSD = ratesPerUSD[targetCC]
        else {
            if isDownloading {
                callback(nil, ExchangeError.fetchingRates)
                return
            }
            if lastUpdated == nil {
                fetchCurrencyRates(for: targetCC, versus: sourceCC, callback: callback)
                callback(nil, ExchangeError.fetchingRates)
            }
            
            callback(nil, ExchangeError.missingRate)
            return
        }
        let r = targetPerUSD / sourcePerUSD
        callback(r, nil)
    }
}

private extension ExchangeManager {
    
    func fetchCurrencyRates(for targetCC: String, versus sourceCC: String, callback: @escaping (Decimal?, ExchangeError?) -> Void = {_, _ in }) {
        if isDownloading { return }
        let stringURL = "http://apilayer.net/api/live?access_key=36a25821434ed9aec7b02d7c50b0ee77"
        let url = URL(string: stringURL)!
        
        let task = URLSession.shared.dataTask(with: url) {
            [unowned self] (data, response, error) in
            
            self.isDownloading = false
            
            // validate
            if let error = error {
                callback(nil, ExchangeError.urlError(error as! URLError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                callback(nil, ExchangeError.invalidResponse)
                return
            }
            
            if !(200..<300).contains(httpResponse.statusCode) {
                callback(nil, ExchangeError.invalidResponse)
                return
            }
            
            guard let data = data else {
                callback(nil, ExchangeError.missingRate)
                return
            }
            
            // process
            guard let obj = try? JSONSerialization.jsonObject(with: data, options: []),
                let json = obj as? [String: Any]
                else {
                    callback(nil, ExchangeError.invalidResponse)
                    return
            }
            
            guard let quotes = json["quotes"] as? [String: Double] else {
                callback(nil, ExchangeError.invalidResponse)
                return
            }
            
            var dict: [String: Decimal] = [:]
            for (key, value) in quotes {
                if key == "\(self.defaultCurrencyCode)\(self.defaultCurrencyCode)" {
                    dict[self.defaultCurrencyCode] = Decimal(value)
                    continue
                }
                let newKey = key.replacingOccurrences(of: self.defaultCurrencyCode, with: "")
                dict[newKey] = Decimal(value)
            }
            
            self.ratesPerUSD = dict
            self.lastUpdated = Date()
            self.rate(for: targetCC, versus: sourceCC, callback: callback)
        }
        
        isDownloading = true
        task.resume()
    }
}












