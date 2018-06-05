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

extension ExchangeError {
    var title: String? {
        switch self {
        case .fetchingRates, .missingRate, .invalidResponse:
            return nil
        case .urlError(let urlError):
            return nil
        }
    }
    
    var message: String? {
        switch self {
        case .fetchingRates:
            return NSLocalizedString("Download in progress...", comment: "")
        case .missingRate:
            return NSLocalizedString("Unavailable rate for current combination...", comment: "")
        case .invalidResponse:
            return NSLocalizedString("Unexpected response from service. Please try again later.", comment: "")
        case .urlError(let urlError):
            return urlError.localizedDescription
        }
    }
}
