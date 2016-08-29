//
//  SolarSystemFactsViewController.swift
//  PlanetTrack2
//
//  Created by Matt Milner on 8/25/16.
//  Copyright © 2016 Matt Milner. All rights reserved.
//

import UIKit

class SolarSystemFactsViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var factsTableView: UITableView!
    
    var factsArray = [AnyObject]()
    var imagesArray = [AnyObject]()
    var allCells : NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        factsArray.append("10 Facts About Each Planet")
        factsArray.append("Your Weight on Other Planets")
        factsArray.append("Planet Composition and Temperature")
        factsArray.append("Planetary Orbits")
        factsArray.append("Earth's Magnetic Field")
        factsArray.append("Man-made Spacecraft")
        factsArray.append("Our Place in the Milky Way")
        factsArray.append("The Search for Extraterrestrial Life")
        factsArray.append("Skywatching Guide")
        
        imagesArray.append("planetsMosaic")
        imagesArray.append("astronaut")
        imagesArray.append("planetaryOrbits")
        imagesArray.append("earthsVisual")
        imagesArray.append("magneticField")
        imagesArray.append("juno")
        imagesArray.append("background6")
        imagesArray.append("microbes")
        imagesArray.append("skywatching")
        
        self.factsTableView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
        
        self.allCells = NSMutableArray()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return factsArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> FactsTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FactCell", forIndexPath: indexPath)
        
        
        
        let newCell = cell as! FactsTableViewCell
        
        

        
      //  cell.imageView!.frame = CGRectMake(0,0,20,20)
            newCell.cellTitle?.textColor = UIColor.whiteColor()
        
        
        if UIScreen.mainScreen().bounds.size.height == 320 {
            // IPhone 5 and 4
            newCell.cellTitle?.font = UIFont(name: "Apple SD Gothic Neo", size: 15.0)
        } else{
            newCell.cellTitle?.font = UIFont(name: "Apple SD Gothic Neo", size: 25.0)
        }
            newCell.cellTitle?.text = factsArray[indexPath.row].capitalizedString
            newCell.cellTitle?.textAlignment = NSTextAlignment.Center
            newCell.cellImageView.image = UIImage(named: "\(imagesArray[indexPath.row])")
            newCell.backgroundColor = UIColor.clearColor()
            newCell.backgroundView?.tintColor = UIColor.redColor()

            self.allCells.addObject(newCell)
        
        
        return newCell
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        
        if(segue.identifier == "PlanetFactsSegue"){
            let selectedIndexPath = self.factsTableView.indexPathForSelectedRow
        
            let selectedCell = self.allCells[selectedIndexPath!.row] as! FactsTableViewCell
        
            let destination = segue.destinationViewController as! PlanetFactsViewController
            destination.categoryTitle = selectedCell.cellTitle!.text!
            destination.backgroundImage = selectedCell.cellImageView.image!
        }
        
        
        
        
    }
 

}
