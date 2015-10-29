//
//  MainTableViewController.swift
//  UVAThingsToDo
//
//  Created by Scott Mallory on 10/26/15.
//  Copyright © 2015 Scott Mallory. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Data Sources and Delegates
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "cell",
            forIndexPath: indexPath) //make the cell
        
        let row = indexPath.row
        
        cell.textLabel!.text = items[row]
        cell.detailTextLabel!.text = ""
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let index = tableView.indexPathForSelectedRow!
        var title = items[index.row]
        var description = descriptions[index.row]
        if segue.identifier == "viewItem" {
            let vc = segue.destinationViewController as! ItemDetailsViewController
            //vc.title = title
            vc.itemTitle = title
            vc.itemDescription = description
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
