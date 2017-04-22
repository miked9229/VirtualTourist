//
//  CollectionViewController.swift
//  VirtualTourist
//
//  Created by Michael Doroff on 4/14/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import MapKit

class IndividualPinViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    

    var fetchedResultController: NSFetchedResultsController <NSFetchRequestResult>!
    
    
    override func viewDidLoad() {
        print("Method called")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        let backbutton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backbutton
        
    }
    
    func back() {
        let _ = navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photoCount(objects: fetchedResultController.sections?[0].objects)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        return cell
    }

    
}


extension IndividualPinViewController {
    
    
    public func photoCount(objects: [Any]?) -> Int {
        print("Photo Count Method called")
        if let objects = objects {
            for each in objects {
                guard let pin = each as? Pin else {
                    print("Could not get to pins")
                    return 0
                }
                print("\(pin.photos?.count)")
                return (pin.photos?.count)!
                
            }
            
        } else {
            return 0
        }
        
        return 0
    }

    
}
