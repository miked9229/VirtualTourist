//
//  Photo+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Michael Doroff on 4/5/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation
import CoreData


public class Photo: NSManagedObject {
    
    
    convenience init(image: NSData, context: NSManagedObjectContext) {
        
        // An EntityDescription is an object that has access to all
        // the information you provided in the Entity part of the model
        // you need it to create an instance of this class.
        
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            self.init(entity: ent, insertInto: context)
            self.nsData = image
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
    

}
