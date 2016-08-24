//
//  PlanetTrackHelpViewController.swift
//  PlanetTrack-Swift
//
//  Created by Matt Milner on 8/15/16.
//  Copyright © 2016 Matt Milner. All rights reserved.
//

import UIKit

class PlanetTrackHelpViewController: UIViewController {

    @IBOutlet weak var tutorialView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTutorial()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupTutorial() {
    
        let tutorialOverlay = UIImageView(frame: CGRect(x: (self.tutorialView.frame.size.width/13.5), y: 50, width: 300, height: 175))
        
        tutorialOverlay.image = UIImage(named: "tutorial1")
        self.view.addSubview(tutorialOverlay)
        
        let tutorialText1 = UILabel(frame: CGRect(x: self.tutorialView.frame.size.width - 225, y: 50, width: 350, height: 35))
        tutorialText1.layer.zPosition = 9999
        tutorialText1.font = UIFont(name: "Avenir Next Condensed Demi Bold", size: 20.0)
        tutorialText1.text = "Select the planet you want to change"
        tutorialText1.textColor = UIColor.whiteColor()
        tutorialText1.alpha = 0.0
        
        let tutorialText2 = UILabel(frame: CGRect(x: self.tutorialView.frame.size.width - 225, y: 85, width: 350, height: 35))
        tutorialText2.layer.zPosition = 9999
        tutorialText2.font = UIFont(name: "Avenir Next Condensed Demi Bold", size: 20.0)
        tutorialText2.text = "Choose a new planet from the list"
        tutorialText2.textColor = UIColor.whiteColor()
        tutorialText2.alpha = 0.0

        
        
        let tutorialText3 = UILabel(frame: CGRect(x: self.tutorialView.frame.size.width - 225, y: 120, width: 350, height: 35))
        tutorialText3.layer.zPosition = 9999
        tutorialText3.font = UIFont(name: "Avenir Next Condensed Demi Bold", size: 20.0)
        tutorialText3.text = "Select the destination planet"
        tutorialText3.textColor = UIColor.whiteColor()
        tutorialText3.alpha = 0.0

        
        let tutorialText4 = UILabel(frame: CGRect(x: self.tutorialView.frame.size.width - 225, y: 155, width: 350, height: 35))
        tutorialText4.layer.zPosition = 9999
        tutorialText4.font = UIFont(name: "Avenir Next Condensed Demi Bold", size: 20.0)
        tutorialText4.text = "Choose a destination planet from the list"
        tutorialText4.textColor = UIColor.whiteColor()
        tutorialText4.alpha = 0.0

        
        let tutorialText5 = UILabel(frame: CGRect(x: self.tutorialView.frame.size.width - 225, y: 190, width: 350, height: 35))
        tutorialText5.layer.zPosition = 9999
        tutorialText5.font = UIFont(name: "Avenir Next Condensed Demi Bold", size: 20.0)
        tutorialText5.text = "To change units, select the unit button"
        tutorialText5.textColor = UIColor.whiteColor()
        tutorialText5.alpha = 0.0

        
        let handImage = UIImage(named: "fingerpoint")
        let fingerpointView = UIImageView(frame: CGRect(x: 150, y: 225, width: 60, height: 60))
        fingerpointView.layer.zPosition = 9999
        fingerpointView.image = handImage
        
        
        
        self.tutorialView.addSubview(fingerpointView)
        self.tutorialView.addSubview(tutorialOverlay)
        self.tutorialView.addSubview(tutorialText1)
        self.tutorialView.addSubview(tutorialText2)
        self.tutorialView.addSubview(tutorialText3)
        self.tutorialView.addSubview(tutorialText4)
        self.tutorialView.addSubview(tutorialText5)
        
        
        UIView.animateWithDuration(2.5, animations: {
            
            tutorialText1.alpha = 1.0
            fingerpointView.frame = CGRect(x: 50, y: 125, width: 60, height: 60)

            }) { (x) in
                
                UIView.animateWithDuration(2.5, animations: {
                    
                    tutorialText2.alpha = 1.0
                    fingerpointView.frame = CGRect(x: 163, y: 193, width: 60, height: 60)
                    
                    
                    }, completion: { (y) in
                        
                        tutorialOverlay.image = UIImage(named: "tutorial2")
                        
                        UIView.animateWithDuration(2.5, animations: {
                            
                            tutorialText3.alpha = 1.0
                            fingerpointView.frame = CGRect(x: 270, y: 125, width: 60, height: 60)
                            
                            }, completion: { (z) in
                                
                                UIView.animateWithDuration(2.5, animations: {
                                    
                                    tutorialText4.alpha = 1.0
                                    fingerpointView.frame = CGRect(x: 228, y: 193, width: 60, height: 60)
                                    
                                    
                                    }, completion: { (a) in
                                        tutorialOverlay.image = UIImage(named: "tutorial3")
                                        
                                        UIView.animateWithDuration(2.5, animations: {
                                            
                                            tutorialText5.alpha = 1.0
                                            fingerpointView.frame = CGRect(x: 160, y: 145, width: 60, height: 60)
                                            
                                            }, completion: { (b) in
                                             
                                                tutorialOverlay.image = UIImage(named: "tutorial4")
                                                
                                                UIView.animateWithDuration(2.5, animations: {
                                                    fingerpointView.frame = CGRect(x: 150, y: 225, width: 60, height: 60)
                                                })
                                        })
                                })
                                
                        })
                        
                })
        
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
