//
//  PickerController.swift
//  Valute
//
//  Created by Drago on 5/3/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit

protocol PickerControllerDelegate: class {
    func pickerController(_ controller: PickerController, didSelectCurrency cc: String)
}

final class PickerController: UIViewController {

    var currencies: [String] = [] {
        didSet {
            //    TBD: nesto
        }
    }
    
    weak var delegate: PickerControllerDelegate?

}
