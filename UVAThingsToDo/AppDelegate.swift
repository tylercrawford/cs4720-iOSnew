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
            "Go to Friday's After Five",
            "Visit Monticello",
            "Climb Humpback Rock",
            "Tube along the James",
            "Visit your First Year Dorm",
            "Attend an A Capella Concert",
            "Study in the Dome Room",
            "Go Wine Tasting",
            "Pick Apples at Carter’s Mountain",
            "Take a Historical Tour of Grounds",
            "Enjoy the Downtown Farmer’s Market",
            "Chill in the Gardens",
            "Jump on Ruffner Bridge",
            "Climb O-Hill",
            "Order Delivery to Clemons",
            "Attend an Event at JPJ",
            "Sled anywhere on Grounds",
            "Attend Final Fridays at the Art Museum",
            "Go Steam Tunneling",
            "See a Show at the Paramount",
            "Eat Spudnuts",
            "Experience Lighting of the Lawn",
            "Eat at Christian’s",
            "Play Broomball",
            "Eat Dumplings on the Corner",
            "Visit the Special Collections Library",
            "Pull an All-Nighter in Clemons",
            "Eat Breakfast at Pigeon Hole",
            "Go to Drag Bingo",
            "Watch a Movie on the Lawn",
            "Join the Alumni Association",
            "See the Sunrise on the Lawn",
            "Relax in the AFC Hot Tub",
            "Participate in a 5K",
            "Play Bocce on the Lawn",
            "See Tom Deluca Perform",
            "Eat at Arch’s Ice Cream",
            "Check out a Book from the Library",
            "Trick-or-Treat on the Lawn",
            "Play an IM Sport",
            "Go to the Virginia Film Festival",
            "Tailgate on the Lawn",
            "Ride the Trolley",
            "Attend a Concert in Old Cabell",
            "Get a Hug from Miss Kathy",
            "See the River on the lawn",
            "Hop around at Jump CVille",
            "Half-price Thursday at IHOP",
            "Visit Carr’s Hill",
            "Sing the Good Ole Song",
            "Study in the McGregor Room",
            "Rent a Movie from Clemons",
            "Get Sweaty at Hot Yoga",
            "Tell a Secret at the Whispering Wall",
            "Read a book in the Amphitheater",
            "High-five Cavman",
            "High-five Dean Groves",
            "Experience Late Night Little John’s",
            "Watch a Lacrosse Game",
            "Take a Ride down Skyline Drive",
            "Go Sake-bombing at Kuma",
            "Order a Crepe from The Flat",
            "Attend Trivia Night",
            "Eat at Poe’s",
            "See a Probate",
            "Visit Ash Lawn",
            "Recycle",
            "Take an Exam Outside",
            "Laugh at the Yellow Journal",
            "Engage in Dialogue",
            "Slackline on the Lawn",
            "Meet Someone New",
            "Go for a Run",
            "Jump in Dell Pond",
            "Call a Parent or Family Member",
            "Read the Cavalier Daily",
            "Volunteer through Madison House",
            "Give Back to Charlottesville",
            "Indulge at Pint Night",
            "Go to an International Party",
            "Check out the Music Library",
            "Eat a Pancake for Parkinson’s",
            "Attend the Last Lecture Series",
            "Pay it Forward",
            "Go on a Real Date"
        ]
        
        var descriptions: [String] = [
            "Get up early and snag the first Bodo's ticket.  Thousands of customers come to this corner shop every day.  Can you beat the crowd?",
            "Go eat at all three dining halls in one day!",
            "Going to Foxfield can be a blast, but make sure you try to remember to see a horse! It is a race after all",
            "Beta Bridge has been painted over so many times that it has almost half a foot of paint built up on its walls.  Leave your mark on this landmark!",
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
            "Head to the Downtown mall and enjoy local bands and artists perform.  And, it's free!",
            "Go visit the home of our founder, Thomas Jefferson. Did you know you can see the Rotunda from his yard?",
            "This is a great location for either a sunrise or sunset hike.",
            "Grab a few friends and spend an afternoon rafting down the James River. A few companies will provide the tubes and rides for a reasonable price.",
            "Remember all those great times, when you didn’t need to worry about getting a job.  Go visit your dorm and drop off a gift or piece of advice.",
            "Did you know Pitch Perfect is based off of three real A Capella groups including the Hullabahoos?",
            "They said it should be completed by graduation… Good luck with this one.",
            "There are tons of wineries around Charlottesville. Grab some friends and check them out, but make sure to have a sober driver.",
            "After you finish, try some of their apple cider and freshly made donuts.  They are to die for.",
            "UVA has a ton of fascinating history behind it.  Go spend an hour on the lawn learning about this unique story.",
            "Each Saturday morning, tons of food stands arrive at the Downtown Mall to show you their unique take on different tastes.",
            "Each Garden has a unique style to it.  Check them out – there are 10, pick your favorite.",
            "This bridge was made by an Engineer from VT. You better test the structural integrity.  Grab a few friends and jump three times, then wait.",
            "And I mean climb the hill to the top, not just to Kellogg. This is a great nature hike and a good workout too.",
            "Next time you are doing an all-nighter, order some food to help keep you awake.  Little John’s doesn’t deliver past 12, but they can be bribed.",
            "Concerts and performers come by every year to our basketball stadium.  Check one of these fun events out!",
            "Personal favorites include the Rotunda steps and under McCormick bridge, but next time it snows grab a sled, or a cardboard box, and have a blast.",
            "Did you know we have our own art museum, right there on Rugby Road? You need to check this event out!",
            "This is not a school sanctioned tradition, so I warn you – be careful.  There is some really cool graffiti down there, but don’t get lost",
            "Another great venue that we have so close to our University.  Take advantage of the big names that come each year.",
            "Do it. Enough said.",
            "This event brings thousands of the University together to enjoy the end of the first semester and an awesome lightshow as well.",
            "This late night pizza spot is great to end a night on the corner.  I suggest their tortellini slice.",
            "Go to the ice skating rink and play this intense version of hockey. You use brooms, and shoes.",
            "Marco and Luca’s or Got Dumplings.  What’s your preference?",
            "Did you know we have one of the original drafts of the Declaration of Independence?",
            "Though this might not be the most fun item on the list, it is a staple for the UVA experience.",
            "This quaint little stop on the corner makes some mean eggs.  It is small, so be prepared to wait.",
            "Who doesn’t like Bingo? And this event brings lots of different communities of UVA together.",
            "Grab some blankets and pull up your roommate’s brother’s ex’s Netflix account that you have no shame you aren’t paying for.",
            "It’s free while you are a student and you get lots of deals and free things, so why not?",
            "Another beautiful morning can be spent right here on our central grounds as you watch the sun rise over the Academical Village.",
            "It is the biggest hot tub east of the Mississippi River, FYI. And they stream movies.",
            "There isn’t a chance you have walked across Grounds and not been handed a flyer for one of these.  Actually do one!",
            "Want to feel even more pretentious.  Grab some Bocce balls and start a game.  Or better – Croquet.",
            "Every year for fall orientation, this hypnotist amazes the crowds.  Get there early and be loud if you want to be one of his victims.",
            "Try the gooey brownie.  Seriously.",
            "We have 17 libraries and 6 million books.  I’m sure at least one of them is interesting.",
            "Come help as UVA opens its doors to the Charlottesville community and hundreds of locals trick-or-treat on the lawn. What is your favorite costume?",
            "Flag Football, Ultimate Frisbee, Innertube Waterpolo, etc.  Grab some friends and see if you can be the champion.",
            "Tons of movies to choose from, and they are all free!",
            "Guys in Ties, Girls in Pearls, and tons of rowdy students preparing for a football game on the Lawn!",
            "This free trolley goes from UVA to the Downtown Mall. Complete this in conjunction with another item on the list.",
            "Our music department is very impressive.  Go see a performance in this beautiful space.",
            "Literally the nicest person you will ever meet. Let her make your day.",
            "Lay down backwards on the steps and tilt your head back.  It may take a while to notice but once you see it you will know.",
            "This building is filled entirely with trampolines.  Might be meant for kids, but we are still kids at heart.",
            "Yes, IHOP gives you half off as a student if you go on Thursday.  You need to order a beverage though.",
            "This is where Teresa Sullivan and the presidents of UVA’s past have all lived. She may give you ice cream.",
            "If you haven’t done this yet, are you really even a student at the University of Virginia?",
            "Commonly referred to as the Harry Potter Room, this dimly lit study space is perfect to catch up on a much needed nap.",
            "The third floor is home to much of our media studies material. They have a vast DVD collection.",
            "Doing Yoga is fun, but doing it in 100 plus degree temperatures is great! Check this out downtown.",
            "Right by Newcomb Hall is a large, curved bench.  Whisper secrets to a friend standing on the other side.",
            "First, reading books is good to do.  Second, this is a cool area on Grounds, so why not combine the two.",
            "Meet our mascot on any game day.  Can you figure out who wears the suit?",
            "Our Dean of Students has style.  Ask him how many bow ties he has in his collection.",
            "Eat one of these delicious sandwiches.  Try the Chipotle Chicken or Wild Turkey.",
            "Our Lacrosse team is incredibly talented. Go support them at Klockner Stadium.",
            "This scenic road is full of amazing views of the surrounding mountains and nature of Charlottesville.",
            "Or, if you are feeling really brave, take on the Kuma Bomb.  This $25 drink is free if you can finish in 23 seconds.",
            "This hole in the wall serves delicious crepes which can be eaten for a meal or desert. Cash only.",
            "Go to Mellow Mushroom on any Wednesday night to play trivia against a bustling crowd. Go early to get a seat.",
            "No. 3, Eddy’s, Poe’s, the Jabberwock, whatever the place wants to call itself, go try their chicken sandwich.",
            "These events don’t happen as frequently as others, but when one is advertised, make sure to attend.  They are really cool to see.",
            "This venue is a great destination for formal events, but it is also a nice place to visit any day of the week.",
            "Because we care about the environment.",
            "Take advantage of the Community of Trust and the Honor System and take one of your exams outdoors.",
            "This satirical publication comes out a couple times each year and is full of humor about our student body.",
            "Whether you are involved in Sustained Dialogue or not, having insightful conversations around Grounds is important for our community.",
            "People will constantly throw up a line between the trees on the lawn.  Give it a try. They have an email list if you want updates on when to go.",
            "Even if this is your last year at this school, try to find someone you don’t know and make a new friend.",
            "Take an afternoon, put on some running clothes, and take a jog around Grounds. Explore the areas you are less familiar.",
            "On second thought, don’t.  Please don’t do this. Seriously, you will regret it.",
            "Remember who cared for you the past 18 years before you left for college and tell them that you love them. Then hope they send you that care package for making an effort.",
            "Check out the journalistic skills of your peers and stay up to date with the topics in our community.",
            "Madison House has a variety of amazing volunteering opportunities – from helping kids to spending time with the elderly.",
            "Remember how great a time this city has given you and give back to the community in some way.",
            "Head to Mellow on any Tuesday night after 8pm for $2.50 pints.  They always have 39 different beers on tap, and finishing them all gets you a special mug.",
            "These can get WILD. You won’t experience a late night out until you hit one of these parties up.",
            "It doesn’t matter what major, anyone can enjoy the study spaces in the music library.",
            "Help a great cause and enjoy a delicious breakfast pastry on the South end of the Lawn.",
            "Hear some of the greatest lectures given by renowned professors.  It will be memorable.",
            "Help out an underclassman.  Remember anything someone did for you and help make someone else’s experience here great!",
            "This one might be one of the hardest on the list, but there is so many options so find that special person and take them out."
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

