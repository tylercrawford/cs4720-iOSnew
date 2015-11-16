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
import CoreLocation

class ItemDetailsViewController: UIViewController, AVAudioPlayerDelegate, CLLocationManagerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var locationManager: CLLocationManager?
    
    var audioPlayer:AVAudioPlayer!
    var imagePicker: UIImagePickerController!
    var itemTitle = "hi there"
    var itemDescription = "hello"
    var index = 0
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var latitude = 0.0
    var longitude = 0.0

    @IBOutlet weak var ItemTitleLabel: UILabel!
    @IBOutlet weak var ItemDescriptionLabel: UILabel!
    @IBOutlet weak var ShareButton: UIButton!
    @IBOutlet weak var LatitudeLabel: UILabel!
    @IBOutlet weak var LongitudeLabel: UILabel!
    @IBOutlet weak var CompletedButton: UIButton!
    @IBOutlet weak var PhotoView: UIImageView!
    @IBOutlet weak var PhotoButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSizeMake(50, 50);
        let fetchRequest = NSFetchRequest(entityName: "Item")
        do {
            let items = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Item]
            for item in items {
                if item.item_title == itemTitle {
                    ItemTitleLabel.text! = itemTitle
                    ItemTitleLabel.font = UIFont.boldSystemFontOfSize(16.0)
                    ItemDescriptionLabel.text! = item.item_description!
                    
                    if item.item_completed == 1 {
                        LatitudeLabel.text = "Latitude: " + String(item.item_latitude!)
                        LongitudeLabel.text = "Longitude: " + String(item.item_longitude!)
                        CompletedButton.hidden = true
                        PhotoButton.hidden = false
                        if (item.item_image != nil) {
                            PhotoView.image = UIImage(data: item.item_image!)
                        } else {
                            let img = UIImage(named: "UVA_Rotunda")
                            PhotoView.image = img
                        }
                    } else {
                        LatitudeLabel.hidden = true
                        LongitudeLabel.hidden = true
                        ShareButton.hidden = true
                        PhotoButton.hidden = true
                        let img = UIImage(named: "UVA_Rotunda")
                        PhotoView.image = img
                    }
                }
            }
            
            var constraints = [NSLayoutConstraint]()
            
            constraints.append(NSLayoutConstraint(item: PhotoView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
            constraints.append(NSLayoutConstraint(item: PhotoButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
            constraints.append(NSLayoutConstraint(item: ShareButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
            constraints.append(NSLayoutConstraint(item: CompletedButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
            
            NSLayoutConstraint.activateConstraints(constraints)
        } catch let error as NSError {
            print (error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count == 0{
            //handle error here
            return
        }
        
        let newLocation = locations[0]
        
        latitude = newLocation.coordinate.latitude
        longitude = newLocation.coordinate.longitude
        
    }
    
    func locationManager(manager: CLLocationManager,
        didFailWithError error: NSError){
            print("Location manager failed with error = \(error)")
    }
    
    func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus){
            
            print("The authorization status of location services is changed to: ", terminator: "")
            
            switch CLLocationManager.authorizationStatus(){
            case .AuthorizedAlways:
                print("Authorized")
            case .AuthorizedWhenInUse:
                print("Authorized when in use")
                manager.startUpdatingLocation()
            case .Denied:
                print("Denied")
            case .NotDetermined:
                print("Not determined")
            case .Restricted:
                print("Restricted")
            }
            
    }

    func createLocationManager(startImmediately startImmediately: Bool){
        locationManager = CLLocationManager()
        if let manager = locationManager{
            print("Successfully created the location manager")
            manager.delegate = self
            
            if startImmediately{
                manager.startUpdatingLocation()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Are location services available on this device? */
        if CLLocationManager.locationServicesEnabled(){
            
            /* Do we have authorization to access location services? */
            switch CLLocationManager.authorizationStatus(){
            case .AuthorizedAlways:
                /* Yes, always */
                createLocationManager(startImmediately: true)
            case .AuthorizedWhenInUse:
                /* Yes, only when our app is in use */
                createLocationManager(startImmediately: true)
            case .Denied:
                /* No */
                print("Location services are not allowed for this app")
            case .NotDetermined:
                /* We don't know yet, we have to ask */
                createLocationManager(startImmediately: false)
                if let manager = self.locationManager{
                    manager.requestWhenInUseAuthorization()
                }
            case .Restricted:
                /* Restrictions have been applied, we have no access
                to location services */
                print("Location services are not allowed for this app")
            }
            
            
        } else {
            /* Location services are not enabled.
            Take appropriate action: for instance, prompt the
            user to enable the location services */
            print("Location services are not enabled")
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("Finished playing the song")
    }
    
    @IBAction func completed(sender: UIButton) {
        
        ShareButton.hidden = false
        
        let fetchRequest = NSFetchRequest(entityName: "Item")
        do {
            let items = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Item]
            for item in items {
                if item.item_title == itemTitle {
                    item.item_completed = true
                    item.item_latitude = latitude
                    item.item_longitude = longitude
                    do{
                        try managedObjectContext.save()
                    } catch let error as NSError{
                        print("Failed to save the new person. Error = \(error)")
                    }
                }
            }
        } catch let error as NSError {
            print (error)
        }
        
        PhotoButton.hidden = false
        CompletedButton.hidden = true
        LatitudeLabel.hidden = false
        LongitudeLabel.hidden = false
        LatitudeLabel.text = "Latitude: " + String(latitude)
        LongitudeLabel.text = "Longitude: " + String(longitude)
        
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
    
    @IBAction func takePhoto(sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        PhotoView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        let fetchRequest = NSFetchRequest(entityName: "Item")
        do {
            let items = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Item]
            for item in items {
                if item.item_title == itemTitle {
                    item.item_image = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage] as! UIImage, 1)
                    do{
                        try managedObjectContext.save()
                    } catch let error as NSError{
                        print("Failed to save the new person. Error = \(error)")
                    }
                }
            }
        } catch let error as NSError {
            print (error)
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {       
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }

}
