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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mapView.delegate = self
        
        
        // Set MapView Values From User Defaults
        
        setMapValues()

        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
    

         let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        
        
     
        let pins = try? delegate.stack.context.fetch(fr) as? [Pin]
        print("pins from function: \(pins)")
        
        fr.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true),
                              NSSortDescriptor(key: "longitude", ascending: true)]
        
        print(pins??[0])
        
        
        let coordinate = CLLocationCoordinate2D(latitude: (pins??[0].latitude)!, longitude: (pins??[0].longitude)!)
        
        print(coordinate)
        
         let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate
        
        performUIUpdatesOnMain {
            
            self.mapView.addAnnotation(annotation)
        }
        
  
        
        
    
      /*   let fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil) */
    
        let pinCount =  try? delegate.stack.context.count(for: NSFetchRequest(entityName: "Pin"))
        let photoCount = try? delegate.stack.context.count(for: NSFetchRequest(entityName: "Photo"))
        print("\(pinCount) Pins Found")
        print("\(photoCount) Photos Found")
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        print(sender.isEnabled)
        instantiatePinAtLocation(sender)
    
    }

    public func instantiatePinAtLocation(_ sender: UILongPressGestureRecognizer) {
       
        let location = sender.location(in: mapView)
        let tapPoint = mapView.convert(location, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = tapPoint
        mapView.addAnnotation(annotation)
        
        sender.isEnabled = false
        sender.isEnabled = true
        
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


    
}
