//
//  ImageGalleryTestViewController.swift
//  PlanetTrack-Swift
//
//  Created by Matt Milner on 8/16/16.
//  Copyright © 2016 Matt Milner. All rights reserved.
//

import UIKit

class ImageGalleryTestViewController: UIViewController {
    
    @IBOutlet weak var sentImage: UIImageView!
    @IBOutlet weak var sentText: UITextView!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var imageCountDisplay: UILabel!
    
    var sentImageDictionary: NSMutableDictionary!
    var sentImageDictionaryLength: Int!
    var currentImageNumber: Int!
    var allKeys: [AnyObject]!
    var allValues: [AnyObject]!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.sentImageDictionary)

        let photo = String(self.sentImageDictionary!.allKeys.first!)
        let photoURL = NSURL(string: photo)
        let photoData = NSData(contentsOfURL: photoURL!)
        self.sentImage.image = UIImage(data: photoData!)
        
        self.sentText.text = String(self.sentImageDictionary.allValues.first!)
        self.sentText.scrollRangeToVisible(NSMakeRange(0,0))
        
        self.sentImageDictionaryLength = self.sentImageDictionary.count
        
        self.prevButton.enabled = false
        self.currentImageNumber = 0
        self.imageCountDisplay.text = "Image \(self.currentImageNumber+1)/\(self.sentImageDictionaryLength). Images/Captions Courtesy NASA/JPL-Caltech.   "
        
        allKeys = self.sentImageDictionary.allKeys
        allValues = self.sentImageDictionary.allValues
        
        // Get the progress (activity) indicator to work
        
    
        print(allKeys)

//        let text = allKeys[0] as! String
//        print(text)
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextImageButtonPressed() {
        
        self.prevButton.enabled = true
        
        if (self.currentImageNumber < self.sentImageDictionaryLength-1){
            
            self.currentImageNumber = self.currentImageNumber + 1
            let photo = String(allKeys[currentImageNumber])
            let photoURL = NSURL(string: photo)
            let photoData = NSData(contentsOfURL: photoURL!)
            self.sentImage.image = UIImage(data: photoData!)
            self.sentText.text = String(self.allValues[currentImageNumber])
            self.imageCountDisplay.text = "Image \(self.currentImageNumber+1)/\(self.sentImageDictionaryLength). Images/Captions Courtesy NASA/JPL-Caltech."
            self.sentText.scrollRangeToVisible(NSMakeRange(0,0))

            
        
        } else if (self.currentImageNumber == self.sentImageDictionaryLength-2){
            
            self.nextButton.enabled = false
        }
    }
    
    
    @IBAction func prevButtonPressed(){
        


        
        if (self.currentImageNumber > 0){
            
            self.currentImageNumber = self.currentImageNumber - 1
            let photo = String(allKeys[currentImageNumber])
            let photoURL = NSURL(string: photo)
            let photoData = NSData(contentsOfURL: photoURL!)
            self.sentImage.image = UIImage(data: photoData!)
            self.sentText.text = String(self.allValues[currentImageNumber])
            self.imageCountDisplay.text = "Image \(self.currentImageNumber+1)/\(self.sentImageDictionaryLength). Images/Captions Courtesy NASA/JPL-Caltech."
            self.sentText.scrollRangeToVisible(NSMakeRange(0,0))


            
        } else if (self.currentImageNumber == 0){
            
            self.prevButton.enabled = false
        }
        
        
        
        
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let destination = segue.destinationViewController as! FullScreenImageViewController
        
        destination.fullScreenImage = self.sentImage
        destination.sentImage = self.sentImage.image!
        
        
    }
 

}
