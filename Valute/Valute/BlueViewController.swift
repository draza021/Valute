//
//  BlueViewController.swift
//  Valute
//
//  Created by Drago on 5/8/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit

class BlueViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "BlueViewController"

    }
    
    @IBAction func showRedVC() {
        let storyboard = UIStoryboard(name: "TestViewControllers", bundle: Bundle.main)
        let redVC = storyboard.instantiateViewController(withIdentifier: "RedViewController") as! RedViewController
        show(redVC, sender: self)
    }

}
