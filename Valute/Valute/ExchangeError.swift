//
//  ExchangeError.swift
//  Valute
//
//  Created by Drago on 5/31/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import Foundation

enum ExchangeError: Error {
    case fetchingRates
    case missingRate
    case invalidResponse
    
    case urlError(URLError)
}
