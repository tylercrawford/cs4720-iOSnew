//
//  ProgressViewController.swift
//  UVAThingsToDo
//
//  Created by Scott Mallory on 11/16/15.
//  Copyright © 2015 Scott Mallory. All rights reserved.
//

import UIKit
import CoreData

class ProgressViewController: UIViewController {

    @IBOutlet weak var ProgressLabel: UILabel!
    @IBOutlet weak var ProgressCoinPhoto: UIImageView!
    @IBOutlet weak var ProgressDescriptionLabel: UILabel!
    @IBOutlet weak var NextLevelLabel: UILabel!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var count = 0
        var nextCount = 0
        let fetchRequest = NSFetchRequest(entityName: "Item")
        do {
            let items = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Item]
            for item in items {
                    if item.item_completed == 1 {
                        count += 1
                }
            }
            
        } catch let error as NSError {
            print (error)
        }
        var img = UIImage(named: "TinCoin")
        
        let progressText = "You have completed "+String(count)+" out of 100 tasks!"
        ProgressLabel.text = progressText
        var competitorType = "Tin"
        if count < 25 {
            competitorType = "Tin"
            img = UIImage(named: "TinCoin")
            nextCount = 25 - count
        }
        else if count < 50 {
            competitorType = "Bronze"
            img = UIImage(named: "BronzeCoin")
            nextCount = 50 - count
        }
        else if count < 75 {
            competitorType = "Silver"
            img = UIImage(named: "SilverCoin")
            nextCount = 75 - count
        }
        else if count < 100 {
            competitorType = "Gold"
            img = UIImage(named: "GoldCoin")
            nextCount = 100 - count
        }
        else if count == 100 {
            competitorType = "Platinum"
            img = UIImage(named: "PlatinumCoin")
            nextCount = 0
        }
        let descriptionText = "You are a "+competitorType+" competitor!"
        ProgressDescriptionLabel.text = descriptionText
        ProgressCoinPhoto.image = img
        
        if nextCount == 0 {
            NextLevelLabel.text = "Congratulations on completing every task!!"

        }
        else {
            NextLevelLabel.text = "Only "+String(nextCount)+" tasks to the next level!"

        }

        
        
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
