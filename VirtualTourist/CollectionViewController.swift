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
    var fetchedResultController: NSFetchedResultsController <Pin>!
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
            print("\(fc) is non nil")
            
           print(fc.sections?.count)
            return 0
        } else {
            return 0
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        var photosArray: [Any]! = nil
        
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! ImageCollectionViewCell
 
        let photo = photosArray[indexPath.row] as? Photo
            
        let image = UIImage(data: photo?.nsData as! Data)
            
            cell.myImageView.image = image

    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        var photosArray: [Any]! = nil
        let pin = fetchedResultController.sections?[0].objects?[0] as? Pin
        if let objects = fetchedResultController.sections?[0].objects {
            let pin = objects[0] as! Pin
            photosArray = ((pin.photos?.allObjects)! as! [Photo])
            
        }
         let photo = (photosArray[indexPath.row] as! Photo)
  

    }
        
    
    
}


extension IndividualPinViewController {
    
    public func photoCount(objects: [Any]?) -> Int {
        if let objects = objects {
            for each in objects {
                guard let pin = each as? Pin else {
                    print("Could not get to pins")
                    return 0
                }
                return (pin.photos?.count)!
                
            }
            
        } else {
            return 0
        }
        
        return 0
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
    
        

        if type.rawValue == 4 {
//                let pin = controller.object(at: indexPath!) as! Pin
                //pin.removeFromPhotos(anObject)
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








    
    
    
