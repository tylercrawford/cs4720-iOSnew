//
//  ItemDetailsViewController.swift
//  UVAThingsToDo
//
//  Created by Scott Mallory on 10/26/15.
//  Copyright © 2015 Scott Mallory. All rights reserved.
//

import UIKit
import AVFoundation

class ItemDetailsViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer:AVAudioPlayer!
    var itemTitle = "hi there"
    var itemDescription = "hello"

    @IBOutlet weak var ItemTitleLabel: UILabel!
    @IBOutlet weak var ItemDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ItemTitleLabel.text! = itemTitle
        ItemDescriptionLabel.text! = itemDescription
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("Finished playing the song")
    }
    
    @IBAction func playSound(sender: UIButton) {
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
