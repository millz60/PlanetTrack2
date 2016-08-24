//
//  SkyTrackViewController.swift
//  PlanetTrack2
//
//  Created by Matt Milner on 8/23/16.
//  Copyright © 2016 Matt Milner. All rights reserved.
//

import UIKit
import CoreLocation

class SkyTrackViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    var imagePicker: UIImagePickerController!
    var locationManager: CLLocationManager!
    var overlayView: UIView!
    var sun: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .Camera
        
        self.sun = UIImageView(image: UIImage(named:"sun"))
        self.sun.frame = CGRect(x: self.view.frame.size.width - 50, y: self.view.frame.size.height - 50, width: 100, height: 100)
        
        self.overlayView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        
        overlayView.addSubview(sun)
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        return  UIInterfaceOrientationMask.Portrait
//    }
//    
//    override func shouldAutorotate() -> Bool {
//        return false
//    }
    
    @IBAction func startAR() {
        
        self.presentViewController(self.imagePicker, animated: true, completion: nil)
        
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
