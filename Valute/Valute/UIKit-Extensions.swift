//
//  UIKit-Extensions.swift
//  Valute
//
//  Created by Drago on 5/14/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit


extension UIButton {
    var caption: String? {
        return self.title(for: .normal)
    }
}

extension NumberFormatter {
    static let decimalFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 2
        return nf
    }()
}


