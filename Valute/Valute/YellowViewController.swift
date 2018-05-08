//
//  YellowViewController.swift
//  Valute
//
//  Created by Drago on 5/8/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit

class YellowViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "YellowViewController"
        
        
    }

    @IBAction func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
