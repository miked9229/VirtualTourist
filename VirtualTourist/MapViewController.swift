//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Michael Doroff on 4/1/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation
import MapKit
import CoreData


class MapViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var annotationView: MKAnnotationView?
    
    var count = 0

    
    var pins: [Pin]!

    
    lazy var fetchedResultController: NSFetchedResultsController <NSFetchRequestResult> = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest<Pin>(entityName: "Pin")
        let sortDescriptor1 = NSSortDescriptor(key: "latitude" , ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "longitude" , ascending: true)
        fr.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: (stack.context), sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchedResultController.delegate = self
        
        // Set MapView Values From User Defaults
        
        setMapValues()
        checkSelectedAnnotations()
        
    }
    
    override func viewDidLoad() {
        var objects: [Any]?
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let _ = delegate.stack
        super.viewDidLoad()
        self.mapView.delegate = self
        
        do {
            try fetchedResultController.performFetch()
          
            objects = (fetchedResultController.sections?[0].objects)!
        } catch let err {
            print(err)
        }
        AddPins(objects: objects)
        
    }
 
    
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        instantiatePinAtLocation(sender)
        
    
    }

    public func instantiatePinAtLocation(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {

            let delegate = UIApplication.shared.delegate as! AppDelegate
            let stack = delegate.stack
            let location = sender.location(in: mapView)
            let tapPoint = mapView.convert(location, toCoordinateFrom: mapView)
            let _ = Pin(latitude: tapPoint.latitude, longitude: tapPoint.longitude, context: stack.context)
            let annotation = MKPointAnnotation()
            annotation.coordinate = tapPoint
            
            mapView.addAnnotation(annotation)
            
            sender.isEnabled = false
            sender.isEnabled = true
            
            stack.save()
                
        }
   
    }
    
    public func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
  
        UserDefaults.standard.set(mapView.region.center.latitude, forKey: "latitudeKey")
        UserDefaults.standard.set(mapView.region.center.longitude, forKey: "longitudeKey")
        UserDefaults.standard.set(mapView.region.span.latitudeDelta, forKey: "latitudeDeltaKey")
        UserDefaults.standard.set(mapView.region.span.longitudeDelta, forKey: "longitudeDeltaKey")
    }
    

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        
        let latpredicate = NSPredicate(format: "latitude == %lf", (view.annotation?.coordinate.latitude)!)
        
        let longpredicate = NSPredicate(format: "longitude == %lf", (view.annotation?.coordinate.longitude)!)
        
       let andrequest = NSCompoundPredicate(type: .and, subpredicates: [latpredicate, longpredicate])
        
       fetchedResultController.fetchRequest.predicate = andrequest
        
        do {
            try fetchedResultController.performFetch()
            
           passFetchedResulController(fetchcontroller: fetchedResultController)
    
        } catch let err {
            print(err)

        }
       
}

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//            print(anObject)
    }


    public func checkSelectedAnnotations() {
        if !(mapView.selectedAnnotations.isEmpty) {

            mapView.deselectAnnotation(mapView.selectedAnnotations[0], animated: true)
        }
        
    }
    
}

extension MapViewController {
    
    public func AddPins(objects: [Any]?) {
        
        if let objects = objects {
            for each in objects {
                guard let pin = each as? Pin else {
                    print("Could not get to pins")
                    return
                }
                let lat = CLLocationDegrees(pin.latitude)
                let long = CLLocationDegrees(pin.longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                mapView.addAnnotation(annotation)
            }
            
        }
    }

    public func setMapValues() {
        
        let span = MKCoordinateSpanMake(UserDefaults.standard.double(forKey: "latitudeDeltaKey"), UserDefaults.standard.double(forKey: "longitudeDeltaKey"))
        
        let location = CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "latitudeKey"), longitude: UserDefaults.standard.double(forKey: "longitudeKey"))
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.mapView.setRegion(region, animated: true)
        
    }
    
    
    public func passFetchedResulController(fetchcontroller: NSFetchedResultsController <NSFetchRequestResult>) {
        FlickrClient.sharedInstance().getPhotos(latitude: returnLatitudeOrLongitude(fetchcontroller: fetchcontroller, latOrLong: "lat"), longitude: returnLatitudeOrLongitude(fetchcontroller: fetchcontroller, latOrLong: "long")) {(sucess, data, error) in
            
            if sucess {
                
                performUIUpdatesOnMain {
                    let controller = self.storyboard?.instantiateViewController(withIdentifier:"IndividualPinViewController") as! IndividualPinViewController
                    controller.fetchedResultController = fetchcontroller
                    self.navigationController?.pushViewController(controller, animated: true)
                }

            } else {
                print("There was an error")
            }
            
            
            
        }
 
        
    }

    public func returnLatitudeOrLongitude(fetchcontroller: NSFetchedResultsController <NSFetchRequestResult>, latOrLong: String) -> Double {
        
        
        let pin = (fetchcontroller.sections?[0].objects)?[0] as! Pin
        if latOrLong == "lat" {
          
             return pin.latitude
            
        }
        else {
            return pin.longitude
        }
        

    }

    

}


