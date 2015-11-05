//
//  AppDelegate.swift
//  UVAThingsToDo
//
//  Created by Scott Mallory on 10/26/15.
//  Copyright © 2015 Scott Mallory. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
         let defaults = NSUserDefaults.standardUserDefaults()
         //defaults.setBool(false, forKey: "isPreloaded")
         let isPreloaded = defaults.boolForKey("isPreloaded")
        
         if !isPreloaded {
            preloadData()
            defaults.setBool(true, forKey: "isPreloaded")
        }

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "edu.virginia.cs.cs4720.CoreDataSample" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("ItemModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("UVAThingsToDo.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    func parseCSV (contentsOfURL: NSURL, encoding: NSStringEncoding, error: NSErrorPointer) -> [(title:String, description:String)]? {
        // Load the CSV file and parse it
        let delimiter = ","
        var items:[(title:String, description:String)]?
        
        // if let content = String(contentsOfURL: contentsOfURL, encoding: encoding, error: error) {
        let content = String(contentsOfURL: contentsOfURL, encoding: encoding, error: error) //{
        items = []
        let lines:[String] = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
        
        for line in lines {
            print(line)
            var values:[String] = []
            if line != "" {
                // For a line with double quotes
                // we use NSScanner to perform the parsing
                if line.rangeOfString("\"") != nil {
                    var textToScan:String = line
                    var value:NSString?
                    var textScanner:NSScanner = NSScanner(string: textToScan)
                    while textScanner.string != "" {
                        
                        if (textScanner.string as NSString).substringToIndex(1) == "\"" {
                            textScanner.scanLocation += 1
                            textScanner.scanUpToString("\"", intoString: &value)
                            textScanner.scanLocation += 1
                        } else {
                            textScanner.scanUpToString(delimiter, intoString: &value)
                        }
                        
                        // Store the value into the values array
                        values.append(value as! String)
                        
                        // Retrieve the unscanned remainder of the string
                        if textScanner.scanLocation < textScanner.string.characters.count {
                            textToScan = (textScanner.string as NSString).substringFromIndex(textScanner.scanLocation + 1)
                        } else {
                            textToScan = ""
                        }
                        textScanner = NSScanner(string: textToScan)
                    }
                    
                    // For a line without double quotes, we can simply separate the string
                    // by using the delimiter (e.g. comma)
                } else  {
                    values = line.componentsSeparatedByString(delimiter)
                }
                
                // Put the values into the tuple and add it to the items array
                let item = (title: values[0], description: values[1])
                items?.append(item)
            }
            //}
        }
        
        return items
    }
    
    func preloadData () {
        
        
        var items: [String] = [
            "Nab the #1 Ticket at Bodo's!",
            "Dining Hall Marathon",
            "See a Horse at Foxfield",
            "Paint Beta Bridge",
            "Take a Professor to Lunch",
            "Play in Mad Bowl",
            "Go Streaking",
            "Eat at Bellair Market",
            "Go to Rotunda Sing",
            "Eat a Gus Burger",
            "Swim at Blue Hole",
            "Chow Down at Crozet Pizza",
            "Attend Restoration Ball",
            "Go to a Frat Party",
            "Make a Purchase at Shady Grady",
            "Go to Friday’s After Five",
            "Visit Monticello",
            "Climb Humpback Rock",
            "Tube along the James"
        ]
        
        var descriptions: [String] = [
            "Get up early and snag the first Bodo's ticket.  Thousands of customers come to this corner shop every day.  Can you beat the crowd?",
            "Go eat at all three dining halls in one day!",
            "Going to Foxfield can be a blast, but make sure you try to remember to see a horse! It is a race after all",
            "Beta Bridge has een painted over so many times that it has almost half a foot of paint built up on its walls.  Leave your mark on this landmark!",
            "You sit in their class.  You may visit their Office Hours.  But to really have the UVA experience Jefferson wanted, get to know them with a free lunch (yes, ODOS gives you the money).",
            "Don't let that beautiful pit go to waste.  Grab some friends and a ball of some sort and play a game to enjoy a nice day, or wait til it snows and bring a sled.",
            "A tradition for the past 40 years, the academical village serves a perfect place for a late night run.",
            "Just a little trip down Ivy, this small gas station has amazing sandwiches.  Recommendation: the Ednam",
            "UVA has tons of talented A Capella groups.  Hear them all debut on the steps of the Rotunda to see which is your favorite.",
            "Though I don't recommend it for the taste, getting a Gus Burger from the White Spot is a tradition very old and true at the University.",
            "Go take a drive to the depths of nature and take a two mile hike to this wonderful waterfall swimming area!",
            "And by this, we mean the ORIGINAL Crozet Pizza.  Though the one on the Corner is still delicious and has great drink options, the original is worth the trek.",
            "This annual event hosted by the Jefferson Literary and Debating Society brings people from all over the University together for a formal ball, and Dean Groves may teach the Virginia Reel.",
            "You may think these are for the younger generations, but relive your first year weekend nights by taking a stroll down Rugby Road and walk through an overcrowded house that reeks of kegs and old pizza.",
            "Remember that place down on Preston Ave that was the only place that didn't care about IDs? It is still there and still just as shady.",
            "Head to the Downtown mall and enjoy local bands and artists perform.  And, it’s free!",
            "Go visit the home of our founder, Thomas Jefferson. Did you know you can see the Rotunda from his yard?",
            "This is a great location for either a sunrise or sunset hike.",
            "Grab a few friends and spend an afternoon rafting down the James River. A few companies will provide the tubes and rides for a reasonable price."
        ]
        var i = 0
        for data in items {
            let theItem = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: managedObjectContext) as! Item
            theItem.item_title = data
            theItem.item_description = descriptions[i]
            theItem.item_completed = false
            theItem.item_index = i
            i += 1
            
            /*if managedObjectContext.save(&error) != true {
            print("insert error: \(error!.localizedDescription)")
            }*/
        }
        
        
        // Retrieve data from the source file
//        if let contentsOfURL = NSBundle.mainBundle().URLForResource("inputData", withExtension: "csv") {
//            
//            // Remove all the menu items before preloading
//            //removeData()
//            
//            var error:NSError?
//            if let items = parseCSV(contentsOfURL, encoding: NSUTF8StringEncoding, error: &error) {
//                // Preload the menu items
//                let managedObjectContext = self.managedObjectContext
//                print("hello world")
//                for data in items {
//                    print(data.title)
//                }
//                for data in items {
//                    let theItem = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: managedObjectContext) as! Item
//                    theItem.item_title = data.title
//                    theItem.item_description = data.description
//                    
//                    /*if managedObjectContext.save(&error) != true {
//                        print("insert error: \(error!.localizedDescription)")
//                    }*/
//                }
//            }
//        }
    }
}

