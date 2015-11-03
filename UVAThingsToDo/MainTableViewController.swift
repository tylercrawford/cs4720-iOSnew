//
//  MainTableViewController.swift
//  UVAThingsToDo
//
//  Created by Scott Mallory on 10/26/15.
//  Copyright © 2015 Scott Mallory. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {
    
    

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var titles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let fetchRequest = NSFetchRequest(entityName: "Item")
        do {
            let items = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Item]
            for item in items {
                titles.append(item.item_title!)
            }
        } catch let error as NSError {
            print (error)
        }
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
        return titles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "cell",
            forIndexPath: indexPath) //make the cell
        
        let row = indexPath.row
        
        cell.textLabel!.text = titles[row]
        cell.detailTextLabel!.text = ""
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let index = tableView.indexPathForSelectedRow!
        var title = titles[index.row]
//        var description = descriptions[index.row]
        if segue.identifier == "viewItem" {
            let vc = segue.destinationViewController as! ItemDetailsViewController
            //vc.title = title
            vc.itemTitle = title
//            vc.itemDescription = description
            //vc.index = index
        }
    }
    
    func createItems() {
        
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
