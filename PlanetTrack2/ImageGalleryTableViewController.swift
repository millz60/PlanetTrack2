//
//  ImageGalleryTableViewController.swift
//  PlanetTrack-Swift
//
//  Created by Matt Milner on 8/14/16.
//  Copyright © 2016 Matt Milner. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UIViewController, UITableViewDelegate {
    
    var factsArray: [String]!
    @IBOutlet weak var ImageTableView: UITableView!
    var sunImages: NSMutableDictionary!
    var mercuryImages: NSMutableDictionary!
    var venusImages: NSMutableDictionary!
    var earthImages: NSMutableDictionary!
    var moonImages: NSMutableDictionary!
    var marsImages: NSMutableDictionary!
    var jupiterImages: NSMutableDictionary!
    var saturnImages: NSMutableDictionary!
    var uranusImages: NSMutableDictionary!
    var neptuneImages: NSMutableDictionary!
    
    var selectedCell: String!
    var allCells: [NSMutableDictionary]!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        downloadImageData()
        
        self.ImageTableView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.25)
        self.factsArray = ["sun","mercury","venus","earth","moon","mars","jupiter","saturn","uranus","neptune"]
        self.ImageTableView.userInteractionEnabled = false
        self.title = "Image Gallery"
        

        self.ImageTableView.reloadData()
        
    }
    
    private func downloadImageData() {
        
        let imageDataString = "https://dl.dropboxusercontent.com/s/8jzyxcdj7tp4mjp/ImageGallery.json?dl=0"
        
        guard let url = NSURL(string: imageDataString) else { fatalError("Invalid URL") }
        
        let session = NSURLSession.sharedSession()
        
        session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
//            guard let jsonResult = NSString(data: data!, encoding: NSUTF8StringEncoding) else {
//                fatalError("Unable to format data")
//            }
            
            let imageData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSMutableDictionary

            let sunImageData = NSMutableDictionary(dictionary: imageData["Sun"]! as! [String : String])
            let mercuryImageData = NSMutableDictionary(dictionary: imageData["Mercury"]! as! [String : String])
            let venusImageData = NSMutableDictionary(dictionary: imageData["Venus"]! as! [String : String])
            let earthImageData = NSMutableDictionary(dictionary: imageData["Earth"]! as! [String : String])
            let moonImageData = NSMutableDictionary(dictionary: imageData["Moon"]! as! [String : String])
            let marsImageData = NSMutableDictionary(dictionary: imageData["Mars"]! as! [String : String])
            let jupiterImageData = NSMutableDictionary(dictionary: imageData["Jupiter"]! as! [String : String])
            let saturnImageData = NSMutableDictionary(dictionary: imageData["Saturn"]! as! [String : String])
            let uranusImageData = NSMutableDictionary(dictionary: imageData["Uranus"]! as! [String : String])
            let neptuneImageData = NSMutableDictionary(dictionary: imageData["Neptune"]! as! [String : String])

            self.sunImages = sunImageData
            self.mercuryImages = mercuryImageData
            self.venusImages = venusImageData
            self.earthImages = earthImageData
            self.moonImages = moonImageData
            self.marsImages = marsImageData
            self.jupiterImages = jupiterImageData
            self.saturnImages = saturnImageData
            self.uranusImages = uranusImageData
            self.neptuneImages = neptuneImageData
            
            self.allCells = [self.sunImages,self.mercuryImages,self.venusImages,self.earthImages,self.moonImages,self.marsImages,self.jupiterImages,self.saturnImages,self.uranusImages,self.neptuneImages]
            
            
            dispatch_async(dispatch_get_main_queue(), {
                self.ImageTableView.reloadData()
            })
            self.ImageTableView.userInteractionEnabled = true
                        
        }.resume()
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return factsArray.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath)

        cell.imageView!.frame = CGRectMake(0,0,20,20)        
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont(name: "Apple SD Gothic Neo", size: 25.0)
        cell.textLabel!.text = factsArray[indexPath.row].capitalizedString
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        cell.imageView?.image = UIImage(named: factsArray[indexPath.row])
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView?.tintColor = UIColor.redColor()
        

        
        return cell
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if(segue.identifier == "ImagesSegue"){
            let destination = segue.destinationViewController as! ImageGalleryTestViewController
        
            let indexPath = self.ImageTableView.indexPathForSelectedRow
        
            destination.sentImageDictionary = self.allCells[indexPath!.row]
        
        }
        
        
        
    }
 

}
