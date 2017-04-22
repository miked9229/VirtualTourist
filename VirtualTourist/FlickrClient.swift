//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Michael Doroff on 4/21/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation

class FlickrClient {
    

    
    public func getPhotos(latitude: Double, longitude: Double) {
        
        let methodParameters = [Constants.FlickrParameterKeys.Method:
                                Constants.FlickrParameterValues.PhotosSearchMethod,
                                Constants.FlickrParameterKeys.APIKey:
                                Constants.FlickrParameterValues.APIKey,
                                Constants.FlickrParameterKeys.latitude: latitude,
                                Constants.FlickrParameterKeys.longitude: longitude,
                                Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
                                Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback,
                                Constants.FlickrParameterKeys.bbox: "-180,-90,180,90"] as [String : Any]
        
        
        // create url and request
    //    let session = URLSession.shared
        let urlString = Constants.Flickr.APIBaseURL + escapedParameters(methodParameters as [String:AnyObject])
        print(urlString)
        let url = URL(string: urlString)!
        print(url)
       // let request = URLRequest(url: url)
        


    }
    

    

    
}
extension FlickrClient {
    public func escapedParameters(_ parameters: [String:AnyObject]) -> String {
        // This method was used in the Udacity Course. All Rights Reserved
        
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                
                // make sure that it is a string value
                let stringValue = "\(value)"
                
                // escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                // append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
                
            }
            
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
    
    class func sharedInstance() -> FlickrClient {
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        return Singleton.sharedInstance
    }
    
    
}
