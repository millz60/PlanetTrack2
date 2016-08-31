//
//  WebViewController.swift
//  PlanetTrack2
//
//  Created by Matt Milner on 8/30/16.
//  Copyright © 2016 Matt Milner. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var aboutTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()


        let attributedStringParagraphStyle = NSMutableParagraphStyle()
        attributedStringParagraphStyle.alignment = NSTextAlignment.Center
        
        let attributedString = NSMutableAttributedString(string: "About\nCreator: Matt Milner\nVersion: 1.0\n\n\nPlanetTrack was created to allow users to track planet distances at any given time and combine solar system information from many sources into one interface. Data was originally retreived from NASA’s SPICE Geometry Calculator (http://wgc.jpl.nasa.gov:8080/webgeocalc). PlanetTrack distances are updated daily at 12:00:00 AM. \n\nAcknowlegements:\nMost images from the Image Gallery are Courtesy of NASA/JPL Caltech.  (http://www.jpl.nasa.gov/spaceimages/)\nFull Disk Earth Images are Courtesy of the NOAA.  (http://www.noaa.gov/)\nStock planet images and background screens are taken from the public domain. \nNote: This application is not endorsed by NASA or the NOAA in any way.\n\n\nFeedback:\nLet us know how you like the app by writing a review in the app store.\nTo contact customer support or send feedback or feature requests, please email PlanetTrackApp@gmail.com.")
        
        attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:30.0)!, range:NSMakeRange(0,6))
        attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:18.0)!, range:NSMakeRange(6,380))
        attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:15.0)!, range:NSMakeRange(386,333))
        attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:18.0)!, range:NSMakeRange(719,10))
        attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:15.0)!, range:NSMakeRange(729,175))
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyle, range:NSMakeRange(0,42))
        attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(0,904))
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value:9.0, range:NSMakeRange(0,6))
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(369,15))
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(719,8))
        attributedString.addAttribute(NSLinkAttributeName, value:"http://wgc.jpl.nasa.gov:8080/webgeocalc/#NewCalculation", range:NSMakeRange(269,39))
        attributedString.addAttribute(NSLinkAttributeName, value:"http://www.jpl.nasa.gov/spaceimages/", range:NSMakeRange(457,36))
        attributedString.addAttribute(NSLinkAttributeName, value:"http://www.noaa.gov/", range:NSMakeRange(546,20))
        
        aboutTextView.textStorage.setAttributedString(attributedString)
        aboutTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        aboutTextView.setContentOffset(CGPointZero, animated: false)
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
