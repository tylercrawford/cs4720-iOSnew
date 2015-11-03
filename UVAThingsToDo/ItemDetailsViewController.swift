//
//  ItemDetailsViewController.swift
//  UVAThingsToDo
//
//  Created by Scott Mallory on 10/26/15.
//  Copyright © 2015 Scott Mallory. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class ItemDetailsViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer:AVAudioPlayer!
    var itemTitle = "hi there"
    var itemDescription = "hello"
    var index = 0
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    @IBOutlet weak var ItemTitleLabel: UILabel!
    @IBOutlet weak var ItemDescriptionLabel: UILabel!
    @IBOutlet weak var ShareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: "Item")
//        let predicate = NSPredicate(format: "title == %@", "Dining Hall Marathon")
//        fetchRequest.predicate = predicate
        do {
            let items = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Item]
            for item in items {
                if item.item_title == itemTitle {
                    ItemTitleLabel.text! = itemTitle
                    ItemDescriptionLabel.text! = item.item_description!
                    ShareButton.hidden = true
                    print(item.item_completed)
                }
            }
        } catch let error as NSError {
            print (error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("Finished playing the song")
    }
    
    @IBAction func playSound(sender: UIButton) {
        
        ShareButton.hidden = false
        
        let fetchRequest = NSFetchRequest(entityName: "Item")
        //        let predicate = NSPredicate(format: "title == %@", "Dining Hall Marathon")
        //        fetchRequest.predicate = predicate
        do {
            let items = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Item]
            for item in items {
                if item.item_title == itemTitle {
                    item.item_completed = true
                    do{
                        try managedObjectContext.save()
                    } catch let error as NSError{
                        print("Failed to save the new person. Error = \(error)")
                    }
                    print(item.item_completed)
                }
            }
        } catch let error as NSError {
            print (error)
        }
        
        var audioFilePath = NSBundle.mainBundle().pathForResource("successful sound effect", ofType: "mp3")
        
        if audioFilePath != nil {
            
            var audioFileUrl = NSURL.fileURLWithPath(audioFilePath!)
            
            do {
                
                audioPlayer = try AVAudioPlayer(contentsOfURL: audioFileUrl, fileTypeHint: nil)
                audioPlayer.play()
            } catch {
                audioPlayer = nil
                return
            }
            
        } else {
            print("audio file is not found")
        }
    }
    
    @IBAction func shareButtonNew(sender: UIButton) {
        let title = ItemTitleLabel.text
        let description = ItemDescriptionLabel.text
        
        let returnstring = "I just completed " + title! + "\n" + description!
        print(returnstring)
        let activityViewController = UIActivityViewController(activityItems: [returnstring as! NSString], applicationActivities: nil)
        
        presentViewController(activityViewController, animated: true, completion :{})
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
