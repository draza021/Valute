//
//  RedViewController.swift
//  Valute
//
//  Created by Drago on 5/8/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit

class RedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "RedViewController"
        
    }
    
    @IBAction func showYellowVC() {
        let storyboard = UIStoryboard(name: "TestViewControllers", bundle: Bundle.main)
        if let yellowVC = storyboard.instantiateViewController(withIdentifier: "YellowViewController") as? YellowViewController {
            show(yellowVC, sender: self)
        }
    }
}
