//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Michael Doroff on 4/21/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation

class FlickrClient {
    
    var session = URLSession.shared

    
    public func getPhotos(latitude: Double, longitude: Double, _ completionHandlerForGetPhotos: @escaping (_ success: Bool, _ data: [[String: AnyObject]]?, _ error: String?) -> Void) {

        
        let methodParameters = [Constants.FlickrParameterKeys.Method:
                                Constants.FlickrParameterValues.PhotosSearchMethod,
                                Constants.FlickrParameterKeys.APIKey:
                                Constants.FlickrParameterValues.APIKey,
                                Constants.FlickrParameterKeys.latitude: latitude,
                                Constants.FlickrParameterKeys.longitude: longitude,
                                Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
                                Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback,
                                Constants.FlickrParameterKeys.bbox: returnBbox(latitude: latitude, longitude: longitude),
                                Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.url_m,
                                Constants.FlickrParameterKeys.per_page: Constants.FlickrParameterValues.per_page_limit]
            as [String : Any]
        
        
        // create url and request
        let session = URLSession.shared
        let urlString = Constants.Flickr.APIBaseURL + escapedParameters(methodParameters as [String:AnyObject])

        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
      
        let task = session.dataTask(with: urlRequest) {(data, response, error) in
            
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completionHandlerForGetPhotos(false, nil, nil)
                return
            
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForGetPhotos(false, nil, nil)
                print("Your request returned a status code other than 2xx!")
                
                return
            }
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandlerForGetPhotos(false, nil, nil)
                return
                
            }
            
            var parsedResult: [String:AnyObject]! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
            } catch {
                print("Could not parse JSON data")
                
            }

            
            guard let photoDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject], let photoArray = photoDictionary[Constants.FlickrResponseKeys.Photo] as? [[String:AnyObject]] else {
                return
            }
            
            
            completionHandlerForGetPhotos(true, photoArray, nil)
        
         

        }
        task.resume()
        
            
    }
        


}

extension FlickrClient {
    public func escapedParameters(_ parameters: [String:AnyObject]) -> String {
        // This method was used in the Udacity Course. All Rights Reserved to Udacity
        
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
    
    
    
    public func returnBbox(latitude: Double, longitude: Double) -> String {
        
        let longitudeMinimum = (longitude - Constants.Maximums.LongitudeMaximumDeviation) >= -180 ? (longitude - Constants.Maximums.LongitudeMaximumDeviation): -180
        let latitudeMinimum = (latitude - Constants.Maximums.LatitudeMaximumDeviation) >= -90 ? (latitude - Constants.Maximums.LatitudeMaximumDeviation): -90
        let longitudeMaximum = (longitude + Constants.Maximums.LongitudeMaximumDeviation) <= 180 ? (longitude + Constants.Maximums.LongitudeMaximumDeviation): -180
        let latitudeMaximum = (latitude + Constants.Maximums.LatitudeMaximumDeviation) <= 90 ? (latitude + Constants.Maximums.LatitudeMaximumDeviation): -90
        
        
        return "\(longitudeMinimum),\(latitudeMinimum),\(longitudeMaximum),\(latitudeMaximum)"
    }
    
    
    
    
    
    class func sharedInstance() -> FlickrClient {
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        return Singleton.sharedInstance
    }
    
    
}
