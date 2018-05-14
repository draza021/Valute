//
//  TestDismissVC.swift
//  Valute
//
//  Created by Drago on 5/14/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit

class TestDismissVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    @IBAction func gotoAnotherVC() {
        let storyboard = UIStoryboard(name: "TestVC", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DismissViewController")
        show(vc, sender: self)
    }

}
