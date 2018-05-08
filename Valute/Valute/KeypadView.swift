//
//  KeypadView.swift
//  Valute
//
//  Created by Drago on 5/3/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit

final class KeypadView: UIView {
    @IBOutlet var digitButtons: [UIButton]!
    @IBOutlet var operatorButtons: [UIButton]!
    @IBOutlet weak var dotButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    var allButtons: [UIButton] {
        return digitButtons + operatorButtons + [dotButton] + [clearButton]
    }
    
    
}

extension KeypadView {
    
    
}
