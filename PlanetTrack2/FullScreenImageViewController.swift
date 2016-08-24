//
//  FullScreenImageViewController.swift
//  PlanetTrack-Swift
//
//  Created by Matt Milner on 8/17/16.
//  Copyright © 2016 Matt Milner. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var fullScreenImage: UIImageView!
    var sentImage: UIImage!
    @IBOutlet weak var imageScrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.fullScreenImage.image = self.sentImage!
        
        self.imageScrollView.minimumZoomScale=0.5
        self.imageScrollView.maximumZoomScale=4.0
        self.imageScrollView.contentSize=CGSizeMake(1280, 960)
        self.imageScrollView.delegate = self
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        self.fullScreenImage.image = self.sentImage
        return self.fullScreenImage;
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
