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
        if Pin?.isDownloaded == false {
            
                FlickrClient.sharedInstance().getPhotos(latitude: MapViewController().returnLatitudeOrLongitude(fetchcontroller: fetchcontroller, latOrLong: "lat", pinflag: pinFlag, newPin: Pin), longitude: MapViewController().returnLatitudeOrLongitude(fetchcontroller: fetchcontroller, latOrLong: "long", pinflag: pinFlag, newPin: Pin)) {(sucess, data, error) in
                
                    if let data = data {
                        
                        for each in data {
                            let photoString = each[Constants.FlickrParameterValues.url_m] as! String
                            
                            let photo = Photo(image: nil, imageURL: photoString, context: stack.context)

                            Pin?.addToPhotos(photo)
                            
                            stack.save()
                            
                 
                        }
           
                        
                }
                    Pin?.isDownloaded = true
                
            }
        
        }
    }
    
    public func downloadImage(imagePath:String, completionHandler: @escaping ( _ imageData: NSData?, _ errorString: String?) -> Void) {
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
    

    
    

