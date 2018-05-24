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

    @IBOutlet private weak var tableView: UITableView!
    
    var currencies: [String] = [] {
        didSet {
            //    TBD: nesto
        }
    }
    
    weak var delegate: PickerControllerDelegate?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
}

private extension PickerController {
    
    func configureUI() {
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "globalbg"))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 54
    }
}

extension PickerController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PickerCell.reuseIdentifier, for: indexPath) as! PickerCell
        cell.populate(with: currencies[indexPath.row])
        return cell
    }
}

extension PickerController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cc = currencies[indexPath.row]
        delegate?.pickerController(self, didSelectCurrency: cc)
    }
}

