//
//  SkyTrackViewController.swift
//  PlanetTrack2
//
//  Created by Matt Milner on 8/23/16.
//  Copyright © 2016 Matt Milner. All rights reserved.
//

import UIKit
import CoreLocation
import PRAugmentedReality

class SkyTrackViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, PRARManagerDelegate {
    
    
//    var imagePicker: UIImagePickerController!
//    var locationManager: CLLocationManager!
//    var overlayView: UIView!
//    var sun: UIImageView!
    var ARManager: PRARManager!
    
    let NUMBER_OF_POINTS = 2
    
    let MY_VIEW_TAG = 17611
    

    override func viewDidLoad() {
        super.viewDidLoad()

       // self.imagePicker = UIImagePickerController()
       // self.imagePicker.delegate = self
       // self.imagePicker.sourceType = .Camera
        
       // self.sun = UIImageView(image: UIImage(named:"sun"))
       // self.sun.frame = CGRect(x: (self.view.frame.size.width/2) - 50, y: (self.view.frame.size.height/2) - 50, width: 100, height: 100)
        
//        self.overlayView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        
//        self.ARManager = PRARManager.sharedManagerWithSize(self.view.frame.size, andDelegate: self) as! PRARManager
        
        /*- (id)initWithSize:(CGSize)size delegate:(id)delegate showRadar:(BOOL)showRadar;

 */
        
      //  self.ARManager = PRARManager(self.view.frame.size, delegate:self, showRadar:true)
        
        
        self.ARManager = PRARManager.sharedManagerWithRadarAndSize(self.view.frame.size, andDelegate: self) as! PRARManager
        

        
        
        
        
//        overlayView.addSubview(sun)
//
//        self.locationManager = CLLocationManager()
//        self.locationManager.delegate = self
//        self.locationManager.startUpdatingHeading()
        
        
        
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
    
//    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//        
//        let degrees = newHeading.magneticHeading
//        let radians = degrees * M_PI / 180
//        
//        self.sun.transform = CGAffineTransformMakeRotation(CGFloat(-radians))
//        
//        
//    }
    
    @IBAction func startAR() {
       
        //self.ARManager.startARWithData(<#T##arData: [AnyObject]!##[AnyObject]!#>, forLocation: <#T##CLLocationCoordinate2D#>)
        
         // [self.prARManager startARWithData:[self getDummyData] forLocation:locationCoordinates];
        
      //  self.presentViewController(self.imagePicker, animated: true, completion: nil)
      //  self.imagePicker.view.addSubview(overlayView)
        
        let latRand = 29.7604
        let lonRand = 95.3698
//
//        //  let dict =
//        
        let locCoordinates = CLLocationCoordinate2DMake(latRand, lonRand)
//
        var mutableArray = NSMutableArray()
        
        var point = ["id":1,"title":"Sun","lon":locCoordinates.longitude,"lat":locCoordinates.latitude]
        
        var pt = NSMutableDictionary()
        pt["id"] = 1
        pt["title"] = "Sun"
        
        pt["lat"] = "-83.07592988444443"
        pt["lon"] = "-6.782031240844617"
        
        mutableArray.addObject(pt)
        
        var arr = NSArray(array: mutableArray)
        
        
        self.ARManager.startARWithData(arr as! [NSDictionary], forLocation: locCoordinates)
        
    }
    
//    func prarDidSetupAR(arView: UIView!, withCameraLayer cameraLayer: AVCaptureVideoPreviewLayer!) {
//        
//        
//        self.view.layer.addSublayer(cameraLayer)
//        self.view.addSubview(arView)
//        
//
//    }
    
    func prarDidSetupAR(arView: UIView!, withCameraLayer cameraLayer: AVCaptureVideoPreviewLayer!, andRadarView radar: UIView!) {
        
        /*
         [self.view.layer addSublayer:cameraLayer];
         [self.view addSubview:arView];
         
         [self.view bringSubviewToFront:[self.view viewWithTag:AR_VIEW_TAG]];
         
         [self.view addSubview:radar];
         
         [loadingV setHidden:YES];

 */
        
        self.view.layer.addSublayer(cameraLayer)
        self.view.addSubview(arView)
       // self.view.bringSubviewToFront(arView)
        
        let someView = self.view.viewWithTag(MY_VIEW_TAG)
        
        self.view.bringSubviewToFront(self.view.viewWithTag(MY_VIEW_TAG)!)
        
        self.view.addSubview(radar)
      //  self.view.bringSubviewToFront(radar)
        
        
        
    }
    
    func prarUpdateFrame(arViewFrame: CGRect) {
        
//        print(AR_VIEW_TAG)
//        print("Int: \(Int(AR_VIEW_TAG))")
        
        self.view.viewWithTag(MY_VIEW_TAG)!.frame = arViewFrame
    
    }
    
    func getData() -> NSMutableArray {
        let points = NSMutableArray.init(capacity: NUMBER_OF_POINTS)
        
//        srand48(time(0)) as! Int
        for (var i=0; i<NUMBER_OF_POINTS; i += 1)
        {
            let pointCoordinates = self.getRandomLocation
            let point = NSDictionary(dictionary: self.createPointWithId(i, at:pointCoordinates()))
            points.addObject(point)
        }
        
        let finishedArray =  NSMutableArray(array: points)
        
        return finishedArray
        
    }
    
    
    func getRandomLocation() -> CLLocationCoordinate2D {
        
    let latRand = drand48() * 90.0;
    let lonRand = drand48() * 180.0;
    let latSign = drand48();
    let lonSign = drand48();
    
    let locCoordinates = CLLocationCoordinate2DMake(latSign > 0.5 ? latRand : -latRand,
    lonSign > 0.5 ? lonRand*2 : -lonRand*2);
        
        return locCoordinates;
    }
    
    func createPointWithId(the_id: Int, at: CLLocationCoordinate2D) -> NSMutableDictionary{
    
        let point = NSMutableDictionary()

        point.setObject("id", forKey: the_id)
        point.setObject("title", forKey: "Place Number ")
        point.setObject("lon", forKey: at.longitude)
        point.setObject("lat", forKey: at.latitude)

        return point;
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
