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
        fetchCurrencyRates()
    }
    
    private var ratesPerUSD = [String: Decimal]()
    
    func rate(for targetCC: String, versus sourceCC: String, callback: (Decimal?) -> Void) {
        guard
            let sourcePerUSD = ratesPerUSD[sourceCC],
            let targetPerUSD = ratesPerUSD[targetCC]
        else {
            callback(nil)
            return
        }
        let r = sourcePerUSD / targetPerUSD
        callback(r)
    }
}

private extension ExchangeManager {
    
    func fetchCurrencyRates() {
        guard let url = URL(string: "bklabla") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [unowned self] (data, response, error) in
            
            
            // validate
            // process
            
            
            self.ratesPerUSD = [:]
        }
        
    }
}
