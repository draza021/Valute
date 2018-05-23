//
//  UserDefaults-Shared.swift
//  Valute
//
//  Created by Drago on 5/23/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import Foundation

extension UserDefaults {
    private enum Key : String {
        case sourceCC = "SourceCurrencyCode"
        case targetCC = "TargetCurrencyCode"
        case lastAmount = "LastAmount"
    }
    
    private static var defs: UserDefaults {
        return UserDefaults.standard
    }
    
    static var sourceCC: String {
        get {
            return defs.string(forKey: Key.sourceCC.rawValue) ?? "RSD"
        }
        set(value) {
            defs.set(value, forKey: Key.sourceCC.rawValue)
        }
    }
    
    static var targetCC: String {
        get {
            return defs.string(forKey: Key.targetCC.rawValue) ?? "EUR"
        }
        set(value) {
            defs.set(value, forKey: Key.targetCC.rawValue)
        }
    }
}
