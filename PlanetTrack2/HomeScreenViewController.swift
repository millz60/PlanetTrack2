//
//  HomeScreenViewController.swift
//  PlanetTrack-Swift
//
//  Created by Matt Milner on 8/11/16.
//  Copyright © 2016 Matt Milner. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    

    @IBOutlet weak var buttonsTableView: UITableView!
    @IBOutlet weak var menuStackView: UIStackView!
    @IBOutlet weak var planetTrackLabel: UILabel!
    @IBOutlet weak var planetTrackButton: UIButton!
    @IBOutlet weak var solarSystemFactsButton: UIButton!
    @IBOutlet weak var imageGalleryButton: UIButton!
    
    
    
    let planetsArray = ["mars","jupiter","saturn","earth","neptune","venus","mercury","uranus"]
    
    var planetImageView: UIImageView!
    var targetView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        if(isInternetAvailable() == false){
            planetTrackButton.enabled = false
            planetTrackButton.setTitleColor(UIColor.grayColor(), forState: .Disabled)

            imageGalleryButton.enabled = false
            imageGalleryButton.setTitleColor(UIColor.grayColor(), forState: .Disabled)
            
        }
        
        
        
        planetImageView = UIImageView()
        
        planetImageView.image = UIImage(named: "earth")
        planetImageView.layer.zPosition = 9998
        planetImageView.alpha = 1
        
        self.view.addSubview(planetImageView)
        
        targetView = UIImageView()
        targetView.image = UIImage(named: "crosshairs2.png")
        targetView.backgroundColor = UIColor.clearColor()
        targetView.layer.zPosition = 9999
        targetView.layer.borderWidth = 1.0
        targetView.layer.borderColor = UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 0.75).CGColor
        targetView.alpha = 0.0
        

        if UIScreen.mainScreen().bounds.size.height == 320 {
            // IPhone 5 and 4
            targetView.frame = CGRect(x: (self.view.frame.size.width/4)-90, y: (self.view.frame.size.height/2)-90, width: 180, height: 180)
            planetImageView.frame = CGRect(x: (self.view.frame.size.width/4), y: (self.view.frame.size.height/2), width: 0, height: 0)
        } else{
            targetView.frame = CGRect(x: (self.view.frame.size.width/3)-140, y: (self.view.frame.size.height/2)-140, width: 280, height: 280)
            planetImageView.frame = CGRect(x: (self.view.frame.size.width/3), y: (self.view.frame.size.height/2), width: 0, height: 0)
        }
        
        
        self.view.addSubview(targetView)

        flash2()
        let timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(flash), userInfo: nil, repeats: true)
        let timer2 = NSTimer.scheduledTimerWithTimeInterval(3.5, target: self, selector: #selector(flash2), userInfo: nil, repeats: true)

        
        self.menuStackView.alpha = 1.0

        animatePlanet()
        

        
        
    }
    
    func isInternetAvailable() -> Bool {
        let networkReachability : Reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus : NetworkStatus = networkReachability.currentReachabilityStatus()
        
        if networkStatus == NotReachable {
            print("No Internet")
            return false
        } else {
            print("Internet Available")
            return true
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if(isInternetAvailable() == false){
            let alert = UIAlertController(title: "Alert", message: "Many Features of PlanetTrack Require an Internet Connection.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            

            
            
        }
    }
    
    
    func flash() {
        
        
        let randInt = Int(arc4random_uniform(7))
        
        if UIScreen.mainScreen().bounds.size.height == 320 {
            // IPhone 5 and 4
            UIView.animateWithDuration(3.5, animations: {
                self.planetImageView.frame = CGRect(x: (self.view.frame.size.width/4), y: (self.view.frame.size.height/2), width: 0, height: 0)
                self.planetImageView.alpha = 0.3
                
                
            }) { (g) in
                UIView.animateWithDuration(3.5, animations: {
                    self.planetImageView.image = UIImage(named: self.planetsArray[randInt])
                    self.planetImageView.alpha = 1.0
                    self.planetImageView.frame = CGRect(x: (self.view.frame.size.width/4)-50, y: (self.view.frame.size.height/2)-50, width: 100, height: 100)
                    
                }) { (h) in
                    UIView.animateWithDuration(0.25, animations: {
                    }) { (x) in
                    }
                    
                    
                }}
            
            

        } else {
        
        UIView.animateWithDuration(3.5, animations: {
            self.planetImageView.frame = CGRect(x: (self.view.frame.size.width/3), y: (self.view.frame.size.height/2), width: 0, height: 0)
            self.planetImageView.alpha = 0.3


            }) { (g) in
                UIView.animateWithDuration(3.5, animations: {
                    self.planetImageView.image = UIImage(named: self.planetsArray[randInt])
                    self.planetImageView.alpha = 1.0
                    self.planetImageView.frame = CGRect(x: (self.view.frame.size.width/3)-75, y: (self.view.frame.size.height/2)-75, width: 150, height: 150)

                }) { (h) in
                    UIView.animateWithDuration(0.25, animations: {
                    }) { (x) in
                }
                

        }}
        }
    }
    
    func flash2() {
        
        UIView.animateWithDuration(1.5, animations: {
            self.targetView.alpha = 1

            
        }) { (g) in
            UIView.animateWithDuration(0.25, animations: {
                self.targetView.alpha = 0.0
                
            }) { (h) in
            UIView.animateWithDuration(0.25, animations: {
                self.targetView.alpha = 1.0
            }) { (i) in
            UIView.animateWithDuration(1.5, animations: {
                self.targetView.alpha = 0.0
                })
        }
        
            }
    
        }
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animatePlanet() {
        
        if UIScreen.mainScreen().bounds.size.height == 320 {
            // IPhone 5 and 4
            targetView.frame = CGRect(x: (self.view.frame.size.width/4)-90, y: (self.view.frame.size.height/2)-90, width: 180, height: 180)
            planetImageView.frame = CGRect(x: (self.view.frame.size.width/4), y: (self.view.frame.size.height/2), width: 0, height: 0)
            
            UIView.animateWithDuration(3.5, animations: {
                self.planetImageView.alpha = 1.0
                self.planetImageView.frame = CGRect(x:(self.view.frame.size.width/4)-50, y:(self.view.frame.size.height/2)-50, width:100, height: 100)
                
                }, completion: nil)
            
            
        } else{
            targetView.frame = CGRect(x: (self.view.frame.size.width/3)-140, y: (self.view.frame.size.height/2)-140, width: 280, height: 280)
            planetImageView.frame = CGRect(x: (self.view.frame.size.width/3), y: (self.view.frame.size.height/2), width: 0, height: 0)
            
            UIView.animateWithDuration(3.5, animations: {
                self.planetImageView.alpha = 1.0
                self.planetImageView.frame = CGRect(x:(self.view.frame.size.width/3)-100, y:(self.view.frame.size.height/2)-100, width:200, height: 200)
                
                }, completion: nil)
        }
        

        
        
        
    }

    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destination = segue.destinationViewController as! HomeScreenTabBarController
        
        if (segue.identifier == "PlanetTrackSegue"){
            
            destination.selectedIndex = 0
            
        } else if (segue.identifier == "SolarSystemFactsSegue"){
            
            destination.selectedIndex = 2
        
        } else if (segue.identifier == "ImageGallerySegue"){
        
            destination.selectedIndex = 1
    
        } else if (segue.identifier == "AboutSegue"){
            
            destination.selectedIndex = 3
        }
        
    }
    
    
    

}
