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


class MapViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate  {

    @IBOutlet weak var mapView: MKMapView!

    
    var pins: [Pin]!
    
    lazy var fetchedResultController: NSFetchedResultsController <NSFetchRequestResult> = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest<Pin>(entityName: "Pin")

        fr.sortDescriptors = []
        
        //   fr.predicate = pred
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: (stack.context), sectionNameKeyPath: nil, cacheName: nil)
        
        
        return fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>
        
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchedResultController.delegate = self
        
        // Set MapView Values From User Defaults
        
        setMapValues()
    }
    

    override func viewDidLoad() {
        var objects: [Any]?
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        super.viewDidLoad()
        self.mapView.delegate = self
        
        do {
            try fetchedResultController.performFetch()
          
            print(123)
            print(stack)
            objects = (fetchedResultController.sections?[0].objects)!
            print(objects)
        } catch let err {
            print(err)
        }
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
    
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        print(sender.isEnabled)
        instantiatePinAtLocation(sender)
        
    
    }

    public func instantiatePinAtLocation(_ sender: UILongPressGestureRecognizer) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        print(stack)
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
    
    public func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
  
        UserDefaults.standard.set(mapView.region.center.latitude, forKey: "latitudeKey")
        UserDefaults.standard.set(mapView.region.center.longitude, forKey: "longitudeKey")
        UserDefaults.standard.set(mapView.region.span.latitudeDelta, forKey: "latitudeDeltaKey")
        UserDefaults.standard.set(mapView.region.span.longitudeDelta, forKey: "longitudeDeltaKey")
    }
    
    public func setMapValues() {
        
        let span = MKCoordinateSpanMake(UserDefaults.standard.double(forKey: "latitudeDeltaKey"), UserDefaults.standard.double(forKey: "longitudeDeltaKey"))
        
        let location = CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "latitudeKey"), longitude: UserDefaults.standard.double(forKey: "longitudeKey"))
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.mapView.setRegion(region, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

  
    let fr = NSFetchRequest<Pin>(entityName: "Pin")
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let stack = delegate.stack
        
    print(stack)
     let latpredicate = NSPredicate(format: "latitude == %f", (view.annotation?.coordinate.latitude)!)
      let longpredicate = NSPredicate(format: "longitude == %f", (view.annotation?.coordinate.longitude)!)
        
      let pred = NSCompoundPredicate(andPredicateWithSubpredicates: [latpredicate, longpredicate])
        
        fr.sortDescriptors = []
        fr.predicate = pred
        
        do {
            try fetchedResultController.performFetch()
              // print(fetchedResultController.sections?[0].objects)
    
        } catch let err {
            print(err)

        }
  

    }
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
    didChange sectionInfo: NSFetchedResultsSectionInfo,
    atSectionIndex sectionIndex: Int,
    for type: NSFetchedResultsChangeType) {
       
      print("Method called")
    }
    
}
