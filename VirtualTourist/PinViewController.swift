//
//  PinViewController.swift
//  VirtualTourist
//
//  Created by Michael Doroff on 4/7/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation
import UIKit

class PinViewController: UIViewController {
    
    var Pin: Pin!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            let backbutton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backbutton
        navigationItem.title = ""
        
    }
    
    
    func back() {
        let _ = navigationController?.popToRootViewController(animated: true)
    }
    
}
