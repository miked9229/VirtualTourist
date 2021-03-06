//
//  FlickrConstants.swift
//  VirtualTourist
//
//  Created by Michael Doroff on 4/21/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation


struct Constants {
    
    // MARK: Flickr
    struct Flickr {
        static let APIBaseURL = "https://api.flickr.com/services/rest/"
    }
    
    // MARK: Flickr Parameter Keys
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let GalleryID = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let latitude = "lat"
        static let longitude = "long"
        static let bbox = "bbox"
        static let radius = "radius"
        static let per_page = "per_page"
        static let page = "page"
    }
    
    // MARK: Flickr Parameter Values
    struct FlickrParameterValues {
        static let APIKey = "0c52b507d2ea82ac559ed3b060888b38"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1" /* 1 means "yes" */
        static let PhotosSearchMethod = "flickr.photos.search"
        static let url_m = "url_m"
        static let per_page_limit = "30"

    }
    
    // MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
    
    //MARK: Largest Longitude and Latitude
    struct Maximums {
        static let LatitudeMaximumDeviation = 5.00
        static let LongitudeMaximumDeviation = 5.00
    }
    
    struct alphaLevels {
        static let alphalevelLower = 0.25
        static let alphalevelNormal = 1.00
    }
}
