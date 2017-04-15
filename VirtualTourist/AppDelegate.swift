//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by Michael Doroff on 4/1/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let stack = CoreDataStack(modelName: "Model")!
    
    
    func checkIfFirstLaunch() {
        if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            print("App has launched before")
        } else {
            print("This is the first launch ever!")
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.set( 37.1328392028809, forKey: "latitudeKey")
            UserDefaults.standard.set(-95.7855834960937, forKey: "longitudeKey")
            UserDefaults.standard.set(74.0091416724507, forKey: "latitudeDeltaKey")
            UserDefaults.standard.set(61.2760567393223, forKey: "longitudeDeltaKey")
            UserDefaults.standard.synchronize()
        }
    }
    
    func preloadData() {
        
        // Remove previous stuff (if any)
        do {
        try stack.dropAllData()
        } catch {
            print("Error droping all objects in DB")
        }
     
       let pin1 = Pin(latitude: 39.00, longitude: -95.00, context: stack.context)
       let pin2 = Pin(latitude: 39.00, longitude: -120.00, context: stack.context)
        
       let image = UIImage(named: "dog")
    
        let image1 = UIImage(named: "cat")
        
        
        let convertedImage = UIImagePNGRepresentation(image!)! as NSData
        
        
        let convertedImage1 = UIImagePNGRepresentation(image1!)! as NSData
        
        
       let photo1 = Photo(image: convertedImage, context: stack.context)
        
       let photo2 = Photo(image: convertedImage1, context: stack.context)
        
        
      pin1.addToPhotos(photo1)
      pin2.addToPhotos(photo2)
        

        
        stack.save()
        


    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
        checkIfFirstLaunch()
        preloadData()
        stack.autoSave(60)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        stack.save()
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

