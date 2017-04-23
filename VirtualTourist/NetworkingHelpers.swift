//
//  NetworkingHelpers.swift
//  VirtualTourist
//
//  Created by Michael Doroff on 4/23/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class NetworkingHelpers {
    
    
    public func backgroundLoad(fetchcontroller: NSFetchedResultsController <NSFetchRequestResult>) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        if let coord = stack.context.persistentStoreCoordinator {
            let bckgContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            bckgContext.persistentStoreCoordinator = coord
            
            bckgContext.perform( {
                
                FlickrClient.sharedInstance().getPhotos(latitude: MapViewController().returnLatitudeOrLongitude(fetchcontroller: fetchcontroller, latOrLong: "lat"), longitude: MapViewController().returnLatitudeOrLongitude(fetchcontroller: fetchcontroller, latOrLong: "long")) {(sucess, data, error) in
                    
                    
                    
                    if let data = data {
                        self.appendToPin(data: data, fetchcontroller: fetchcontroller)
                        
                        
                    }
                    
                    
                }
                
                
                
                
            })
            
            
        }
        
        
    }
    
    public func appendToPin(data: [[String: AnyObject]], fetchcontroller: NSFetchedResultsController <NSFetchRequestResult>) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        if let object = fetchcontroller.sections?[0].objects {
            for each in object {
                guard let pin = each as? Pin else {
                    print("Could not get to pins")
                    return
                }
                for eachPhoto in data  {
                    let photoString = eachPhoto[Constants.FlickrParameterValues.url_m] as! String
                    let photoURL = URL(string: photoString)
                    
                    if let imageData = try? Data(contentsOf: photoURL!) {
                        print(imageData)
                        pin.addToPhotos(Photo(image: imageData as NSData, context: stack.context))
                        
                    }
                    
                }
                pin.isDownloaded = true
                stack.save()
                
                
            }
            
            
        }
    }
    
    
}
