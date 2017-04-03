//
//  MapLocations.swift
//  VirtualTourist
//
//  Created by Michael Doroff on 4/1/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation


class MapLocations {
    let location = [IndividualMapLocation]()
    static let sharedInstance = MapLocations()
    private init() {}
    
    
    
}

struct IndividualMapLocation {
    var latitutde: Double
    var longitude: Double
    
    init(_ latitude: Double, _ longitude: Double) {
        self.latitutde = latitude
        self.longitude = longitude
        
    }
    
}
