//
//  ViewController.swift
//  CarPark
//
//  Created by herlanggawibi on 06/28/2019.
//  Copyright (c) 2019 herlanggawibi. All rights reserved.
//

import UIKit
import CarPark

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.pushViewController(CarParkLibrary.listDefault(), animated: true)
    }


}

