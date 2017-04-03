//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Michael Doroff on 4/1/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mapView.delegate = self
        print(self.mapView.region.center.latitude)
        print(self.mapView.region.center.longitude)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        instantiatePinAtLocation(sender)
    
    }

    public func instantiatePinAtLocation(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: mapView)
        let tapPoint = mapView.convert(location, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = tapPoint
        mapView.removeAnnotation(annotation)
        mapView.addAnnotation(annotation)
    }
    
    
    
    
    
}
