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
        "Test1",
        "Test2",
        "Test3",
        "Test4",
        "Test5",
        "Test6",
        "Test7"
    ]
    
    var descriptions: [String] = [
        "Test1 Description",
        "Test2 Description",
        "Test3 Description",
        "Test4 Description",
        "Test5 Description",
        "Test6 Description",
        "Test7 Description"
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
            vc.title = title
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
