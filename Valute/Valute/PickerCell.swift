//
//  PickerCell.swift
//  Valute
//
//  Created by Drago on 5/24/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit

final class PickerCell: UITableViewCell {

    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var flagView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        label.textColor = .white
    }

}

extension PickerCell {
    
    func populate(with currencyCode: String) {
        label.text = currencyCode
        updateFlagView(currencyCode)
    }
    
    private func updateFlagView(_ cc: String?) {
        guard let cc = cc else {
            flagView.image = UIImage(named: "empty")
            return
        }
        
        let countryCode = Locale.countryCode(for: cc).lowercased()
        flagView.image = UIImage(named: countryCode) ?? #imageLiteral(resourceName: "empty") // image literal empty flag
    }
}
