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
    
    var cellArray:[IndexPath] = []
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    var pin: Pin? = nil
    var fetchedResultController: NSFetchedResultsController <Photo>!
    var newFetchedResultsController: NSFetchedResultsController <Pin>!
    
    override func viewDidLoad() {
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        self.fetchedResultController.delegate = self
        addIndividualPin()
        
    }
    
    @IBAction func newCollection(_ sender: Any) {
        
        let pin = fetchedResultController.sections?[0].objects?[0] as! Pin
        
        pin.photos = nil
    
        NetworkingHelpers().backgroundLoad(fetchcontroller: fetchedResultController as! NSFetchedResultsController<NSFetchRequestResult>)
        

    
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

        if let fc = fetchedResultController {
            
            print(fc.sections?[0].numberOfObjects)
            if let count = fc.sections?[0].numberOfObjects {
                return count
            } else {
                return 0
            }
  
        }
        return 0
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! ImageCollectionViewCell
 
        let photo = fetchedResultController.object(at: indexPath)
            
        let image = UIImage(data: photo.nsData as! Data)
            
            cell.myImageView.image = image

    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        fetchedResultController.managedObjectContext.delete(fetchedResultController.object(at: indexPath))
        
        print(fetchedResultController.managedObjectContext.deletedObjects)
        

    
    }
    
}

extension IndividualPinViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}
extension IndividualPinViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
        if type.rawValue == 1 {
            self.imageCollectionView.reloadData()
            
        }
        
        if type.rawValue == 2 {
            self.imageCollectionView.reloadData()
        }

        if type.rawValue == 4 {
            self.imageCollectionView.reloadData()
            
        }
        
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
  
        
    }
    
}

extension IndividualPinViewController: MKMapViewDelegate {
   
    public func addIndividualPin() {
    let individualPin = pin
    
    let lat = CLLocationDegrees((individualPin!.latitude))
    let long = CLLocationDegrees(individualPin!.longitude)
    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    mapView.addAnnotation(annotation)
    
    
    }
}








    
    
    
