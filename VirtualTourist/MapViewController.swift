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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mapView.delegate = self
        
        
        // Set MapView Values From User Defaults
        
        setMapValues()

        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
         let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        
        do {
            
            try pins = stack.context.fetch(fr) as! [Pin]
            
            
        } catch {
            pins = []
        }
            
            
        
        print("pins from function: \(pins)")
        
      //  fr.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true),
        //                      NSSortDescriptor(key: "longitude", ascending: true)]
        
        print(pins[1])
        print(pins[0])
        
        
        let coordinate1 = CLLocationCoordinate2D(latitude: (pins[1].latitude), longitude: (pins[1].longitude))
        
        let coordinate0 = CLLocationCoordinate2D(latitude: (pins[0].latitude), longitude: (pins[0].longitude))
        
        
        print(coordinate1)
        
        print(coordinate0)
        
         let annotation1 = MKPointAnnotation()
        let annotation2 = MKPointAnnotation()
        
        
        annotation1.coordinate = coordinate1
        annotation2.coordinate = coordinate0
        
        
        
        performUIUpdatesOnMain {
            
            self.mapView.addAnnotation(annotation1)
            self.mapView.addAnnotation(annotation2)
        }
        
  
   
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PinViewController")
        navigationController?.pushViewController(vc!, animated: true)
        
    let doo = Int64((view.annotation?.coordinate.latitude)!)
        
        
    
    
    let latitudepredicate = NSPredicate(format: "latitude = %@", "latitude", doo)
       
       var newpins: [Pin]!
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
    
        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
  
    
        fetchRequest1.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true)]
        
        fetchRequest1.predicate = NSPredicate(format: "latitude == %@", (view.annotation?.coordinate.latitude)!)
        
        
        do {
            
            try newpins = stack.context.fetch(fetchRequest1) as? [Pin]
            
            
        } catch {
            newpins = []
        }
        
        

        print(newpins)
    
    }


    
    
}
