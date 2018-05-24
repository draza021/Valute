//
//  CurrencyBoxView.swift
//  Valute
//
//  Created by Drago on 5/3/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit

final class CurrencyBox: UIControl {

    @IBOutlet private weak var flagView: UIImageView!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var textField: UITextField!
    
    //    Data model
    
    var currencyCode: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
            updateFlagView(currencyCode)
        }
    }
    
    var amount: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.isUserInteractionEnabled = false
        flagView.isUserInteractionEnabled = false
        label.isUserInteractionEnabled = false
    }
    
}

private extension CurrencyBox {
    
    func updateFlagView(_ cc: String?) {
        guard let cc = cc else {
            flagView.image = UIImage(named: "empty")
            return
        }
        
        let countryCode = Locale.countryCode(for: cc).lowercased()
        flagView.image = UIImage(named: countryCode) ?? #imageLiteral(resourceName: "empty") // image literal empty flag
    }
}







