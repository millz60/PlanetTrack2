//
//  CustomViewController.swift
//  PlanetTrack-Swift
//
//  Created by Matt Milner on 8/11/16.
//  Copyright © 2016 Matt Milner. All rights reserved.
//

import UIKit

class CustomViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()


    
        self.navigationBar.barStyle = .Black
        self.navigationBar.barTintColor = UIColor(red: 3.0/255.0, green: 88.0/255.0, blue: 131.0/255.0, alpha: 1.0)
        self.navigationBar.tintColor = UIColor.whiteColor()
        let navigationTitleFont = UIFont(name: "Apple SD Gothic Neo", size: 20)!
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont]
        
//        var navImage = UIImage(named: "navbar.png")
//        navImage = navImage!.stretchableImageWithLeftCapWidth(0, topCapHeight: 0)
        
//        self.navigationBar.setBackgroundImage(navImage!.stretchableImageWithLeftCapWidth(0, topCapHeight: 0), forBarMetrics: .Default)
        
        self.navigationBar.setBackgroundImage(UIImage(named: "navbar2.png")!.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .Stretch), forBarMetrics: .Default)
        
        self.navigationBar.backgroundColor = UIColor(patternImage: UIImage(named: "navbar.png")!)

    
    
    
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
