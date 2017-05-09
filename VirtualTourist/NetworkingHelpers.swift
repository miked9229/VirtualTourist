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
    
    public func backgroundLoad(fetchcontroller: NSFetchedResultsController <NSFetchRequestResult>, pinFlag: Bool, Pin: Pin?) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        if let coord = stack.context.persistentStoreCoordinator {
            let bckgContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            bckgContext.persistentStoreCoordinator = coord
            
            bckgContext.perform( {
                
                FlickrClient.sharedInstance().getPhotos(latitude: MapViewController().returnLatitudeOrLongitude(fetchcontroller: fetchcontroller, latOrLong: "lat", pinflag: pinFlag, newPin: Pin), longitude: MapViewController().returnLatitudeOrLongitude(fetchcontroller: fetchcontroller, latOrLong: "long", pinflag: pinFlag, newPin: Pin)) {(sucess, data, error) in
                
                    if let data = data {
                        
                        self.appendToPin(data: data, fetchcontroller: fetchcontroller, newPin: Pin, pinFlag: pinFlag)
                        
                    }
                    
                }
                
            })
            
            
        }
        
        
    }
    
    public func appendToPin(data: [[String: AnyObject]], fetchcontroller: NSFetchedResultsController <NSFetchRequestResult>, newPin: Pin?, pinFlag: Bool) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
    
        if pinFlag {
            
            
            for eachPhoto in data  {
           
                let photoString = eachPhoto[Constants.FlickrParameterValues.url_m] as! String
                
//                let photo = Photo(image: (photoString as? NSData)!, context: stack.context)
                
                downloadImage(imagePath: photoString) {(imageData, ErrorString) in
                    
                    
                    
                    newPin?.addToPhotos(Photo(image: imageData!, context: stack.context))
                    
                }
                
            }
            newPin?.isDownloaded = true
     
        } else {
    
            if let object = fetchcontroller.sections?[0].objects {
                for each in object {
                    guard let pin = each as? Pin else {
                        print("Could not get to pins")
                        return
                    }
                    
                    for eachPhoto in data  {
                        let photoString = eachPhoto[Constants.FlickrParameterValues.url_m] as! String
                        
                        downloadImage(imagePath: photoString) {(imageData, ErrorString) in
                            
                            
                            
                        pin.addToPhotos(Photo(image: imageData!, context: stack.context))
                            
                        }
                        
                    }
                    pin.isDownloaded = true
                    stack.save()
                    
                    
                }
                
                
            }
            
        }
        

    }
    public func downloadImage(imagePath:String, completionHandler: @escaping ( _ imageData: NSData?, _ errorString: String?) -> Void) {
        print(imagePath)
        let session = URLSession.shared
        let imgURL = NSURL(string: imagePath)
        let request: NSURLRequest = NSURLRequest(url: imgURL! as URL)
        
        let task = session.dataTask(with: request as URLRequest) {data, response, downloadError in
            
            if downloadError != nil {
                completionHandler(nil, "Could not download image \(imagePath)")
            } else {
                
                completionHandler(data as NSData?, nil)
            }
        }
        
        task.resume()
    }
}
    

    
    

