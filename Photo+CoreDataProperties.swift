//
//  Photo+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Michael Doroff on 4/5/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var nsData: NSData?
    @NSManaged public var pin: Pin?

}
