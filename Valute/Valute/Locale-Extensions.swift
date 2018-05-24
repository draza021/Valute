//
//  Locale-Extensions.swift
//  Valute
//
//  Created by Drago on 5/24/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import Foundation

extension Locale {
    
    static func countryCode(for currencyCode: String) -> String {
        let cc = currencyCode.uppercased()
        switch cc {
        case "EUR":
            return "eu"
        case "USD":
            return "us"
        case "GBP":
            return "gb"
        case "AUD":
            return "au"
        case "CAD":
            return "ca"
        default:
            break
        }
        
        for rc in isoRegionCodes {
            let comps = [NSLocale.Key.countryCode.rawValue: rc]
            let localeIdentifier = Locale.identifier(fromComponents: comps)
            let locale = Locale(identifier: localeIdentifier)
            
            guard let localeCurrencyCode = locale.currencyCode else {
                continue
            }
            
            if currencyCode == localeCurrencyCode {
                return rc
            }
        }
        return "empty"
    }
}
