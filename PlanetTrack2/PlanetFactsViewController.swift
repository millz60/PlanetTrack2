//
//  PlanetFactsViewController.swift
//  PlanetTrack2
//
//  Created by Matt Milner on 8/25/16.
//  Copyright © 2016 Matt Milner. All rights reserved.
//

import UIKit

class PlanetFactsViewController: UIViewController, UITextFieldDelegate, UIWebViewDelegate {

    @IBOutlet weak var planetFactsTextView: UITextView!
    @IBOutlet weak var planetsStackView: UIStackView!
    @IBOutlet weak var behindTextImage: UIImageView!

    
    var isPlanetsFact = false
    var isWeightFact = false
    var isCompositionFact = false
    var categoryTitle: String!
    var selectedPlanet = ""
    var backgroundImage: UIImage!
    
    var weightSuperView: UIView!
    var selectedPlanetLabel: UILabel!
    var gravitationalForceLabel: UILabel!
    var weightTextField: UITextField!
    var weightResult: UILabel!
    var youWouldWeighLabel: UILabel!
    var keyboardHeight:CGFloat = 0
    
    var compositionSuperView: UIView!
    var planetImageView: UIImageView!
    var informationView: UIView!
    var planetNameLabel: UILabel!
    var compositionTextView: UITextView!
    var sourceLabel: UILabel!
    
    var missionsWebView: UIWebView!
    var loadingLabel: UILabel!
    var isMissionFact = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChange:", name: UIKeyboardWillShowNotification, object: nil)

        
        self.title = categoryTitle
        self.behindTextImage.image = self.backgroundImage
        self.selectedPlanet = "Sun"
        
        
        self.planetsStackView.hidden = false
        
        if(self.categoryTitle! == "10 Facts About Each Planet"){
            self.planetsStackView.hidden = false
            self.isPlanetsFact = true
            
            self.changePlanetInfo()
        } else if(self.categoryTitle! == "Your Weight On Other Planets" ){
            self.planetsStackView.hidden = false
            self.planetFactsTextView.hidden = true
            if UIScreen.mainScreen().bounds.size.height == 320 {
                self.behindTextImage.hidden = true
            }
            self.isWeightFact = true
            self.setupWeightScreen()
            self.addDoneButton()
            
        } else if(self.categoryTitle! == "Planet Composition And Temperature") {
            
            self.planetsStackView.hidden = false
            self.behindTextImage.hidden = true
            self.planetFactsTextView.hidden = true
            self.isCompositionFact = true
            self.setupCompositionScreen()
            
            
        
        } else if(self.categoryTitle! == "Missions And Spacecraft"){
            
            self.planetsStackView.hidden = true
            self.behindTextImage.hidden = true
            self.planetFactsTextView.hidden = true
            self.isMissionFact = true
            
            if(isInternetAvailable()){
                self.setupMissionFacts()
            } else {
                let alert = UIAlertController(title: "Alert", message: "This Feature Requires an Internet Connection.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        
        } else {
            self.planetsStackView.hidden = true
            self.planetsStackView.userInteractionEnabled = false
            self.planetFactsTextView.frame = CGRect(x: 50, y: 50, width: self.view.frame.size.width - 100, height: self.view.frame.size.height - 100)
//            self.setupView()
        }
        
        
        self.planetFactsTextView.scrollRangeToVisible(NSMakeRange(0, 0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        planetFactsTextView.setContentOffset(CGPointZero, animated: false)
    }
    
    func isInternetAvailable() -> Bool {
        let networkReachability : Reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus : NetworkStatus = networkReachability.currentReachabilityStatus()
        
        if networkStatus == NotReachable {
            return false
        } else {
            return true
        }
        
    }
    
    @IBAction func planetSelected(sender: UIButton!) {
        
        self.selectedPlanet = sender.accessibilityIdentifier!
        if(self.isPlanetsFact){
            changePlanetInfo()
            self.planetFactsTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        } else if (self.isWeightFact){
            changeWeightViews()
        } else if (self.isCompositionFact){
            changeCompositionScreen()
             self.compositionTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        }
    }
    
    func setupMissionFacts() {
        
        missionsWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        missionsWebView.delegate = self
        self.missionsWebView.scalesPageToFit = true
        self.missionsWebView.contentMode = UIViewContentMode.ScaleAspectFit
        
        let url = NSURL(string: "https://solarsystem.nasa.gov/missions/")
        
        missionsWebView.loadRequest(NSURLRequest(URL: url!))
        
        let backButton = UIButton(frame: CGRect(x: 0, y: self.view.frame.size.height - 100, width: 75, height: 50))
        backButton.setTitle("◄", forState: .Normal)
        backButton.titleLabel!.font = UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)
        backButton.tintColor = UIColor.whiteColor()
        backButton.backgroundColor = UIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        backButton.addTarget(self, action: #selector(goBack), forControlEvents: .TouchUpInside)
        
        let forwardButton = UIButton(frame: CGRect(x: self.view.frame.size.width - 75, y: self.view.frame.size.height - 100, width: 75, height: 50))
        forwardButton.setTitle("►", forState: .Normal)
        forwardButton.titleLabel!.font = UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)
        forwardButton.tintColor = UIColor.whiteColor()
        forwardButton.backgroundColor = UIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        forwardButton.addTarget(self, action: #selector(goForward), forControlEvents: .TouchUpInside)
        
        let refreshButton = UIButton(frame: CGRect(x: self.view.frame.size.width/2 - (75/2), y: self.view.frame.size.height - 100, width: 75, height: 50))
        refreshButton.setTitle("↻", forState: .Normal)
        refreshButton.titleLabel!.font = UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)
        refreshButton.tintColor = UIColor.whiteColor()
        refreshButton.backgroundColor = UIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        refreshButton.addTarget(self, action: #selector(refresh), forControlEvents: .TouchUpInside)
        
        loadingLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 50, y: (self.view.frame.size.height/2) - 25, width: 100, height: 50))
        loadingLabel.font = UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)
        loadingLabel.text = "Loading..."
        loadingLabel.textAlignment = .Center
        loadingLabel.textColor = UIColor.whiteColor()
        loadingLabel.backgroundColor = UIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        
        
        if UIScreen.mainScreen().bounds.size.height > 414{
            
            missionsWebView.frame = CGRect(x: 0, y: 50, width: self.view.frame.size.width, height: self.view.frame.size.height)
            
        } else{
            
            backButton.frame = CGRect(x: 0, y: self.view.frame.size.height - 80, width: 50, height: 30)
            forwardButton.frame = CGRect(x: self.view.frame.size.width - 50, y: self.view.frame.size.height - 80, width: 50, height: 30)
            refreshButton.frame = CGRect(x: self.view.frame.size.width/2 - 25, y: self.view.frame.size.height - 80, width: 50, height: 30)
            
            
        }
        
        self.view.addSubview(missionsWebView)
        self.view.addSubview(backButton)
        self.view.addSubview(forwardButton)
        self.view.addSubview(refreshButton)
        self.view.addSubview(loadingLabel)
        
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        loadingLabel.hidden = true
        missionsWebView.scalesPageToFit = true
        missionsWebView.contentMode = UIViewContentMode.ScaleAspectFit
        
        
    }
        
    func goBack(){
        
        if(missionsWebView.canGoBack){
            
            missionsWebView.goBack()
            
        }
        
    }
    
    func goForward(){
        
        if(missionsWebView.canGoForward){
            
            missionsWebView.goForward()
            
        }
        
    }
    
    func refresh() {
        
        missionsWebView.reload()
        
    }
    
    
    
    
    func setupCompositionScreen(){
        
        compositionSuperView = UIView(frame: CGRect(x: 10, y: 40, width: (self.view.frame.size.width)-20, height: (self.view.frame.size.height)-160))
        compositionSuperView.backgroundColor = UIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 153.0/255.0, alpha: 0.5)
        compositionSuperView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
        compositionSuperView.layer.cornerRadius = 5.0
        compositionSuperView.layer.borderWidth = 3.0
        compositionSuperView.layer.borderColor = UIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 153.0/255.0, alpha: 1.0).CGColor
        compositionSuperView.layer.masksToBounds = true
        
        planetImageView = UIImageView(frame: CGRect(x: 10, y: (compositionSuperView.frame.size.height/2)/2, width: (compositionSuperView.frame.size.height/2)-90, height: (compositionSuperView.frame.size.height/2)-90))
        planetImageView.image = UIImage(named: String(self.selectedPlanet).lowercaseString)
//        planetImageView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
//        planetImageView.layer.cornerRadius = 5.0
//        planetImageView.layer.borderWidth = 3.0
//        planetImageView.layer.borderColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.5).CGColor
//        planetImageView.layer.masksToBounds = true
        
        informationView = UIView(frame: CGRect(x: (compositionSuperView.frame.size.width/2), y: (compositionSuperView.frame.size.height/2)-(((compositionSuperView.frame.size.height/10)*9-10)/2) - 10, width: (compositionSuperView.frame.size.width/2)-10, height: (compositionSuperView.frame.size.height/10)*9-10))
        informationView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
        informationView.layer.cornerRadius = 5.0
        informationView.layer.borderWidth = 3.0
        informationView.layer.borderColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.5).CGColor
        informationView.layer.masksToBounds = true
        
        planetNameLabel = UILabel()
        planetNameLabel.frame = CGRect(x: (informationView.frame.size.width/2)-120, y: 10, width: 240, height: 35)
        
        let attributedStringParagraphStyle = NSMutableParagraphStyle()
        attributedStringParagraphStyle.alignment = NSTextAlignment.Center
        attributedStringParagraphStyle.minimumLineHeight = 24.762
        attributedStringParagraphStyle.paragraphSpacing = 18.0
        
        let attributedStringShadow = NSShadow()
        attributedStringShadow.shadowOffset = CGSizeMake(1.0, 1.0)
        attributedStringShadow.shadowBlurRadius = 0.0
        attributedStringShadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
        
        let attributedString = NSAttributedString(string: "The Sun", attributes:[NSFontAttributeName:UIFont(name:"AvenirNextCondensed-DemiBold", size:35.0)!,NSForegroundColorAttributeName:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0),NSUnderlineStyleAttributeName:9.0,NSParagraphStyleAttributeName:attributedStringParagraphStyle,NSShadowAttributeName:attributedStringShadow])
        
        planetNameLabel.attributedText = attributedString
        
        planetNameLabel.font = UIFont(name:"AvenirNextCondensed-DemiBold", size:35.0)
        planetNameLabel.shadowColor = UIColor.blackColor()
        planetNameLabel.textColor = UIColor(red: 253.0/255.0, green: 219.0/255.0, blue: 23.0/255.0, alpha: 1.0)
        planetNameLabel.shadowOffset = CGSize(width: 1.0, height: 1.0)
        planetNameLabel.textAlignment = .Center
        
        compositionTextView = UITextView(frame: CGRect(x: 10, y: 45, width: informationView.frame.size.width - 20, height: (informationView.frame.size.height/10)*8-5))
        compositionTextView.text = "Discovery\nDate of Discovery: Unknown\nDiscovered By: Known by the Ancients\nEquatorial Inclination\n7.25 with respect to the ecliptic\n\nEquatorial Radius\nMetric: 695,508 km\nEnglish: 432,168.6 miles\nScientific Notation: 6.9551 x 10^5 km\nBy Comparison: 109.2 x that of Earth\n\nEquatorial Circumference\nMetric: 4,370,005.6 km\nEnglish: 2,715,395.6 miles\nScientific Notation: 4.37001 x 10^6 km\nBy Comparison: 109.2 x that of Earth\n\nVolume\nMetric: 1,409,272,569,059,860,000 km^3\nEnglish: 338,102,469,632,763,000 miles^3\nScientific Notation: 1.40927 x 1018 km^3\nBy Comparison: 1,301,018.805 Earths\n\nMass\nMetric: 1,989,100,000,000,000,000,000,000,000,000 kg\nEnglish: 4,385,214,857,119,400,000,000,000,000,000 lbs\nScientific Notation: 1.989 x 10^30 kg\nBy Comparison: 333,060.402 x Earth's\n\nDensity\nMetric: 1.409 g/cm^3\nBy Comparison: 0.256 that of Earth\n\nSurface Area\nMetric: 6,078,747,774,547 km^2\nEnglish: 2,347,017,636,988 square miles\nScientific Notation: 6.07877 x 1012 km^2\nBy Comparison: 11,917.607 Earths\n\nSurface Gravity\nMetric: 274.0 m/s^2\nEnglish: 899.0 ft/s^2\nScientific Notation: 2.740 x 102 m/s^2\nBy Comparison: 27.96 x Earth's surface gravity\n\nEscape Velocity\nMetric: 2,223,720 km/h\nEnglish: 1,381,756 mph\nScientific Notation: 6.177 x 10^5 m/s\nBy Comparison: 55.20 x Earth\n\nSidereal Rotation Period\n25.38 Earth Days\n609.12 Hours\nBy Comparison: Rotation slows to about 35 days at the poles.\n\nSurface Temperature\nMetric: 5,500 °C\nEnglish: 10,000 °F\n\nEffective Temperature\nMetric: 5504 °C\nEnglish: 9939 °F\nScientific Notation: 5777 K\n\nOther Facts\nSpectral Type: G2 V Luminosity: 3.83 x 10 33 ergs/sec.\n\nAge: 4.6 Billion Years\n\nComposition: 92.1% Hydrogen, 7.8% Helium \n\nSynodic Period: 27.2753 days\n\nRotation Period at Equator: 26.8 days\n\nRotation Period at Poles: 36 days\n\nVelocity Relative to Near Stars: 19.7 km/s\n\nMean Distance to Earth: 149.60 million km (92.96 million mi) (1 astronomical unit)\n\nSolar Constant (Total Solar Irradiance): 1.365 - 1.369 kW/m^2 \n(at the mean distance of the earth from the Sun, about one AU)\n"
        compositionTextView.font = UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)
        compositionTextView.textColor = UIColor.whiteColor()
        compositionTextView.editable = false
        compositionTextView.backgroundColor = UIColor.clearColor()
        compositionTextView.indicatorStyle = UIScrollViewIndicatorStyle.White
        
        sourceLabel = UILabel(frame: CGRect(x: (compositionSuperView.frame.size.width/2), y: (compositionSuperView.frame.size.height/2)-(((compositionSuperView.frame.size.height/10)*10-10)/2) - 5, width: 250, height: 20))
        sourceLabel.text = "Source: https://solarsystem.nasa.gov/planets/\(String(self.selectedPlanet).lowercaseString)/facts"
        sourceLabel.textColor = UIColor.whiteColor()
        sourceLabel.font = UIFont(name:"AvenirNextCondensed-DemiBold", size:10.0)
        
        let scrollLabel = UILabel(frame: CGRect(x: (compositionSuperView.frame.size.width/2), y: (compositionSuperView.frame.size.height) - 45, width: 250, height: 20))
        scrollLabel.textColor = UIColor.whiteColor()
        scrollLabel.font = UIFont(name:"AvenirNextCondensed-DemiBold", size:12.0)
        scrollLabel.text = "Scroll Down ▼"

        
        if UIScreen.mainScreen().bounds.size.height == 320 {
            compositionSuperView.frame = CGRect(x: 10, y: 35, width: (self.view.frame.size.width)-20, height: (self.view.frame.size.height)-150)
            planetImageView.frame = CGRect(x: 30, y: 10, width: 150, height: 150)
            informationView.frame = CGRect(x: (compositionSuperView.frame.size.width/2), y: (compositionSuperView.frame.size.height/2)-(((compositionSuperView.frame.size.height/10)*9-10)/2), width: (compositionSuperView.frame.size.width/2)-10, height: (compositionSuperView.frame.size.height/10)*9-10)
            scrollLabel.frame = CGRect(x: (compositionSuperView.frame.size.width/2)+87.5, y: (compositionSuperView.frame.size.height) - 18, width: 250, height: 20)
            scrollLabel.font = UIFont(name:"AvenirNextCondensed-DemiBold", size:10.0)
            
        } else if UIScreen.mainScreen().bounds.size.height == 414 {
            compositionSuperView.frame = CGRect(x: 10, y: 65, width: (self.view.frame.size.width)-20, height: (self.view.frame.size.height)-180)
            planetImageView.frame = CGRect(x: 60, y: (compositionSuperView.frame.size.height/2)-110, width: 220, height: 220)
            scrollLabel.frame = CGRect(x: (compositionSuperView.frame.size.width/2) + 275, y: (compositionSuperView.frame.size.height) - 25, width: 250, height: 20)
            sourceLabel.frame = CGRect(x: (compositionSuperView.frame.size.width/2) + 15, y: (compositionSuperView.frame.size.height/2)-(((compositionSuperView.frame.size.height/10)*10-10)/2) - 1, width: 250, height: 20)
        } else if UIScreen.mainScreen().bounds.size.height > 414{
            scrollLabel.frame = CGRect(x: (compositionSuperView.frame.size.width/2)+10, y: (compositionSuperView.frame.size.height) - 105, width: 250, height: 20)
            compositionSuperView.frame = CGRect(x: 10, y: 75, width: (self.view.frame.size.width)-20, height: (self.view.frame.size.height)-180)
            planetImageView.frame = CGRect(x: 90, y: (compositionSuperView.frame.size.height/2)/2, width: 300, height: 300)
        } else if UIScreen.mainScreen().bounds.size.height == 375{
            
            sourceLabel.frame = CGRect(x: (compositionSuperView.frame.size.width/2) + 5, y: (compositionSuperView.frame.size.height/2)-(((compositionSuperView.frame.size.height/10)*10-10)/2) - 2, width: 250, height: 20)
            scrollLabel.frame = CGRect(x: (compositionSuperView.frame.size.width/2)+130, y: (compositionSuperView.frame.size.height) - 28, width: 250, height: 20)
            planetImageView.frame = CGRect(x: 60, y: (compositionSuperView.frame.size.height/2)-110, width: 220, height: 220)
            
        }
        
        self.view.addSubview(compositionSuperView)
        compositionSuperView.addSubview(planetImageView)
        compositionSuperView.addSubview(informationView)
        informationView.addSubview(planetNameLabel)
        informationView.addSubview(compositionTextView)
        compositionSuperView.addSubview(sourceLabel)
        compositionSuperView.addSubview(scrollLabel)

        
        
        
    }
    
    func changeCompositionScreen() {
        
        planetImageView.image = UIImage(named: "\(self.selectedPlanet.lowercaseString)")
        sourceLabel.text = "Source: https://solarsystem.nasa.gov/planets/\(String(self.selectedPlanet).lowercaseString)/facts"

        
        if(self.selectedPlanet == "Sun"){
            
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.Center
            attributedStringParagraphStyle.minimumLineHeight = 24.762
            attributedStringParagraphStyle.paragraphSpacing = 18.0
            
            let attributedStringShadow = NSShadow()
            attributedStringShadow.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadow.shadowBlurRadius = 0.0
            attributedStringShadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedString = NSAttributedString(string: "The Sun", attributes:[NSFontAttributeName:UIFont(name:"AvenirNextCondensed-DemiBold", size:35.0)!,NSForegroundColorAttributeName:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0),NSUnderlineStyleAttributeName:9.0,NSParagraphStyleAttributeName:attributedStringParagraphStyle,NSShadowAttributeName:attributedStringShadow])
            
            planetNameLabel.attributedText = attributedString
            
            
            
                   compositionTextView.text = "Discovery\nDate of Discovery: Unknown\nDiscovered By: Known by the Ancients\nEquatorial Inclination\n7.25 with respect to the ecliptic\n\nEquatorial Radius\nMetric: 695,508 km\nEnglish: 432,168.6 miles\nScientific Notation: 6.9551 x 10^5 km\nBy Comparison: 109.2 x that of Earth\n\nEquatorial Circumference\nMetric: 4,370,005.6 km\nEnglish: 2,715,395.6 miles\nScientific Notation: 4.37001 x 10^6 km\nBy Comparison: 109.2 x that of Earth\n\nVolume\nMetric: 1,409,272,569,059,860,000 km^3\nEnglish: 338,102,469,632,763,000 miles^3\nScientific Notation: 1.40927 x 1018 km^3\nBy Comparison: 1,301,018.805 Earths\n\nMass\nMetric: 1,989,100,000,000,000,000,000,000,000,000 kg\nEnglish: 4,385,214,857,119,400,000,000,000,000,000 lbs\nScientific Notation: 1.989 x 10^30 kg\nBy Comparison: 333,060.402 x Earth's\n\nDensity\nMetric: 1.409 g/cm^3\nBy Comparison: 0.256 that of Earth\n\nSurface Area\nMetric: 6,078,747,774,547 km^2\nEnglish: 2,347,017,636,988 square miles\nScientific Notation: 6.07877 x 1012 km^2\nBy Comparison: 11,917.607 Earths\n\nSurface Gravity\nMetric: 274.0 m/s^2\nEnglish: 899.0 ft/s^2\nScientific Notation: 2.740 x 102 m/s^2\nBy Comparison: 27.96 x Earth's surface gravity\n\nEscape Velocity\nMetric: 2,223,720 km/h\nEnglish: 1,381,756 mph\nScientific Notation: 6.177 x 10^5 m/s\nBy Comparison: 55.20 x Earth\n\nSidereal Rotation Period\n25.38 Earth Days\n609.12 Hours\nBy Comparison: Rotation slows to about 35 days at the poles.\n\nSurface Temperature\nMetric: 5,500 °C\nEnglish: 10,000 °F\n\nEffective Temperature\nMetric: 5504 °C\nEnglish: 9939 °F\nScientific Notation: 5777 K\n\nOther Facts\nSpectral Type: G2 V Luminosity: 3.83 x 10 33 ergs/sec.\n\nAge: 4.6 Billion Years\n\nComposition: 92.1% Hydrogen, 7.8% Helium \n\nSynodic Period: 27.2753 days\n\nRotation Period at Equator: 26.8 days\n\nRotation Period at Poles: 36 days\n\nVelocity Relative to Near Stars: 19.7 km/s\n\nMean Distance to Earth: 149.60 million km (92.96 million mi) (1 astronomical unit)\n\nSolar Constant (Total Solar Irradiance): 1.365 - 1.369 kW/m^2 \n(at the mean distance of the earth from the Sun, about one AU)\n"
            
        } else if(self.selectedPlanet == "Mercury"){
            
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.Center
            attributedStringParagraphStyle.minimumLineHeight = 24.762
            attributedStringParagraphStyle.paragraphSpacing = 18.0
            
            let attributedStringShadow = NSShadow()
            attributedStringShadow.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadow.shadowBlurRadius = 0.0
            attributedStringShadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedString = NSAttributedString(string: "Mercury", attributes:[NSFontAttributeName:UIFont(name:"AvenirNextCondensed-DemiBold", size:35.0)!,NSForegroundColorAttributeName:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0),NSUnderlineStyleAttributeName:9.0,NSParagraphStyleAttributeName:attributedStringParagraphStyle,NSShadowAttributeName:attributedStringShadow])
            
            planetNameLabel.attributedText = attributedString
            
            compositionTextView.text = "Discovery\nDate of Discovery: Unknown\nDiscovered By: Known by the Ancients\n\n\nOrbit Size Around Sun\nMetric: 57,909,227 km\nEnglish: 35,983,125 miles\nScientific Notation: 5.7909227 x 10^7 km\nAstronomical Units: 0.38709927 A.U.\nBy Comparison: Earth is 1 A.U. (Astronomical Unit) from the sun.\n\n\nMean Orbit Velocity\nMetric: 170,503 km/h\nEnglish: 105,946 mph\nScientific Notation: 4.7362 x 10^4 m/s\nBy Comparison: 1.590 x Earth\n\n\nOrbit Eccentricity\n0.20563593\nBy Comparison: 12.305 x Earth\n\n\nEquatorial Inclination\n0 degrees\nBy Comparison: Earth's equatorial inclination to orbit is 23.45 degrees.\n\n\nEquatorial Radius\nMetric: 2,439.7 km\nEnglish: 1,516.0 miles\nScientific Notation: 2.4397 x 10^3 km\nBy Comparison: 0.3829 x Earth\n\n\nEquatorial Circumference\nMetric: 15,329.1 km\nEnglish: 9,525.1 miles\nScientific Notation: 1.53291 x 10^4 km\n\n\nVolume\nMetric: 60,827,208,742 km^3\nEnglish: 14,593,223,446 miles^3\nScientific Notation: 6.08272 x 10^10 km^3\nBy Comparison: 0.056 x Earth's\n\n\nMass\nMetric: 330,104,000,000,000,000,000,000 kg\nScientific Notation: 3.3010 x 10^23 kg\nBy Comparison: 0.055 x Earth's\n\n\nDensity\nMetric: 5.427 g/cm3\nBy Comparison: 0.984 x Earth\n\n\nSurface Area\nMetric: 74,797,000 km^2\nEnglish: 28,879,000 square miles\nScientific Notation: 7.4797 x 107 km^2\nBy Comparison: 0.147 x Earth\n\n\nSurface Gravity\nMetric: 3.7 m/s2\nEnglish: 12.1 ft/s^2\nBy Comparison: If you weigh 100 pounds on Earth, you would weigh 38 pounds on Mercury.\n\n\nEscape Velocity\nMetric: 15,300 km/h\nEnglish: 9,507 mph\nScientific Notation: 4.25 x 10^3 m/s\nBy Comparison: Escape Velocity of Earth is 25,030 mph\n\n\nSidereal Rotation Period\n58.646 Earth Days\n1407.5 Hours\nBy Comparison: 58.81 x Earth\n\n\nSurface Temperature\nMetric: -173/427 °C\nEnglish: -279/801 °F\nScientific Notation: 100/700 K\nBy Comparison: Earth's temperature range is ~ 185/331 K.\n\n\nAtmospheric Constituents\nBy Comparison: Earth's atmosphere consists mostly of N2, O2\n\n\nOther Facts\nNamesake: Messenger of the Roman gods\n\nSuccessive Sunrises: 175.97 days\n"
            
        } else if(self.selectedPlanet == "Venus"){
            
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.Center
            attributedStringParagraphStyle.minimumLineHeight = 24.762
            attributedStringParagraphStyle.paragraphSpacing = 18.0
            
            let attributedStringShadow = NSShadow()
            attributedStringShadow.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadow.shadowBlurRadius = 0.0
            attributedStringShadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedString = NSAttributedString(string: "Venus", attributes:[NSFontAttributeName:UIFont(name:"AvenirNextCondensed-DemiBold", size:35.0)!,NSForegroundColorAttributeName:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0),NSUnderlineStyleAttributeName:9.0,NSParagraphStyleAttributeName:attributedStringParagraphStyle,NSShadowAttributeName:attributedStringShadow])
            
            planetNameLabel.attributedText = attributedString
            
            compositionTextView.text = "Discovery\nDate of Discovery: Unknown\nDiscovered By: Known by the Ancients\n\n\nOrbit Size Around Sun\nMetric: 108,209,475 km\nEnglish: 67,238,251 miles\nScientific Notation: 1.0820948 x 10^8 km\nAstronomical Units: 7.2333566 x 10-1 A.U.\nBy Comparison: 0.723 x Earth\n\n\nMean Orbit Velocity\nMetric: 126,074 km/h\nEnglish: 78,339 mph\nScientific Notation: 3.5020 x 104 m/s\nBy Comparison: 1.176 x Earth\n\n\nOrbit Eccentricity\n0.00677672\nBy Comparison: 0.406 x Earth\n\n\nEquatorial Inclination\n177.3 degrees (retrograde rotation)\nBy Comparison: 7.56 x Earth\n\n\nEquatorial Radius\nMetric: 6,051.8 km\nEnglish: 3,760.4 miles\nScientific Notation: 6.0518 x 10^3 km\nBy Comparison: 0.9499 x Earth\n\n\nEquatorial Circumference\nMetric: 38,024.6 km\nEnglish: 23,627.4 miles\nScientific Notation: 3.80246 x 10^4 km\nBy Comparison: 0.9499 x Earth's\n\n\nVolume\nMetric: 928,415,345,893 km^3\nEnglish: 222,738,686,740 miles^3\nScientific Notation: 9.28415 x 10^11 km3\nBy Comparison: 0.857 x Earth's\n\n\nMass\nMetric: 4,867,320,000,000,000,000,000,000 kg\nScientific Notation: 4.8673 x 10^24 kg\nBy Comparison: 0.815 x Earth\n\n\nDensity\nMetric: 5.243 g/cm^3\nBy Comparison: Comparable to the average density of the Earth.\n\n\nSurface Area\nMetric: 460,234,317 km^2\nEnglish: 177,697,463 square miles\nScientific Notation: 4.6023 x 10^8 km2\nBy Comparison: 0.902 x Earth\n\n\nSurface Gravity\nMetric: 8.87 m/s^2\nEnglish: 29.1 ft/s2\nBy Comparison: If you weigh 100 pounds on Earth, you would weigh 91 pounds on Venus.\n\n\nEscape Velocity\nMetric: 37,296 km/h\nEnglish: 23,175 mph\nScientific Notation: 1.036 x 10^4 m/s\nBy Comparison: 0.926 x Earth\n\n\nSidereal Rotation Period\n-243.018 Earth Days\n-5832.4 Hours\nBy Comparison: 243.68 x Earth\n\n\nSurface Temperature\nMetric: 462 °C\nEnglish: 864 °F\nScientific Notation: 735 K\n\n\nAtmospheric Constituents\nCarbon Dioxide, Nitrogen\nScientific Notation: CO2, N2\nBy Comparison: Earth's atmosphere consists mostly of N2 and O2.\nCO2 is largely responsible for the Greenhouse Effect and is used for carbonation in beverages.\nN2 is 80% of Earth's air and is a crucial element in DNA.\n"
            
        } else if(self.selectedPlanet == "Earth"){
            
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.Center
            attributedStringParagraphStyle.minimumLineHeight = 24.762
            attributedStringParagraphStyle.paragraphSpacing = 18.0
            
            let attributedStringShadow = NSShadow()
            attributedStringShadow.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadow.shadowBlurRadius = 0.0
            attributedStringShadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedString = NSAttributedString(string: "Earth", attributes:[NSFontAttributeName:UIFont(name:"AvenirNextCondensed-DemiBold", size:35.0)!,NSForegroundColorAttributeName:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0),NSUnderlineStyleAttributeName:9.0,NSParagraphStyleAttributeName:attributedStringParagraphStyle,NSShadowAttributeName:attributedStringShadow])
            
            planetNameLabel.attributedText = attributedString
            
            compositionTextView.text = "Discovery\nDate of Discovery: Unknown\nDiscovered By: Known by the Ancients\n\n\nOrbit Size Around Sun\nMetric: 149,598,262 km\nEnglish: 92,956,050 miles\nScientific Notation: 1.4959826 x 10^8 km\nAstronomical Units: 1.000 A.U.\n\n\nMean Orbit Velocity\nMetric: 107,218 km/h\nEnglish: 66,622 mph\nScientific Notation: 2.9783 x 10^4 m/s\n\n\nOrbit Eccentricity\n0.01671123\n\n\nEquatorial Inclination\n23.4393 degrees\n\n\nEquatorial Radius\nMetric: 6,371.00 km\nEnglish: 3,958.8 miles\nScientific Notation: 6.3710 x 10^3 km\n\n\nEquatorial Circumference\nMetric: 40,030.2 km\nEnglish: 24,873.6 miles\nScientific Notation: 4.00302 x 10^4 km\n\n\nVolume\nMetric: 1,083,206,916,846 km^3\nEnglish: 259,875,159,532 miles^3\nScientific Notation: 1.08321 x 10^12 km^3\n\n\nMass\nMetric: 5,972,190,000,000,000,000,000,000 kg\nScientific Notation: 5.9722 x 10^24 kg\n\n\nDensity\nMetric: 5.513 g/cm^3\n\n\nSurface Area\nMetric: 510,064,472 km^2\nEnglish: 196,936,994 square miles\nScientific Notation: 5.1006 x 10^8 km2\n\n\nSurface Gravity\nMetric: 9.80665 m/s^2\nEnglish: 32.041 ft/s^2\n\n\nEscape Velocity\nMetric: 40,284 km/h\nEnglish: 25,031 mph\nScientific Notation: 1.119 x 10^4 m/s\n\n\nSidereal Rotation Period\n0.99726968 Earth Days\n23.934 Hours\n\n\nSurface Temperature\nMetric: -88/58 (min/max) °C\nEnglish: -126/136 (min/max) °F\nScientific Notation: 185/331 (min/max) K\n\n\nAtmospheric Constituents\nNitrogen, Oxygen\nScientific Notation: N2, O2\nBy Comparison: N2 is 80% of Earth's air and is a crucial element in DNA.\n"
            
        } else if(self.selectedPlanet == "Mars"){
            
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.Center
            attributedStringParagraphStyle.minimumLineHeight = 24.762
            attributedStringParagraphStyle.paragraphSpacing = 18.0
            
            let attributedStringShadow = NSShadow()
            attributedStringShadow.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadow.shadowBlurRadius = 0.0
            attributedStringShadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedString = NSAttributedString(string: "Mars", attributes:[NSFontAttributeName:UIFont(name:"AvenirNextCondensed-DemiBold", size:35.0)!,NSForegroundColorAttributeName:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0),NSUnderlineStyleAttributeName:9.0,NSParagraphStyleAttributeName:attributedStringParagraphStyle,NSShadowAttributeName:attributedStringShadow])
            
            planetNameLabel.attributedText = attributedString
            
            compositionTextView.text = "Discovery\nDate of Discovery: Unknown\nDiscovered By: Known by the Ancients\n\n\nOrbit Size Around Sun\nMetric: 227,943,824 km\nEnglish: 141,637,725 miles\nScientific Notation: 2.2794382 x 10^8 km\nAstronomical Units: 1.523662 A.U.\nBy Comparison: 1.524 x Earth\n\n\nMean Orbit Velocity\nMetric: 86,677 km/h\nEnglish: 53,858 mph\nScientific Notation: 2.4077 x 10^4 m/s\nBy Comparison: 0.808 x Earth\n\n\nOrbit Eccentricity\n0.0933941\nBy Comparison: 5.589 x Earth\n\n\nEquatorial Inclination\n25.2\n\n\nEquatorial Radius\nMetric: 3,389.5 km\nEnglish: 2,106.1 miles\nScientific Notation: 3.3895 x 10^3 km\nBy Comparison: 0.5320 x Earth\n\n\nEquatorial Circumference\nMetric: 21,296.9 km\nEnglish: 13,233.3 miles\nScientific Notation: 2.12969 x 10^4 km\n\n\nVolume\nMetric: 163,115,609,799 km^3\nEnglish: 39,133,515,914 miles^3\nScientific Notation: 1.63116 X 1011 km^3\nBy Comparison: 0.151 x Earth\n\n\nMass\nMetric: 641,693,000,000,000,000,000,000 kg\nScientific Notation: 6.4169 x 1023 kg\nBy Comparison: 0.107 x Earth\n\n\nDensity\nMetric: 3.934 g/cm3\nBy Comparison: 0.714 x Earth\n\n\nSurface Area\nMetric: 144,371,391 km^2\nEnglish: 55,742,106 square miles\nScientific Notation: 1.4437 x 10^8 km^2\nBy Comparison: 0.283 x Earth\n\n\nSurface Gravity\nMetric: 3.71 m/s^2\nEnglish: 12.2 ft/s^2\nBy Comparison: If you weigh 100 pounds on Earth, you would weigh 38 pounds on Mars.\n\n\nEscape Velocity\nMetric: 18,108 km/h\nEnglish: 11,252 mph\nScientific Notation: 5.030 x 10^3 m/s\nBy Comparison: Escape velocity of Earth is 25,030 mph.\n\n\nSidereal Rotation Period\n1.026 Earth Days\n24.623 Hours\nBy Comparison: Earth's rotation period is 23.934 hours.\n\n\nSurface Temperature\nMetric: -153 to +20 °C\nEnglish: -225 to +70 °F\nScientific Notation: 120 to 293 K\n\n\nAtmospheric Constituents\nCarbon Dioxide, Nitrogen, Argon\nScientific Notation: CO2, N2, Ar\nBy Comparison: CO2 is responsible for the Greenhouse Effect and is used for carbonation in beverages.\nN2 is 80% of Earth's air and is a crucial element in DNA. Ar is used to make blue neon light bulbs.\n"
            
        } else if(self.selectedPlanet == "Jupiter"){
            
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.Center
            attributedStringParagraphStyle.minimumLineHeight = 24.762
            attributedStringParagraphStyle.paragraphSpacing = 18.0
            
            let attributedStringShadow = NSShadow()
            attributedStringShadow.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadow.shadowBlurRadius = 0.0
            attributedStringShadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedString = NSAttributedString(string: "Jupiter", attributes:[NSFontAttributeName:UIFont(name:"AvenirNextCondensed-DemiBold", size:35.0)!,NSForegroundColorAttributeName:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0),NSUnderlineStyleAttributeName:9.0,NSParagraphStyleAttributeName:attributedStringParagraphStyle,NSShadowAttributeName:attributedStringShadow])
            
            planetNameLabel.attributedText = attributedString
            
            compositionTextView.text = "Discovery\nDate of Discovery: Unknown\nDiscovered By: Known by the Ancients\n\n\nOrbit Size Around Sun\nMetric: 778,340,821 km\nEnglish: 483,638,564 miles\nScientific Notation: 7.7834082 x 10^8 km\nAstronomical Units: 5.2028870 A.U.\nBy Comparison: 5.203 x Earth\n\n\nMean Orbit Velocity\nMetric: 47,002 km/h\nEnglish: 29,205 mph\nScientific Notation: 1.3056 x 10^4 m/s\nBy Comparison: 0.438 x Earth\n\n\nOrbit Eccentricity\n0.04838624\nBy Comparison: 2.895 x Earth\n\n\nEquatorial Inclination\n3.1 degrees\n\n\nEquatorial Radius\nMetric: 69,911 km\nEnglish: 43,440.7 miles\nScientific Notation: 6.9911 x 10^4 km\nBy Comparison: 10.9733 x Earth\n\n\nEquatorial Circumference\nMetric: 439,263.8 km\nEnglish: 272,945.9 miles\nScientific Notation: 4.39264 x 10^5 km\nBy Comparison: 10.9733 x Earth\n\n\nVolume\nMetric: 1,431,281,810,739,360 km^3\nEnglish: 343,382,767,518,322 miles^3\nScientific Notation: 1.43128 x 10^15 km^3\nBy Comparison: 1321.337 x Earth\n\n\nMass\nMetric: 1,898,130,000,000,000,000,000,000,000 kg\nScientific Notation: 1.8981 x 10^27 kg\nBy Comparison: 317.828 x Earth\n\n\nDensity\nMetric: 1.326 g/cm^3\nBy Comparison: 0.241 x Earth\n\n\nSurface Area\nMetric: 61,418,738,571 km^2\nEnglish: 23,713,907,537 square miles\nScientific Notation: 6.1419 x 10^10 km^2\nBy Comparison: 120.414 x Earth\n\n\nSurface Gravity\nMetric: 24.79 m/s^2\nEnglish: 81.3 ft/s^2\nBy Comparison: If you weigh 100 pounds on Earth, you would weigh 253 pounds on Jupiter.\n\n\nEscape Velocity\nMetric: 216,720 km/h\nEnglish: 134,664 mph\nScientific Notation: 6.020 x 10^4 m/s\nBy Comparison: 5.380 x Earth\n\n\nSidereal Rotation Period\n0.41354 Earth Days\n9.92496 Hours\nBy Comparison: 0.41467 x Earth\n\n\nEffective Temperature\nMetric: -148 °C\nEnglish: -234 °F\nScientific Notation: 125 K\n\n\nAtmospheric Constituents\nHydrogen, Helium\nScientific Notation: H2, He\n\n\nOther Facts\nNamesake: King of the Roman gods\n"
            
        } else if(self.selectedPlanet == "Saturn"){
            
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.Center
            attributedStringParagraphStyle.minimumLineHeight = 24.762
            attributedStringParagraphStyle.paragraphSpacing = 18.0
            
            let attributedStringShadow = NSShadow()
            attributedStringShadow.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadow.shadowBlurRadius = 0.0
            attributedStringShadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedString = NSAttributedString(string: "Saturn", attributes:[NSFontAttributeName:UIFont(name:"AvenirNextCondensed-DemiBold", size:35.0)!,NSForegroundColorAttributeName:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0),NSUnderlineStyleAttributeName:9.0,NSParagraphStyleAttributeName:attributedStringParagraphStyle,NSShadowAttributeName:attributedStringShadow])
            
            planetNameLabel.attributedText = attributedString
            
            compositionTextView.text = "Discovery\nDate of Discovery: Unknown\nDiscovered By: Known by the Ancients\n\n\nOrbit Size Around Sun\nMetric: 1,426,666,422 km\nEnglish: 886,489,415 miles\nScientific Notation: 1.4266664 x 10^9 km\nAstronomical Units: 9.53667594 A.U.\nBy Comparison: 9.537 x Earth\n\n\nMean Orbit Velocity\nMetric: 34,701 km/h\nEnglish: 21,562 mph\nScientific Notation: 9.6391 x 10^3 m/s\nBy Comparison: 0.324 x Earth\n\n\nOrbit Eccentricity\n0.05386179\nBy Comparison: 3.223 x Earth\n\n\nEquatorial Inclination\n26.7 degrees\n\n\nEquatorial Radius\nMetric: 58,232 km\nEnglish: 36,183.7 miles\nScientific Notation: 5.8232 x 10^4 km\nBy Comparison: 9.1402 x Earth\n\n\nEquatorial Circumference\nMetric: 365,882.4 km\nEnglish: 227,348.8 miles\nScientific Notation: 3.65882 x 10^5 km\nBy Comparison: 9.1402 x Earth\n\n\nVolume\nMetric: 827,129,915,150,897 km^3\nEnglish: 198,439,019,647,006 miles^3\nScientific Notation: 8.2713 x 10^14 km^3\nBy Comparison: 763.594 x Earth\n\n\nMass\nMetric: 568,319,000,000,000,000,000,000,000 kg\nScientific Notation: 5.6832 x 10^26 kg\nBy Comparison: 95.161 x Earth\n\n\nDensity\nMetric: 0.687 g/cm^3\nBy Comparison: 0.125 x Earth\n\n\nSurface Area\nMetric: 42,612,133,285 km^2\nEnglish: 16,452,636,641 square miles\nScientific Notation: 4.2612 x 10^10 km2\nBy Comparison: 83.543 x Earth\n\n\nSurface Gravity\nMetric: 10.4* m/s^2\nEnglish: 34.3 ft/s2\nBy Comparison: If you weigh 100 pounds on Earth, you would weigh about 107 pounds on Saturn (at the equator). *Derived from a 1 bar radius of 60,268 km.\n\n\nEscape Velocity\nMetric: 129,924 km/h\nEnglish: 80,731 mph\nScientific Notation: 3.609 x 10^4 m/s\nBy Comparison: Escape velocity of Earth is 25,030 mph.\n\n\nSidereal Rotation Period\n0.444 Earth Days\n10.656 Hours\nBy Comparison: 0.445 x Earth\n\n\nEffective Temperature\nMetric: -178 °C\nEnglish: -288 °F\nScientific Notation: 95 K\n\n\nAtmospheric Constituents\nHydrogen, Helium\nScientific Notation: H2, He\nBy Comparison: Earth's atmosphere consists mostly of N2 and O2.\n\n\nOther Facts\nNamesake: Roman god of agriculture. \n"
            
        } else if(self.selectedPlanet == "Uranus"){
            
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.Center
            attributedStringParagraphStyle.minimumLineHeight = 24.762
            attributedStringParagraphStyle.paragraphSpacing = 18.0
            
            let attributedStringShadow = NSShadow()
            attributedStringShadow.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadow.shadowBlurRadius = 0.0
            attributedStringShadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedString = NSAttributedString(string: "Uranus", attributes:[NSFontAttributeName:UIFont(name:"AvenirNextCondensed-DemiBold", size:35.0)!,NSForegroundColorAttributeName:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0),NSUnderlineStyleAttributeName:9.0,NSParagraphStyleAttributeName:attributedStringParagraphStyle,NSShadowAttributeName:attributedStringShadow])
            
            planetNameLabel.attributedText = attributedString
            
            compositionTextView.text = "Discovery\nDate of Discovery: 13 March 1781\nDiscovered By: William Herschel\n\n\nOrbit Size Around Sun\nMetric: 2,870,658,186 km\nEnglish: 1,783,744,300 miles\nScientific Notation: 2.8706582 x 10^9 km\nAstronomical Units: 1.9189165 x 101 A.U.\nBy Comparison: 19.189 x Earth\n\n\nMean Orbit Velocity\nMetric: 24,477 km/h\nEnglish: 15,209 mph\nScientific Notation: 6.7991 x 10^3 m/s\nBy Comparison: 0.228 x Earth\n\n\nOrbit Eccentricity\n0.04725744\nBy Comparison: 2.828 x Earth\n\n\nEquatorial Inclination\n97.8 degrees (retrograde rotation)\nBy Comparison: 4.173 x Earth\n\n\nEquatorial Radius\nMetric: 25,362 km\nEnglish: 15,759.2 miles\nScientific Notation: 2.5362 x 10^4 km\nBy Comparison: 3.9809 x Earth\n\n\nEquatorial Circumference\nMetric: 159,354.1 km\nEnglish: 99,018.1 miles\nScientific Notation: 1.59354 x 10^5 km\nBy Comparison: 3.9809 x Earth\n\n\nVolume\nMetric: 68,334,355,695,584 km^3\nScientific Notation: 6.83344 x 10^13 km^3\nBy Comparison: 63.085 x Earth\n\n\nMass\nMetric: 86,810,300,000,000,000,000,000,000 kg\nScientific Notation: 8.6810 x 10^25 kg\nBy Comparison: 14.536 x Earth's\n\n\nDensity\nMetric: 1.270 g/cm^3\nBy Comparison: 0.230 x Earth\n\n\nSurface Area\nMetric: 8,083,079,690 km^2\nEnglish: 3,120,894,516 square miles\nScientific Notation: 8.0831 x 109 km^2\nBy Comparison: 15.847 x Earth\n\n\nSurface Gravity\nMetric: 8.87 m/s^2\nEnglish: 29.1 ft/s^2\nBy Comparison: If you weigh 100 pounds on Earth, you would weigh 91 pounds on Uranus.\n\n\nEscape Velocity\nMetric: 76,968 km/h\nEnglish: 47,826 mph\nScientific Notation: 2.138 x 10^4 m/s\nBy Comparison: 1.911 x Earth\n\n\nSidereal Rotation Period\n-0.718 Earth Days\n-17.23992 Hours\nBy Comparison: 0.72 x Earth\n\n\nEffective Temperature\nMetric: -216 °C\nEnglish: -357 °F\nScientific Notation: 57 K\n\n\nAtmospheric Constituents\nHydrogen, Helium, Methane\nScientific Notation: H2, He, CH4\nBy Comparison: Earth's atmosphere consists mostly of N2 and O2.\n"
            
        } else if(self.selectedPlanet == "Neptune"){
            
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.Center
            attributedStringParagraphStyle.minimumLineHeight = 24.762
            attributedStringParagraphStyle.paragraphSpacing = 18.0
            
            let attributedStringShadow = NSShadow()
            attributedStringShadow.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadow.shadowBlurRadius = 0.0
            attributedStringShadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedString = NSAttributedString(string: "Neptune", attributes:[NSFontAttributeName:UIFont(name:"AvenirNextCondensed-DemiBold", size:35.0)!,NSForegroundColorAttributeName:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0),NSUnderlineStyleAttributeName:9.0,NSParagraphStyleAttributeName:attributedStringParagraphStyle,NSShadowAttributeName:attributedStringShadow])
            
            planetNameLabel.attributedText = attributedString
            
            compositionTextView.text = "Discovery\nDate of Discovery: 23 September 1846\nDiscovered By: Urbain Le Verrier, John Couch Adams, Johann Galle\n\n\nOrbit Size Around Sun\nMetric: 4,498,396,441 km\nEnglish: 2,795,173,960 miles\nScientific Notation: 4.4983964 x 10^9 km\nAstronomical Units: 3.0069923 x 101 A.U.\nBy Comparison: 30.070 x Earth\n\n\nMean Orbit Velocity\nMetric: 19,566 km/h\nEnglish: 12,158 mph\nScientific Notation: 5.4349 x 10^3 m/s\nBy Comparison: 0.182 x Earth\n\n\nOrbit Eccentricity\n0.00859048\nBy Comparison: 0.514 x Earth\n\n\nEquatorial Inclination\n28.3 degrees\n\n\nEquatorial Radius\nMetric: 24,622 km\nEnglish: 15,299.4 miles\nScientific Notation: 2.4622 x 10^4 km\nBy Comparison: 3.8647 x Earth\n\n\nEquatorial Circumference\nMetric: 154,704.6 km\nEnglish: 96,129.0 miles\nScientific Notation: 1.54705 x 10^5 km\nBy Comparison: 3.8647 x Earth\n\n\nVolume\nMetric: 62,525,703,987,421 km^3\nEnglish: 15,000,714,125,712 miles^3\nScientific Notation: 6.25257 x 10^13 km^3\nBy Comparison: 57.723 x Earth\n\n\nMass\nMetric: 102,410,000,000,000,000,000,000,000 kg\nScientific Notation: 1.0241 x 10^26 kg\nBy Comparison: 17.148 x Earth\n\n\nDensity\nMetric: 1.638 g/cm^3\nBy Comparison: 0.297 x Earth\n\n\nSurface Area\nMetric: 7,618,272,763 km^2\nEnglish: 2,941,431,558 square miles\nScientific Notation: 7.6183 x 10^9 km^2\nBy Comparison: 14.980 x Earth\n\n\nSurface Gravity\nMetric: 11.15 m/s^2\nEnglish: 36.6 ft/s^2\nBy Comparison: If you weigh 100 pounds on Earth, you would weigh 114 pounds on Neptune.\n\n\nEscape Velocity\nMetric: 84,816 km/h\nEnglish: 52,702 mph\nScientific Notation: 2.356 x 10^4 m/s\nBy Comparison: By Comparison: 2.105 x Earth.\n\n\nSidereal Rotation Period\n0.671 Earth Days\n16.11000 Hours\nBy Comparison: 0.67 x Earth\n\n\nEffective Temperature\nMetric: -214 °C\nEnglish: -353 °F\nScientific Notation: 59 K\n\n\nAtmospheric Constituents\nHydrogen, Helium, Methane\nScientific Notation: H2, He, CH4\nBy Comparison: Earth atmosphere consists mostly of N2 and O2.\n\n"
            
        }
        
        
        
        
        
        
        
    }
    
    
    private func changePlanetInfo() {
        
        self.behindTextImage.image = UIImage(named: "\(self.selectedPlanet.lowercaseString)")
        
    if(self.isPlanetsFact){
        if(self.selectedPlanet == "Sun"){
            
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.Center
            
            let attributedStringParagraphStyleOne = NSMutableParagraphStyle()
            attributedStringParagraphStyleOne.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleOne.minimumLineHeight = 24.762
            attributedStringParagraphStyleOne.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleTwo = NSMutableParagraphStyle()
            attributedStringParagraphStyleTwo.alignment = NSTextAlignment.Center
            attributedStringParagraphStyleTwo.minimumLineHeight = 22.85
            
            let attributedStringShadow = NSShadow()
            attributedStringShadow.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadow.shadowBlurRadius = 0.0
            attributedStringShadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowOne = NSShadow()
            attributedStringShadowOne.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowOne.shadowBlurRadius = 0.0
            attributedStringShadowOne.shadowColor = UIColor.blackColor()
            
            let attributedStringShadowTwo = NSShadow()
            attributedStringShadowTwo.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowTwo.shadowBlurRadius = 0.0
            attributedStringShadowTwo.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowThree = NSShadow()
            attributedStringShadowThree.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowThree.shadowBlurRadius = 0.0
            attributedStringShadowThree.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowFour = NSShadow()
            attributedStringShadowFour.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowFour.shadowBlurRadius = 0.0
            attributedStringShadowFour.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowFive = NSShadow()
            attributedStringShadowFive.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowFive.shadowBlurRadius = 0.0
            attributedStringShadowFive.shadowColor = UIColor.blackColor()
            
            let attributedStringShadowSix = NSShadow()
            attributedStringShadowSix.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowSix.shadowBlurRadius = 0.0
            attributedStringShadowSix.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowSeven = NSShadow()
            attributedStringShadowSeven.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowSeven.shadowBlurRadius = 0.0
            attributedStringShadowSeven.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowEight = NSShadow()
            attributedStringShadowEight.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowEight.shadowBlurRadius = 0.0
            attributedStringShadowEight.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowNine = NSShadow()
            attributedStringShadowNine.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowNine.shadowBlurRadius = 0.0
            attributedStringShadowNine.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowTen = NSShadow()
            attributedStringShadowTen.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowTen.shadowBlurRadius = 0.0
            attributedStringShadowTen.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedString = NSMutableAttributedString(string: "The Sun\n1. Biggest\nIf the sun were as tall as a typical front door, Earth would be about the size of a nickel.\n2. Most Massive\nThe sun is the center of our solar system and makes up 99.8% of the mass of the entire solar system.\n3. Different Spin\nSince the sun is not a solid body, different parts of the sun rotate at different rates. At the equator, the sun spins once about every 25 days, but at its poles the sun rotates once on its axis every 36 Earth days.\n4. Can't Stand on It\nThe sun is a star. A star does not have a solid surface, but is a ball of gas (92.1% hydrogen (H2) and 7.8% helium (He)) held together by its own gravity.\n5. What We See\nThe solar atmosphere (a thin layer of gases) is where we see features such as sunspots and solar flares on the sun.\n6. Keeping Everything in Orbit\nThe sun is not a planet, so it does not have any moons. The sun is orbited by eight planets, at least five dwarf planets, tens of thousands of asteroids, and hundreds of thousands to three trillion comets and icy bodies.\n7. Ringless\nThe sun does not have any rings.\n8. Under Study\nSeveral spacecraft keep the sun under constant observation - learning its secrets and warning Earth about dangerous space weather.\n9. Energy for Life\nWithout the sun's intense energy there would be no life on Earth.\n10. Nuclear Fusion\nThe temperature at the sun's core is about 27 million degrees Fahrenheit (15 million degrees Celsius).\n\nSource: Solar System Exploration. (n.d.). Retrieved August 27, 2016, from https://solarsystem.nasa.gov/planets/sun/needtoknow\n")
            
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:30.0)!, range:NSMakeRange(0,8))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(8,10))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(18,93))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(111,15))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(126,102))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(228,17))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(245,216))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(462,20))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(483,96))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:13.0)!, range:NSMakeRange(579,1))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(580,28))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(609,28))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(638,14))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(652,117))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(769,30))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(799,222))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1021,11))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1032,34))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1066,14))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1080,132))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1212,18))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1230,67))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1297,18))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1315,105))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:10.0)!, range:NSMakeRange(1420,125))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyle, range:NSMakeRange(0,8))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleOne, range:NSMakeRange(8,1412))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleTwo, range:NSMakeRange(1420,126))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(0,8))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(8,10))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(19,91))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(111,15))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(127,100))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(228,17))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(246,215))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(462,20))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(483,154))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(638,14))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(653,115))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(769,30))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(800,220))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1021,11))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1033,32))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1066,14))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1081,130))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1212,18))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1231,65))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1297,18))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1316,104))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor.whiteColor(), range:NSMakeRange(1420,125))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:9.0, range:NSMakeRange(0,8))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(11,7))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(114,12))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(231,14))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(465,17))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(641,11))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(772,27))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1024,8))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1069,11))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1215,15))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1301,14))
            attributedString.addAttribute(NSUnderlineColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(0,8))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadow, range:NSMakeRange(0,18))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowOne, range:NSMakeRange(111,15))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowTwo, range:NSMakeRange(228,17))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowThree, range:NSMakeRange(462,20))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowFour, range:NSMakeRange(638,3))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowFive, range:NSMakeRange(641,12))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowSix, range:NSMakeRange(769,30))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowSeven, range:NSMakeRange(1021,11))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowEight, range:NSMakeRange(1066,14))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowNine, range:NSMakeRange(1212,18))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowTen, range:NSMakeRange(1297,18))

            self.planetFactsTextView.textStorage.setAttributedString(attributedString)

         
        } else if (self.selectedPlanet == "Mercury"){
            
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.Center
            
            let attributedStringParagraphStyleOne = NSMutableParagraphStyle()
            attributedStringParagraphStyleOne.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleOne.minimumLineHeight = 24.762
            attributedStringParagraphStyleOne.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleTwo = NSMutableParagraphStyle()
            attributedStringParagraphStyleTwo.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleTwo.lineSpacing = 1.0
            
            let attributedStringParagraphStyleThree = NSMutableParagraphStyle()
            attributedStringParagraphStyleThree.alignment = NSTextAlignment.Center
            attributedStringParagraphStyleThree.minimumLineHeight = 22.857
            
            let attributedStringShadow = NSShadow()
            attributedStringShadow.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadow.shadowBlurRadius = 0.0
            attributedStringShadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowOne = NSShadow()
            attributedStringShadowOne.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowOne.shadowBlurRadius = 0.0
            attributedStringShadowOne.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowTwo = NSShadow()
            attributedStringShadowTwo.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowTwo.shadowBlurRadius = 0.0
            attributedStringShadowTwo.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowThree = NSShadow()
            attributedStringShadowThree.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowThree.shadowBlurRadius = 0.0
            attributedStringShadowThree.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowFour = NSShadow()
            attributedStringShadowFour.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowFour.shadowBlurRadius = 0.0
            attributedStringShadowFour.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowFive = NSShadow()
            attributedStringShadowFive.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowFive.shadowBlurRadius = 0.0
            attributedStringShadowFive.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowSix = NSShadow()
            attributedStringShadowSix.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowSix.shadowBlurRadius = 0.0
            attributedStringShadowSix.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowSeven = NSShadow()
            attributedStringShadowSeven.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowSeven.shadowBlurRadius = 0.0
            attributedStringShadowSeven.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowEight = NSShadow()
            attributedStringShadowEight.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowEight.shadowBlurRadius = 0.0
            attributedStringShadowEight.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowNine = NSShadow()
            attributedStringShadowNine.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowNine.shadowBlurRadius = 0.0
            attributedStringShadowNine.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedString = NSMutableAttributedString(string: "Mercury\n1. Smallest\nMercury is the smallest planet in our solar system - only slightly larger than the Earth's moon. If the sun were as tall as a typical front door, Earth would be the size of a nickel and Mercury would be about as big as a green pea.\n2. Insider\nIt is the closest planet to the sun at a distance of about 58 million km (36 million miles) or 0.39 AU.\n3. Long Days, Short Years\nOne day on Mercury (the time it takes for Mercury to rotate or spin once with respect to the stars) takes 59 Earth days. One day-night cycle on Mercury takes 175.97 Earth days. Mercury makes a complete orbit around the sun (a year in Mercury time) in just 88 Earth days.\n4. Rough Surface\nMercury is a rocky planet, also known as a terrestrial planet. Mercury has a solid, cratered surface, much like the Earth's moon.\n\n5. Can't Breathe It\nMercury's thin atmosphere, or exosphere, is composed mostly of oxygen (O2), sodium (Na), hydrogen (H2), helium (He), and potassium (K). Atoms that are blasted off the surface by the solar wind and micrometeoroid impacts create Mercury's exosphere.\n\n6. Moonless\nMercury has no moons.\n\n7. Ringless\nThere are no rings around Mercury.\n\n8. Robotic Visitors\nOnly two missions have visited this rocky planet: Mariner 10 in 1974-5 and MESSENGER, which flew past Mercury three times before going into orbit around Mercury in 2011.\n\n9. Tough Place to Live\nNo evidence for life has been found on Mercury. Daytime Temperatures can reach 430 degrees Celsius (800 degrees Fahrenheit) and drop to -180 degrees Celsius (-290 degrees Fahrenheit) at night. It is unlikely life (as we know it) could survive on this planet.\n\n10. Big Sun\nStanding on Mercury's surface at its closest point to the sun, the sun would appear more than three times larger than it does on Earth.\n\nSource: Solar System Exploration. (n.d.). Retrieved August 27, 2016, from https://solarsystem.nasa.gov/planets/mercury/needtoknow")
            
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:30.0)!, range:NSMakeRange(0,8))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(8,11))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(20,231))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(252,10))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(263,104))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(367,25))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(393,270))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(664,16))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(680,132))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(812,19))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(831,250))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1081,11))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1092,24))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1116,11))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1127,37))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1164,19))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1183,172))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1355,22))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1377,261))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1638,11))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1649,138))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:10.0)!, range:NSMakeRange(1787,129))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyle, range:NSMakeRange(0,8))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleOne, range:NSMakeRange(8,656))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleTwo, range:NSMakeRange(664,1123))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleThree, range:NSMakeRange(1787,129))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:0.874, blue:0.1, alpha:1.0), range:NSMakeRange(0,8))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(8,11))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(20,231))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(252,10))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(263,104))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(367,25))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(393,270))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(664,16))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(680,132))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(812,19))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(831,250))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1081,11))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1092,24))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1116,11))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1127,37))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1164,19))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1183,172))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1355,22))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1377,261))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1638,11))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1649,137))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1787,129))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:9.0, range:NSMakeRange(0,7))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(11,8))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(255,7))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(370,22))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(667,13))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(815,16))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1084,8))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1119,8))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1167,16))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1358,19))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1642,7))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadow, range:NSMakeRange(0,19))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowOne, range:NSMakeRange(252,10))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowTwo, range:NSMakeRange(367,25))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowThree, range:NSMakeRange(664,16))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowFour, range:NSMakeRange(812,19))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowFive, range:NSMakeRange(1081,11))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowSix, range:NSMakeRange(1116,11))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowSeven, range:NSMakeRange(1164,19))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowEight, range:NSMakeRange(1355,22))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowNine, range:NSMakeRange(1638,11))
            
            self.planetFactsTextView.textStorage.setAttributedString(attributedString)
            
            
        } else if (self.selectedPlanet == "Venus"){
            
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.Center
            
            let attributedStringParagraphStyleOne = NSMutableParagraphStyle()
            attributedStringParagraphStyleOne.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleOne.minimumLineHeight = 24.762
            attributedStringParagraphStyleOne.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleTwo = NSMutableParagraphStyle()
            attributedStringParagraphStyleTwo.alignment = NSTextAlignment.Center
            attributedStringParagraphStyleTwo.minimumLineHeight = 22.85
            
            let attributedStringShadow = NSShadow()
            attributedStringShadow.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadow.shadowBlurRadius = 0.0
            attributedStringShadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowOne = NSShadow()
            attributedStringShadowOne.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowOne.shadowBlurRadius = 0.0
            attributedStringShadowOne.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowTwo = NSShadow()
            attributedStringShadowTwo.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowTwo.shadowBlurRadius = 0.0
            attributedStringShadowTwo.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowThree = NSShadow()
            attributedStringShadowThree.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowThree.shadowBlurRadius = 0.0
            attributedStringShadowThree.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowFour = NSShadow()
            attributedStringShadowFour.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowFour.shadowBlurRadius = 0.0
            attributedStringShadowFour.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowFive = NSShadow()
            attributedStringShadowFive.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowFive.shadowBlurRadius = 0.0
            attributedStringShadowFive.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowSix = NSShadow()
            attributedStringShadowSix.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowSix.shadowBlurRadius = 0.0
            attributedStringShadowSix.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowSeven = NSShadow()
            attributedStringShadowSeven.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowSeven.shadowBlurRadius = 0.0
            attributedStringShadowSeven.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowEight = NSShadow()
            attributedStringShadowEight.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowEight.shadowBlurRadius = 0.0
            attributedStringShadowEight.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowNine = NSShadow()
            attributedStringShadowNine.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowNine.shadowBlurRadius = 0.0
            attributedStringShadowNine.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedString = NSMutableAttributedString(string: "Venus\n\n1. Earth-Sized\nVenus is only a little smaller than Earth. If the sun were as tall as a typical front door, the Earth and Venus would each be about the size of a nickel.\n2. Second Rock\nVenus orbits our sun, a star. Venus is the second closest planet to the sun at a distance of about 108 million km (67 million miles) or 0.72 AU.\n3. A Day Longer Than a Year\nOne day on Venus (the time it takes for Venus to rotate or spin once with respect to the stars) lasts as long as 243 Earth days. One day-night cycle on Venus takes 117 Earth days because Venus rotates in the direction opposite of its orbital revolution around the Sun. Venus makes a complete orbit around the sun (a year in Venusian time) in 225 Earth days or slightly less than 2 Venusian day-night cycles.\n4. Rough Terrain\nVenus is a rocky planet, also known as a terrestrial planet. Venus' solid surface is a cratered and volcanic landscape.\n5. Always Cloudy\nVenus' thick and toxic atmosphere is made up mostly of carbon dioxide (CO2) and nitrogen (N2), with clouds of sulfuric acid (H2SO4) droplets.\n6. Moonless\nVenus has no moons.\n7. Ringless\nThere are no rings around Venus.\n8. Many Visitors\nMore than 40 spacecraft have explored Venus. The Magellan mission in the early 1990s mapped 98 percent of the planet's surface.\n9. No Place to Live\nNo evidence for life has been found on Venus. The planet's extreme high temperatures of almost 480 degrees Celsius (900 degrees Fahrenheit) make it seem an unlikely place for for life as we know it.\n10. Backspin\nVenus spins backwards (retrograde rotation) when compared to the other planets. This means that the sun rises in the west and sets in the east on Venus.\n\nSource: Solar System Exploration. (n.d.). Retrieved August 27, 2016, from https://solarsystem.nasa.gov/planets/venus/needtoknow\n")
            
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:30.0)!, range:NSMakeRange(0,7))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(7,14))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(21,155))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(176,14))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(190,146))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(336,27))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(363,409))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(772,16))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(788,121))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(909,16))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(925,143))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1068,11))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1079,21))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1100,11))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1111,34))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1145,16))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1161,129))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1290,19))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1309,200))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1509,12))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1521,155))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:10.0)!, range:NSMakeRange(1676,127))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyle, range:NSMakeRange(0,7))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleOne, range:NSMakeRange(7,1669))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleTwo, range:NSMakeRange(1676,128))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(0,7))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(7,14))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(22,153))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(176,14))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(191,144))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(336,27))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(364,407))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(772,16))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(789,119))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(909,16))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(926,141))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1068,11))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1080,19))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1100,11))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1112,32))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1145,16))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1162,127))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1290,19))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1310,198))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1509,12))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1522,154))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor.whiteColor(), range:NSMakeRange(1676,127))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:9.0, range:NSMakeRange(0,7))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(10,11))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(179,11))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(339,24))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(775,13))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(912,13))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1071,8))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1103,8))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1148,13))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1293,16))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1513,8))
            attributedString.addAttribute(NSUnderlineColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(0,7))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadow, range:NSMakeRange(0,21))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowOne, range:NSMakeRange(176,14))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowTwo, range:NSMakeRange(336,27))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowThree, range:NSMakeRange(772,16))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowFour, range:NSMakeRange(909,16))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowFive, range:NSMakeRange(1068,11))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowSix, range:NSMakeRange(1100,11))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowSeven, range:NSMakeRange(1145,16))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowEight, range:NSMakeRange(1290,19))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowNine, range:NSMakeRange(1509,12))
            
            self.planetFactsTextView.textStorage.setAttributedString(attributedString)
            
        } else if(self.selectedPlanet == "Earth"){
            
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.Center
            
            let attributedStringParagraphStyleOne = NSMutableParagraphStyle()
            attributedStringParagraphStyleOne.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleOne.minimumLineHeight = 24.762
            attributedStringParagraphStyleOne.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleTwo = NSMutableParagraphStyle()
            attributedStringParagraphStyleTwo.alignment = NSTextAlignment.Center
            attributedStringParagraphStyleTwo.minimumLineHeight = 22.85
            
            let attributedStringShadow = NSShadow()
            attributedStringShadow.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadow.shadowBlurRadius = 0.0
            attributedStringShadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowOne = NSShadow()
            attributedStringShadowOne.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowOne.shadowBlurRadius = 0.0
            attributedStringShadowOne.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowTwo = NSShadow()
            attributedStringShadowTwo.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowTwo.shadowBlurRadius = 0.0
            attributedStringShadowTwo.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowThree = NSShadow()
            attributedStringShadowThree.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowThree.shadowBlurRadius = 0.0
            attributedStringShadowThree.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowFour = NSShadow()
            attributedStringShadowFour.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowFour.shadowBlurRadius = 0.0
            attributedStringShadowFour.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowFive = NSShadow()
            attributedStringShadowFive.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowFive.shadowBlurRadius = 0.0
            attributedStringShadowFive.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowSix = NSShadow()
            attributedStringShadowSix.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowSix.shadowBlurRadius = 0.0
            attributedStringShadowSix.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowSeven = NSShadow()
            attributedStringShadowSeven.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowSeven.shadowBlurRadius = 0.0
            attributedStringShadowSeven.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowEight = NSShadow()
            attributedStringShadowEight.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowEight.shadowBlurRadius = 0.0
            attributedStringShadowEight.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowNine = NSShadow()
            attributedStringShadowNine.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowNine.shadowBlurRadius = 0.0
            attributedStringShadowNine.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedString = NSMutableAttributedString(string: "Earth\n\n1. Measuring Up\nIf the sun were as tall as a typical front door, Earth would be the size of a nickel.\n2. Third Rock\nEarth orbits our sun, a star. Earth is the third planet from the sun at a distance of about 93 million miles (150 million km). That's one Astronomical Unit (AU).\n3. As the World Turns\nA day on Earth is 24 hours (the time it takes the Earth to rotate or spin once). Earth makes a complete orbit around the sun (a year in Earth time) in about 365 days.\n4. We're On It\nEarth is a rocky planet, also known as a terrestrial planet, with a solid and dynamic surface of mountains, valleys, canyons, plains and much more. Earth is different from other terrestrial planets in our solar system because it has oceans. Most of our planet is covered in water.\n5. Breathe Easy\nEarth's atmosphere is 78 percent nitrogen (N2), 21 percent oxygen (O2) and 1 percent other ingredients - the perfect balance for Earthlings to breathe and live. Many planets in our solar system have atmospheres, but only Earth's is breathable.\n6. Our Cosmic Companion\nEarth has one moon. Another name for a moon is natural satellite.\n7. Ringless\nEarth has no rings.\n8. Orbital Science\nMany orbiting spacecraft study the Earth from above as a whole system.\n9. Home, Sweet Home\nEarth is the perfect place for life as we know it.\n10. Protective Shield\nOur atmosphere protects us from incoming meteoroids, most of which break up in our atmosphere before they can strike the surface as meteorites.\nSource: Solar System Exploration. (n.d.). Retrieved August 27, 2016, from https://solarsystem.nasa.gov/planets/earth/needtoknow")
            
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:30.0)!, range:NSMakeRange(0,7))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(7,15))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(22,87))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(109,13))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(122,163))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(285,21))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(306,168))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(474,14))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(488,282))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(770,15))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(785,245))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1030,23))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1053,67))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1120,11))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1131,21))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1152,18))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1170,72))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1242,19))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1261,52))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1313,21))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1334,144))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:10.0)!, range:NSMakeRange(1479,127))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyle, range:NSMakeRange(0,7))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleOne, range:NSMakeRange(7,1472))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleTwo, range:NSMakeRange(1479,127))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(0,7))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(7,15))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(23,85))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(109,13))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(123,161))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(285,21))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(307,166))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(474,14))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(489,280))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(770,15))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(786,243))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1030,23))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1054,65))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1120,11))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1132,19))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1152,18))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1171,70))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1242,19))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1262,50))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1313,21))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1335,143))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor.whiteColor(), range:NSMakeRange(1479,127))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:9.0, range:NSMakeRange(0,7))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(10,12))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(112,10))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(288,18))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(477,11))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(773,12))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1033,20))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1123,8))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1155,15))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1245,16))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1317,17))
            attributedString.addAttribute(NSUnderlineColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(0,7))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadow, range:NSMakeRange(0,22))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowOne, range:NSMakeRange(109,13))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowTwo, range:NSMakeRange(285,21))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowThree, range:NSMakeRange(474,14))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowFour, range:NSMakeRange(770,15))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowFive, range:NSMakeRange(1030,23))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowSix, range:NSMakeRange(1120,11))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowSeven, range:NSMakeRange(1152,18))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowEight, range:NSMakeRange(1242,19))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowNine, range:NSMakeRange(1313,21))
            
            self.planetFactsTextView.textStorage.setAttributedString(attributedString)
        
            
        } else if (self.selectedPlanet == "Mars"){
            
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.Center
            
            let attributedStringParagraphStyleOne = NSMutableParagraphStyle()
            attributedStringParagraphStyleOne.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleOne.minimumLineHeight = 24.762
            attributedStringParagraphStyleOne.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleTwo = NSMutableParagraphStyle()
            attributedStringParagraphStyleTwo.alignment = NSTextAlignment.Center
            attributedStringParagraphStyleTwo.minimumLineHeight = 22.85
            
            let attributedStringShadow = NSShadow()
            attributedStringShadow.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadow.shadowBlurRadius = 0.0
            attributedStringShadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowOne = NSShadow()
            attributedStringShadowOne.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowOne.shadowBlurRadius = 0.0
            attributedStringShadowOne.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowTwo = NSShadow()
            attributedStringShadowTwo.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowTwo.shadowBlurRadius = 0.0
            attributedStringShadowTwo.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowThree = NSShadow()
            attributedStringShadowThree.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowThree.shadowBlurRadius = 0.0
            attributedStringShadowThree.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowFour = NSShadow()
            attributedStringShadowFour.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowFour.shadowBlurRadius = 0.0
            attributedStringShadowFour.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowFive = NSShadow()
            attributedStringShadowFive.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowFive.shadowBlurRadius = 0.0
            attributedStringShadowFive.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowSix = NSShadow()
            attributedStringShadowSix.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowSix.shadowBlurRadius = 0.0
            attributedStringShadowSix.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowSeven = NSShadow()
            attributedStringShadowSeven.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowSeven.shadowBlurRadius = 0.0
            attributedStringShadowSeven.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowEight = NSShadow()
            attributedStringShadowEight.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowEight.shadowBlurRadius = 0.0
            attributedStringShadowEight.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowNine = NSShadow()
            attributedStringShadowNine.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowNine.shadowBlurRadius = 0.0
            attributedStringShadowNine.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedString = NSMutableAttributedString(string: "Mars\n1. Small Planet\nIf the sun were as tall as a typical front door, Earth would be the size of a nickel, and Mars would be about as big as an aspirin tablet.\n2. Fourth Rock\nMars orbits our sun, a star. Mars is the fourth planet from the sun at a distance of about 228 million km (142 million miles) or 1.52 AU.\n3. Longer Days\nOne day on Mars takes just a little over 24 hours (the time it takes for Mars to rotate or spin once). Mars makes a complete orbit around the sun (a year in Martian time) in 687 Earth days.\n4. Rugged Terrain\nMars is a rocky planet, also known as a terrestrial planet. Mars' solid surface has been altered by volcanoes, impacts, crustal movement and atmospheric effects such as dust storms.\n5. Bring a Spacesuit\nMars has a thin atmosphere made up mostly of carbon dioxide (CO2), nitrogen (N2) and argon (Ar).\n6. Double Moons\nMars has two moons named Phobos and Deimos.\n7. Ringless\nThere are no rings around Mars.\n8. Many Missions\nSeveral missions have visited this planet, from flybys and orbiters to rovers on the surface of the Red Planet. The first true Mars mission success was Mariner 4 in 1965.\n9. Tough Place for Life\nAt this time in the planet's history, Mars' surface cannot support life as we know it. Current missions exploring Mars on the surface and from orbit are determining Mars' past and future potential for life.\n10. Rusty Planet\nMars is known as the Red Planet because iron minerals in the Martian soil oxidize, or rust, causing the soil -- and the dusty atmosphere -- to look red.\n\n\nSource: Solar System Exploration. (n.d.). Retrieved August 27, 2016, from https://solarsystem.nasa.gov/planets/mars/needtoknow")
            
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:30.0)!, range:NSMakeRange(0,5))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(5,15))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(21,138))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(160,14))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(175,137))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(313,14))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(328,189))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(518,17))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(536,181))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(718,20))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(739,96))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(836,15))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(852,43))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(896,11))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(908,31))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(940,16))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(957,170))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1128,23))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1152,206))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1359,16))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1376,152))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:10.0)!, range:NSMakeRange(1529,128))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyle, range:NSMakeRange(0,5))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleOne, range:NSMakeRange(5,1524))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleTwo, range:NSMakeRange(1530,127))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(0,5))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(5,15))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(21,138))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(160,14))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(175,137))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(313,14))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(328,189))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(518,17))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(536,181))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(718,20))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(739,96))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(836,15))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(852,43))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(896,11))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(908,31))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(940,16))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(957,170))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1128,23))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1152,206))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1359,16))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1376,152))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor.whiteColor(), range:NSMakeRange(1529,128))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:9.0, range:NSMakeRange(0,5))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(8,12))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(163,11))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(316,11))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(521,14))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(721,17))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(839,12))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(899,8))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(943,13))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1131,20))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1363,12))
            attributedString.addAttribute(NSUnderlineColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(0,5))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadow, range:NSMakeRange(0,20))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowOne, range:NSMakeRange(160,14))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowTwo, range:NSMakeRange(313,14))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowThree, range:NSMakeRange(518,17))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowFour, range:NSMakeRange(718,20))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowFive, range:NSMakeRange(836,15))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowSix, range:NSMakeRange(896,11))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowSeven, range:NSMakeRange(940,16))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowEight, range:NSMakeRange(1128,23))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowNine, range:NSMakeRange(1359,16))
            
            self.planetFactsTextView.textStorage.setAttributedString(attributedString)
            
        } else if (self.selectedPlanet == "Jupiter"){
            
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.Center
            
            let attributedStringParagraphStyleOne = NSMutableParagraphStyle()
            attributedStringParagraphStyleOne.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleOne.minimumLineHeight = 24.762
            attributedStringParagraphStyleOne.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleTwo = NSMutableParagraphStyle()
            attributedStringParagraphStyleTwo.alignment = NSTextAlignment.Center
            attributedStringParagraphStyleTwo.minimumLineHeight = 22.85
            
            let attributedStringShadow = NSShadow()
            attributedStringShadow.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadow.shadowBlurRadius = 0.0
            attributedStringShadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowOne = NSShadow()
            attributedStringShadowOne.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowOne.shadowBlurRadius = 0.0
            attributedStringShadowOne.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowTwo = NSShadow()
            attributedStringShadowTwo.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowTwo.shadowBlurRadius = 0.0
            attributedStringShadowTwo.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowThree = NSShadow()
            attributedStringShadowThree.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowThree.shadowBlurRadius = 0.0
            attributedStringShadowThree.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowFour = NSShadow()
            attributedStringShadowFour.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowFour.shadowBlurRadius = 0.0
            attributedStringShadowFour.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowFive = NSShadow()
            attributedStringShadowFive.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowFive.shadowBlurRadius = 0.0
            attributedStringShadowFive.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowSix = NSShadow()
            attributedStringShadowSix.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowSix.shadowBlurRadius = 0.0
            attributedStringShadowSix.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowSeven = NSShadow()
            attributedStringShadowSeven.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowSeven.shadowBlurRadius = 0.0
            attributedStringShadowSeven.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowEight = NSShadow()
            attributedStringShadowEight.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowEight.shadowBlurRadius = 0.0
            attributedStringShadowEight.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowNine = NSShadow()
            attributedStringShadowNine.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowNine.shadowBlurRadius = 0.0
            attributedStringShadowNine.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedString = NSMutableAttributedString(string: "Jupiter\n\n1. The Biggest Planet\nWith a radius of 43,440.7 miles (69,911 kilometers), Jupiter is 11 times wider than Earth. If Earth were the size of a nickel, Jupiter would be about as big as a basketball.\n2. Fifth in Line\nJupiter orbits our sun, a star. Jupiter is the fifth planet from the sun at a distance of about 484 million miles (778 million km) or 5.2 Astronomical Units (AU). Earth is one AU from the sun.\n3. Short Day / Long Year\nOne day on Jupiter takes about 10 hours (the time it takes for Jupiter to rotate or spin once). Jupiter makes a complete orbit around the sun (a year in Jovian time) in about 12 Earth years (4,333 Earth days).\n4. What's Inside?\nJupiter is a gas-giant planet and therefore does not have a solid surface. Jupiter may have a solid, inner core about the size of Earth.\n5. Atmosphere\nJupiter's atmosphere is made up mostly of hydrogen (H2) and helium (He).\n6. Many Moons\nJupiter has 53 known moons, with an additional 14 moons awaiting confirmation of their discovery -- that is a total of 67 moons.\n7. Ringed World\nJupiter has a faint ring system that was discovered in 1979 by the Voyager 1 mission. All four giant planets in our solar system have ring systems.\n8. Exploring Jupiter\nMany missions have visited Jupiter and its system of moons. The Juno spacecraft is currently orbiting Jupiter.\n9. Ingredients for Life?\nJupiter cannot support life as we know it. However, some of Jupiter's moons have oceans underneath their crusts that might support life.\n10. Did You Know?\nJupiter's Great Red Spot is a gigantic storm (about the size of Earth) that has been raging for hundreds of years.\n\nSource: Solar System Exploration. (n.d.). Retrieved August 27, 2016, from https://solarsystem.nasa.gov/planets/jupiter/needtoknow\n")
            
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:30.0)!, range:NSMakeRange(0,9))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(9,21))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(30,175))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(205,16))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(221,194))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(415,24))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(439,211))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(650,17))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(667,138))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(805,13))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(818,74))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(892,13))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(905,130))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1035,15))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1050,149))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1199,20))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1219,112))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1331,24))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1355,138))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1493,17))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1510,116))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:10.0)!, range:NSMakeRange(1627,129))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyle, range:NSMakeRange(0,9))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleOne, range:NSMakeRange(9,1617))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleTwo, range:NSMakeRange(1627,130))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(0,9))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(9,21))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(31,173))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(205,16))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(222,192))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(415,24))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(440,209))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(650,17))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(668,136))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(805,13))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(819,72))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(892,13))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(906,128))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1035,15))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1051,147))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1199,20))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1220,110))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1331,24))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1356,136))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1493,17))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1511,114))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor.whiteColor(), range:NSMakeRange(1627,129))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:9.0, range:NSMakeRange(0,9))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(12,18))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(208,13))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(418,21))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(653,14))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(808,10))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(895,10))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1038,12))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1202,17))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1334,21))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1497,13))
            attributedString.addAttribute(NSUnderlineColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(0,9))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadow, range:NSMakeRange(0,30))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowOne, range:NSMakeRange(205,16))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowTwo, range:NSMakeRange(415,24))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowThree, range:NSMakeRange(650,17))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowFour, range:NSMakeRange(805,13))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowFive, range:NSMakeRange(892,13))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowSix, range:NSMakeRange(1035,15))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowSeven, range:NSMakeRange(1199,20))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowEight, range:NSMakeRange(1331,24))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowNine, range:NSMakeRange(1493,17))
            
            self.planetFactsTextView.textStorage.setAttributedString(attributedString)
            
        } else if (self.selectedPlanet == "Saturn"){
            
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.Center
            
            let attributedStringParagraphStyleOne = NSMutableParagraphStyle()
            attributedStringParagraphStyleOne.alignment = NSTextAlignment.Left
            
            let attributedStringParagraphStyleTwo = NSMutableParagraphStyle()
            attributedStringParagraphStyleTwo.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleTwo.minimumLineHeight = 24.762
            attributedStringParagraphStyleTwo.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleThree = NSMutableParagraphStyle()
            attributedStringParagraphStyleThree.alignment = NSTextAlignment.Left
            
            let attributedStringParagraphStyleFour = NSMutableParagraphStyle()
            attributedStringParagraphStyleFour.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleFour.minimumLineHeight = 24.762
            attributedStringParagraphStyleFour.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleFive = NSMutableParagraphStyle()
            attributedStringParagraphStyleFive.alignment = NSTextAlignment.Left
            
            let attributedStringParagraphStyleSix = NSMutableParagraphStyle()
            attributedStringParagraphStyleSix.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleSix.minimumLineHeight = 24.762
            attributedStringParagraphStyleSix.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleSeven = NSMutableParagraphStyle()
            attributedStringParagraphStyleSeven.alignment = NSTextAlignment.Left
            
            let attributedStringParagraphStyleEight = NSMutableParagraphStyle()
            attributedStringParagraphStyleEight.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleEight.minimumLineHeight = 24.762
            attributedStringParagraphStyleEight.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleNine = NSMutableParagraphStyle()
            attributedStringParagraphStyleNine.alignment = NSTextAlignment.Left
            
            let attributedStringParagraphStyleTen = NSMutableParagraphStyle()
            attributedStringParagraphStyleTen.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleTen.minimumLineHeight = 24.762
            attributedStringParagraphStyleTen.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleEleven = NSMutableParagraphStyle()
            attributedStringParagraphStyleEleven.alignment = NSTextAlignment.Left
            
            let attributedStringParagraphStyleTwelve = NSMutableParagraphStyle()
            attributedStringParagraphStyleTwelve.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleTwelve.minimumLineHeight = 24.762
            attributedStringParagraphStyleTwelve.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleThirteen = NSMutableParagraphStyle()
            attributedStringParagraphStyleThirteen.alignment = NSTextAlignment.Left
            
            let attributedStringParagraphStyleFourteen = NSMutableParagraphStyle()
            attributedStringParagraphStyleFourteen.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleFourteen.minimumLineHeight = 24.762
            attributedStringParagraphStyleFourteen.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleFifteen = NSMutableParagraphStyle()
            attributedStringParagraphStyleFifteen.alignment = NSTextAlignment.Left
            
            let attributedStringParagraphStyleSixteen = NSMutableParagraphStyle()
            attributedStringParagraphStyleSixteen.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleSixteen.minimumLineHeight = 24.762
            attributedStringParagraphStyleSixteen.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleSeventeen = NSMutableParagraphStyle()
            attributedStringParagraphStyleSeventeen.alignment = NSTextAlignment.Left
            
            let attributedStringParagraphStyleEighteen = NSMutableParagraphStyle()
            attributedStringParagraphStyleEighteen.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleEighteen.minimumLineHeight = 24.762
            attributedStringParagraphStyleEighteen.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleNineteen = NSMutableParagraphStyle()
            attributedStringParagraphStyleNineteen.alignment = NSTextAlignment.Left
            
            let attributedStringParagraphStyleTwenty = NSMutableParagraphStyle()
            attributedStringParagraphStyleTwenty.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleTwenty.minimumLineHeight = 24.762
            attributedStringParagraphStyleTwenty.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleTwentyOne = NSMutableParagraphStyle()
            attributedStringParagraphStyleTwentyOne.alignment = NSTextAlignment.Center
            attributedStringParagraphStyleTwentyOne.minimumLineHeight = 22.85
            
            let attributedStringShadow = NSShadow()
            attributedStringShadow.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadow.shadowBlurRadius = 0.0
            attributedStringShadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowOne = NSShadow()
            attributedStringShadowOne.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowOne.shadowBlurRadius = 0.0
            attributedStringShadowOne.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowTwo = NSShadow()
            attributedStringShadowTwo.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowTwo.shadowBlurRadius = 0.0
            attributedStringShadowTwo.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowThree = NSShadow()
            attributedStringShadowThree.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowThree.shadowBlurRadius = 0.0
            attributedStringShadowThree.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowFour = NSShadow()
            attributedStringShadowFour.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowFour.shadowBlurRadius = 0.0
            attributedStringShadowFour.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowFive = NSShadow()
            attributedStringShadowFive.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowFive.shadowBlurRadius = 0.0
            attributedStringShadowFive.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowSix = NSShadow()
            attributedStringShadowSix.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowSix.shadowBlurRadius = 0.0
            attributedStringShadowSix.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowSeven = NSShadow()
            attributedStringShadowSeven.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowSeven.shadowBlurRadius = 0.0
            attributedStringShadowSeven.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowEight = NSShadow()
            attributedStringShadowEight.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowEight.shadowBlurRadius = 0.0
            attributedStringShadowEight.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowNine = NSShadow()
            attributedStringShadowNine.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowNine.shadowBlurRadius = 0.0
            attributedStringShadowNine.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedString = NSMutableAttributedString(string: "Saturn\n\n1. Size\nIf the sun were as tall as a typical front door, the Earth would be the size of a nickel and Saturn would be about as big as a basketball.\n2. Distance\nSaturn orbits our sun, a star. Saturn is the sixth planet from the sun at a distance of about 1.4 billion km (886 million miles) or 9.5 AU.\n3. Short Days, Long Years\nOne day on Saturn takes 10.7 hours (the time it takes for Saturn to rotate or spin once). Saturn makes a complete orbit around the sun (a year in Saturnian time) in 29 Earth years (10,756 Earth days).\n4. Not Solid\nSaturn is a gas-giant planet and therefore does not have a solid surface.\n5. Simple Elements\nSaturn's atmosphere is made up mostly of hydrogen (H2) and helium (He).\n6. Lots of Moons\nSaturn has 53 known moons with an additional nine moons awaiting confirmation of their discovery -- that is a total of 62 moons.\n7. Beautiful Rings\nSaturn has the most spectacular ring system, which is made up of seven rings with several gaps and divisions between them.\n8. A Lot to Learn\nOnly a few missions have visited Saturn: Pioneer 11, Voyager 1 and 2 and Cassini-Huygens. Since 2004, Cassini has been exploring Saturn, its moons and rings.\n9. Not Suitable for Life\nSaturn cannot support life as we know it. However, some of Saturn's moons have conditions that might support life.\n10. An Unknown Companion\nFact: When Galileo Galilei was observing the planet Saturn in the 1600s, he noticed strange objects on each side of the planet and drew in his notes a triple-bodied planet system and then later a planet with arms or handles. These \"handles\" were in fact the rings of Saturn.\n\nSource: Solar System Exploration. (n.d.). Retrieved August 27, 2016, from https://solarsystem.nasa.gov/planets/saturn/needtoknow\n")
            
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:30.0)!, range:NSMakeRange(0,8))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(8,7))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(16,139))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(155,11))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(166,141))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(307,25))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(332,202))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(534,12))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(546,75))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(621,18))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(639,73))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(712,16))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(728,130))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(858,18))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(876,124))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1000,17))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1017,159))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1176,24))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1200,116))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1316,24))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1340,275))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:10.0)!, range:NSMakeRange(1617,128))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyle, range:NSMakeRange(0,8))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleOne, range:NSMakeRange(8,8))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleTwo, range:NSMakeRange(16,139))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleThree, range:NSMakeRange(155,12))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleFour, range:NSMakeRange(167,140))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleFive, range:NSMakeRange(307,26))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleSix, range:NSMakeRange(333,201))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleSeven, range:NSMakeRange(534,13))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleEight, range:NSMakeRange(547,74))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleNine, range:NSMakeRange(621,19))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleTen, range:NSMakeRange(640,72))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleEleven, range:NSMakeRange(712,17))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleTwelve, range:NSMakeRange(729,129))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleThirteen, range:NSMakeRange(858,19))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleFourteen, range:NSMakeRange(877,123))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleFifteen, range:NSMakeRange(1000,18))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleSixteen, range:NSMakeRange(1018,158))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleSeventeen, range:NSMakeRange(1176,25))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleEighteen, range:NSMakeRange(1201,115))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleNineteen, range:NSMakeRange(1316,25))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleTwenty, range:NSMakeRange(1341,276))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleTwentyOne, range:NSMakeRange(1617,129))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(0,16))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(16,138))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(155,11))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(167,139))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(307,25))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(333,200))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(534,12))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(547,73))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(621,18))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(640,71))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(712,16))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(729,128))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(858,18))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(877,122))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(1000,17))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1018,157))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(1176,24))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1201,115))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(1316,24))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1341,274))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor.whiteColor(), range:NSMakeRange(1617,128))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:9.0, range:NSMakeRange(0,8))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(11,4))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(158,8))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(310,22))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(537,9))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(624,15))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(715,13))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(861,15))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1003,14))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1179,21))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1320,20))
            attributedString.addAttribute(NSUnderlineColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(0,8))
            attributedString.addAttribute(NSUnderlineColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(11,5))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadow, range:NSMakeRange(0,16))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowOne, range:NSMakeRange(155,11))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowTwo, range:NSMakeRange(307,25))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowThree, range:NSMakeRange(534,12))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowFour, range:NSMakeRange(621,18))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowFive, range:NSMakeRange(712,16))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowSix, range:NSMakeRange(858,18))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowSeven, range:NSMakeRange(1000,17))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowEight, range:NSMakeRange(1176,24))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowNine, range:NSMakeRange(1316,24))
            
            
            
            
            self.planetFactsTextView.textStorage.setAttributedString(attributedString)
            
        } else if (self.selectedPlanet == "Uranus"){
            
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.Center
            
            let attributedStringParagraphStyleOne = NSMutableParagraphStyle()
            attributedStringParagraphStyleOne.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleOne.minimumLineHeight = 24.75
            attributedStringParagraphStyleOne.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleTwo = NSMutableParagraphStyle()
            attributedStringParagraphStyleTwo.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleTwo.minimumLineHeight = 24.762
            attributedStringParagraphStyleTwo.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleThree = NSMutableParagraphStyle()
            attributedStringParagraphStyleThree.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleThree.minimumLineHeight = 24.75
            attributedStringParagraphStyleThree.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleFour = NSMutableParagraphStyle()
            attributedStringParagraphStyleFour.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleFour.minimumLineHeight = 24.762
            attributedStringParagraphStyleFour.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleFive = NSMutableParagraphStyle()
            attributedStringParagraphStyleFive.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleFive.minimumLineHeight = 24.75
            attributedStringParagraphStyleFive.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleSix = NSMutableParagraphStyle()
            attributedStringParagraphStyleSix.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleSix.minimumLineHeight = 24.762
            attributedStringParagraphStyleSix.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleSeven = NSMutableParagraphStyle()
            attributedStringParagraphStyleSeven.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleSeven.minimumLineHeight = 24.75
            attributedStringParagraphStyleSeven.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleEight = NSMutableParagraphStyle()
            attributedStringParagraphStyleEight.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleEight.minimumLineHeight = 24.762
            attributedStringParagraphStyleEight.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleNine = NSMutableParagraphStyle()
            attributedStringParagraphStyleNine.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleNine.minimumLineHeight = 24.75
            attributedStringParagraphStyleNine.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleTen = NSMutableParagraphStyle()
            attributedStringParagraphStyleTen.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleTen.minimumLineHeight = 24.762
            attributedStringParagraphStyleTen.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleEleven = NSMutableParagraphStyle()
            attributedStringParagraphStyleEleven.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleEleven.minimumLineHeight = 24.75
            attributedStringParagraphStyleEleven.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleTwelve = NSMutableParagraphStyle()
            attributedStringParagraphStyleTwelve.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleTwelve.minimumLineHeight = 24.762
            attributedStringParagraphStyleTwelve.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleThirteen = NSMutableParagraphStyle()
            attributedStringParagraphStyleThirteen.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleThirteen.minimumLineHeight = 24.75
            attributedStringParagraphStyleThirteen.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleFourteen = NSMutableParagraphStyle()
            attributedStringParagraphStyleFourteen.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleFourteen.minimumLineHeight = 24.762
            attributedStringParagraphStyleFourteen.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleFifteen = NSMutableParagraphStyle()
            attributedStringParagraphStyleFifteen.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleFifteen.minimumLineHeight = 24.75
            attributedStringParagraphStyleFifteen.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleSixteen = NSMutableParagraphStyle()
            attributedStringParagraphStyleSixteen.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleSixteen.minimumLineHeight = 24.762
            attributedStringParagraphStyleSixteen.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleSeventeen = NSMutableParagraphStyle()
            attributedStringParagraphStyleSeventeen.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleSeventeen.minimumLineHeight = 24.75
            attributedStringParagraphStyleSeventeen.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleEighteen = NSMutableParagraphStyle()
            attributedStringParagraphStyleEighteen.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleEighteen.minimumLineHeight = 24.762
            attributedStringParagraphStyleEighteen.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleNineteen = NSMutableParagraphStyle()
            attributedStringParagraphStyleNineteen.alignment = NSTextAlignment.Center
            attributedStringParagraphStyleNineteen.minimumLineHeight = 22.85
            
            let attributedStringShadow = NSShadow()
            attributedStringShadow.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadow.shadowBlurRadius = 0.0
            attributedStringShadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowOne = NSShadow()
            attributedStringShadowOne.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowOne.shadowBlurRadius = 0.0
            attributedStringShadowOne.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowTwo = NSShadow()
            attributedStringShadowTwo.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowTwo.shadowBlurRadius = 0.0
            attributedStringShadowTwo.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowThree = NSShadow()
            attributedStringShadowThree.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowThree.shadowBlurRadius = 0.0
            attributedStringShadowThree.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowFour = NSShadow()
            attributedStringShadowFour.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowFour.shadowBlurRadius = 0.0
            attributedStringShadowFour.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowFive = NSShadow()
            attributedStringShadowFive.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowFive.shadowBlurRadius = 0.0
            attributedStringShadowFive.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowSix = NSShadow()
            attributedStringShadowSix.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowSix.shadowBlurRadius = 0.0
            attributedStringShadowSix.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowSeven = NSShadow()
            attributedStringShadowSeven.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowSeven.shadowBlurRadius = 0.0
            attributedStringShadowSeven.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowEight = NSShadow()
            attributedStringShadowEight.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowEight.shadowBlurRadius = 0.0
            attributedStringShadowEight.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowNine = NSShadow()
            attributedStringShadowNine.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowNine.shadowBlurRadius = 0.0
            attributedStringShadowNine.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedString = NSMutableAttributedString(string: "Uranus\n\n1. Size\nIf the sun were as tall as a typical front door, Earth would be the size of a nickel and Uranus would be about as big as a baseball.\n2. Orbit\nUranus orbits our sun, a star. Uranus is the seventh planet from the sun at a distance of about 2.9 billion km (1.8 billion miles) or 19.19 AU.\n3. Day and Year Length\nOne day on Uranus takes about 17 hours (the time it takes for Uranus to rotate or spin once. Uranus makes a complete orbit around the sun (a year in Uranian time) in about 84 Earth years (30,687 Earth days).\n4. Ice Giant\nUranus is an ice giant. Most (80 percent or more) of the planet's mass is made up of a hot dense fluid of \"icy\" materials – water (H2O), methane (CH4). and ammonia (NH3) – above a small rocky core.\n5. Dangerous Atmosphere\nUranus has an atmosphere which is mostly made up of hydrogen (H2) and helium (He), with a small amount of methane (CH4).\n6. Many Moons\nUranus has 27 moons. Uranus' moons are named after characters from the works of William Shakespeare and Alexander Pope.\n7. A Ringed Planet\nUranus has 13 known rings. The inner rings are narrow and dark and the outer rings are brightly colored.\n8. Lonely \nVoyager 2 is the only spacecraft to have visited Uranus.\n9. Hostile Environment\nUranus cannot support life as we know it.\n10. Rolling Planet\nFact: Like Venus, Uranus has a retrograde rotation (east to west). Unlike any of the other planets, Uranus rotates on its side, which means it spins horizontally.\n\nSource: Solar System Exploration. (n.d.). Retrieved August 27, 2016, from https://solarsystem.nasa.gov/planets/uranus/needtoknow\n\n\n\n")
            
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:30.0)!, range:NSMakeRange(0,8))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(8,7))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(16,132))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(149,8))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(158,143))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(302,22))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(325,207))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(533,12))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(546,197))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(744,23))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(768,63))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:13.0)!, range:NSMakeRange(831,1))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(832,53))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:13.0)!, range:NSMakeRange(885,1))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(886,2))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(889,13))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(903,119))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1023,18))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1042,104))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1147,10))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1158,56))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1215,22))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1238,41))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1280,18))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1299,162))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:10.0)!, range:NSMakeRange(1463,128))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyle, range:NSMakeRange(0,7))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleOne, range:NSMakeRange(7,151))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleTwo, range:NSMakeRange(158,144))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleThree, range:NSMakeRange(302,23))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleFour, range:NSMakeRange(325,208))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleFive, range:NSMakeRange(533,13))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleSix, range:NSMakeRange(546,198))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleSeven, range:NSMakeRange(744,24))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleEight, range:NSMakeRange(768,121))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleNine, range:NSMakeRange(889,14))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleTen, range:NSMakeRange(903,120))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleEleven, range:NSMakeRange(1023,19))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleTwelve, range:NSMakeRange(1042,105))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleThirteen, range:NSMakeRange(1147,11))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleFourteen, range:NSMakeRange(1158,57))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleFifteen, range:NSMakeRange(1215,23))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleSixteen, range:NSMakeRange(1238,42))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleSeventeen, range:NSMakeRange(1280,19))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleEighteen, range:NSMakeRange(1299,164))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleNineteen, range:NSMakeRange(1463,129))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(0,7))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(8,7))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(16,132))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(149,8))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(158,143))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(302,22))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(325,207))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(533,12))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(546,197))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(744,23))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(768,120))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(889,13))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(903,119))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1023,18))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1042,104))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1147,10))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1158,56))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1215,22))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1238,41))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1280,18))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1299,162))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1463,129))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:9.0, range:NSMakeRange(0,8))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(11,4))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(152,5))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(305,19))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(536,9))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(747,20))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(892,10))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1026,15))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1150,7))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1218,19))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1284,14))
            attributedString.addAttribute(NSUnderlineColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(0,8))
            attributedString.addAttribute(NSUnderlineColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(11,4))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadow, range:NSMakeRange(0,15))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowOne, range:NSMakeRange(149,8))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowTwo, range:NSMakeRange(302,22))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowThree, range:NSMakeRange(533,12))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowFour, range:NSMakeRange(744,23))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowFive, range:NSMakeRange(889,13))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowSix, range:NSMakeRange(1023,18))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowSeven, range:NSMakeRange(1147,10))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowEight, range:NSMakeRange(1215,22))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowNine, range:NSMakeRange(1280,18))
            
            
            
            
            self.planetFactsTextView.textStorage.setAttributedString(attributedString)
            
        } else if (self.selectedPlanet == "Neptune"){
            
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.Center
            
            let attributedStringParagraphStyleOne = NSMutableParagraphStyle()
            attributedStringParagraphStyleOne.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleOne.minimumLineHeight = 24.75
            attributedStringParagraphStyleOne.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleTwo = NSMutableParagraphStyle()
            attributedStringParagraphStyleTwo.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleTwo.minimumLineHeight = 24.762
            attributedStringParagraphStyleTwo.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleThree = NSMutableParagraphStyle()
            attributedStringParagraphStyleThree.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleThree.minimumLineHeight = 24.75
            attributedStringParagraphStyleThree.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleFour = NSMutableParagraphStyle()
            attributedStringParagraphStyleFour.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleFour.minimumLineHeight = 24.762
            attributedStringParagraphStyleFour.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleFive = NSMutableParagraphStyle()
            attributedStringParagraphStyleFive.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleFive.minimumLineHeight = 24.75
            attributedStringParagraphStyleFive.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleSix = NSMutableParagraphStyle()
            attributedStringParagraphStyleSix.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleSix.minimumLineHeight = 24.762
            attributedStringParagraphStyleSix.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleSeven = NSMutableParagraphStyle()
            attributedStringParagraphStyleSeven.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleSeven.minimumLineHeight = 24.75
            attributedStringParagraphStyleSeven.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleEight = NSMutableParagraphStyle()
            attributedStringParagraphStyleEight.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleEight.minimumLineHeight = 24.762
            attributedStringParagraphStyleEight.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleNine = NSMutableParagraphStyle()
            attributedStringParagraphStyleNine.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleNine.minimumLineHeight = 24.75
            attributedStringParagraphStyleNine.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleTen = NSMutableParagraphStyle()
            attributedStringParagraphStyleTen.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleTen.minimumLineHeight = 24.762
            attributedStringParagraphStyleTen.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleEleven = NSMutableParagraphStyle()
            attributedStringParagraphStyleEleven.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleEleven.minimumLineHeight = 24.75
            attributedStringParagraphStyleEleven.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleTwelve = NSMutableParagraphStyle()
            attributedStringParagraphStyleTwelve.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleTwelve.minimumLineHeight = 24.762
            attributedStringParagraphStyleTwelve.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleThirteen = NSMutableParagraphStyle()
            attributedStringParagraphStyleThirteen.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleThirteen.minimumLineHeight = 24.75
            attributedStringParagraphStyleThirteen.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleFourteen = NSMutableParagraphStyle()
            attributedStringParagraphStyleFourteen.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleFourteen.minimumLineHeight = 24.762
            attributedStringParagraphStyleFourteen.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleFifteen = NSMutableParagraphStyle()
            attributedStringParagraphStyleFifteen.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleFifteen.minimumLineHeight = 24.75
            attributedStringParagraphStyleFifteen.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleSixteen = NSMutableParagraphStyle()
            attributedStringParagraphStyleSixteen.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleSixteen.minimumLineHeight = 24.762
            attributedStringParagraphStyleSixteen.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleSeventeen = NSMutableParagraphStyle()
            attributedStringParagraphStyleSeventeen.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleSeventeen.minimumLineHeight = 24.75
            attributedStringParagraphStyleSeventeen.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleEighteen = NSMutableParagraphStyle()
            attributedStringParagraphStyleEighteen.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleEighteen.minimumLineHeight = 24.762
            attributedStringParagraphStyleEighteen.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleNineteen = NSMutableParagraphStyle()
            attributedStringParagraphStyleNineteen.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleNineteen.minimumLineHeight = 24.75
            attributedStringParagraphStyleNineteen.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleTwenty = NSMutableParagraphStyle()
            attributedStringParagraphStyleTwenty.alignment = NSTextAlignment.Left
            attributedStringParagraphStyleTwenty.minimumLineHeight = 24.762
            attributedStringParagraphStyleTwenty.paragraphSpacing = 18.0
            
            let attributedStringParagraphStyleTwentyOne = NSMutableParagraphStyle()
            attributedStringParagraphStyleTwentyOne.alignment = NSTextAlignment.Center
            attributedStringParagraphStyleTwentyOne.minimumLineHeight = 22.85
            
            let attributedStringShadow = NSShadow()
            attributedStringShadow.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadow.shadowBlurRadius = 0.0
            attributedStringShadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowOne = NSShadow()
            attributedStringShadowOne.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowOne.shadowBlurRadius = 0.0
            attributedStringShadowOne.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowTwo = NSShadow()
            attributedStringShadowTwo.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowTwo.shadowBlurRadius = 0.0
            attributedStringShadowTwo.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowThree = NSShadow()
            attributedStringShadowThree.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowThree.shadowBlurRadius = 0.0
            attributedStringShadowThree.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowFour = NSShadow()
            attributedStringShadowFour.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowFour.shadowBlurRadius = 0.0
            attributedStringShadowFour.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowFive = NSShadow()
            attributedStringShadowFive.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowFive.shadowBlurRadius = 0.0
            attributedStringShadowFive.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowSix = NSShadow()
            attributedStringShadowSix.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowSix.shadowBlurRadius = 0.0
            attributedStringShadowSix.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowSeven = NSShadow()
            attributedStringShadowSeven.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowSeven.shadowBlurRadius = 0.0
            attributedStringShadowSeven.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowEight = NSShadow()
            attributedStringShadowEight.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowEight.shadowBlurRadius = 0.0
            attributedStringShadowEight.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowNine = NSShadow()
            attributedStringShadowNine.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowNine.shadowBlurRadius = 0.0
            attributedStringShadowNine.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedStringShadowTen = NSShadow()
            attributedStringShadowTen.shadowOffset = CGSizeMake(1.0, 1.0)
            attributedStringShadowTen.shadowBlurRadius = 0.0
            attributedStringShadowTen.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
            
            let attributedString = NSMutableAttributedString(string: "Neptune\n\n1. Size Comparison\nIf the sun were as tall as a typical front door, the Earth would be the size of a nickel and Neptune would be about as big as a baseball.\n2. A Long Way From Home\nNeptune orbits our sun, a star. Neptune is the eighth planet from the sun at a distance of about 4.5 billion km (2.8 billion miles) or 30.07 AU.\n3. Short Days, Very Long Years\nOne day on Neptune takes about 16 hours (the time it takes for Neptune to rotate or spin once). Neptune makes a complete orbit around the sun (a year in Neptunian time) in about 165 Earth years (60,190 Earth days).\n4. Twin Sister\nNeptune is a sister ice giant to Uranus. Neptune is mostly made of a very thick, very hot combination of water (H2O), ammonia (NH3), and methane (CH4) over a possible heavier, approximately Earth-sized, solid core.\n5. Composition\nNeptune's atmosphere is made up mostly of hydrogen (H2), helium (He) and methane (CH4).\n6. A Few Neighbors\nNeptune has 13 moons. Neptune's moons are named after various sea gods and nymphs in Greek mythology.\n7. Ringed World\nNeptune has six rings.\n8.  All Alone\nVoyager 2 is the only spacecraft to have visited Neptune.\n9. Not Hospitable\nNeptune cannot support life as we know it.\n10. Alternating Position\nFact: Sometimes, during the course of Neptune's orbit, dwarf planet Pluto is actually closer to the sun, and us, than Neptune. This is due to the unusual elliptical (egg) shape orbit of Pluto.\n\nSource: Solar System Exploration. (n.d.). Retrieved August 27, 2016, from https://solarsystem.nasa.gov/planets/neptune/needtoknow\n\n")
            
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:30.0)!, range:NSMakeRange(0,7))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(9,18))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(28,138))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(166,23))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(189,146))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(335,30))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(365,216))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(581,14))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(595,216))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(811,14))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(825,89))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(914,18))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(932,103))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1035,15))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1050,24))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1074,13))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1087,59))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1146,17))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1163,44))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)!, range:NSMakeRange(1207,24))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:17.0)!, range:NSMakeRange(1231,193))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:10.0)!, range:NSMakeRange(1426,129))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyle, range:NSMakeRange(0,8))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleOne, range:NSMakeRange(9,19))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleTwo, range:NSMakeRange(28,138))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleThree, range:NSMakeRange(166,24))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleFour, range:NSMakeRange(190,145))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleFive, range:NSMakeRange(335,31))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleSix, range:NSMakeRange(366,215))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleSeven, range:NSMakeRange(581,15))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleEight, range:NSMakeRange(596,215))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleNine, range:NSMakeRange(811,15))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleTen, range:NSMakeRange(826,88))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleEleven, range:NSMakeRange(914,19))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleTwelve, range:NSMakeRange(933,102))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleThirteen, range:NSMakeRange(1035,16))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleFourteen, range:NSMakeRange(1051,23))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleFifteen, range:NSMakeRange(1074,14))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleSixteen, range:NSMakeRange(1088,58))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleSeventeen, range:NSMakeRange(1146,18))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleEighteen, range:NSMakeRange(1164,43))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleNineteen, range:NSMakeRange(1207,25))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleTwenty, range:NSMakeRange(1232,194))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleTwentyOne, range:NSMakeRange(1426,130))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(0,7))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(9,18))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(28,137))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(166,23))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(190,144))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(335,30))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(366,214))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(581,14))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(596,214))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(811,14))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(826,87))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(914,18))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(933,101))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1035,15))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1051,22))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1074,13))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1088,57))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1146,17))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1164,42))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(1207,24))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1232,192))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(1426,130))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:9.0, range:NSMakeRange(0,7))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(12,15))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(169,20))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(338,27))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(584,11))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(814,11))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(917,15))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1038,12))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1078,9))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1149,14))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value:1.0, range:NSMakeRange(1211,20))
            attributedString.addAttribute(NSUnderlineColorAttributeName, value:UIColor(red:1.0, green:0.873, blue:0.102, alpha:1.0), range:NSMakeRange(0,7))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadow, range:NSMakeRange(0,7))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowOne, range:NSMakeRange(9,18))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowTwo, range:NSMakeRange(166,23))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowThree, range:NSMakeRange(335,30))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowFour, range:NSMakeRange(581,14))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowFive, range:NSMakeRange(811,14))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowSix, range:NSMakeRange(914,18))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowSeven, range:NSMakeRange(1035,15))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowEight, range:NSMakeRange(1074,13))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowNine, range:NSMakeRange(1146,17))
            attributedString.addAttribute(NSShadowAttributeName, value:attributedStringShadowTen, range:NSMakeRange(1207,24))
            
            self.planetFactsTextView.textStorage.setAttributedString(attributedString)
            
            }
    }
        
    }
    
    
    
    
    
    private func setupWeightScreen(){
        
        if(self.isWeightFact){
            
            weightSuperView = UIView(frame: CGRect(x: 50, y: 50, width: self.view.frame.size.width - 100, height: self.view.frame.size.height - 160))
            weightSuperView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
            
            selectedPlanetLabel = UILabel(frame: CGRect(x: (self.view.frame.size.width/2) - 175, y: 2, width: 250, height: 50))
            selectedPlanetLabel.font = UIFont(name:"AvenirNextCondensed-DemiBold", size:30.0)
            selectedPlanetLabel.text = "Select A Planet"
            selectedPlanetLabel.textColor = UIColor.whiteColor()
            selectedPlanetLabel.shadowColor = UIColor.blackColor()
            selectedPlanetLabel.shadowOffset = CGSize(width: 1.0, height: 1.0)
            selectedPlanetLabel.textAlignment = .Center

            
            let yourWeightLabel = UILabel(frame: CGRect(x: (self.view.frame.size.width/2) - 255, y: self.view.frame.size.height - 225, width: 200, height: 50))
            yourWeightLabel.font = UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)
            yourWeightLabel.text = "Enter Your Weight:"
            yourWeightLabel.textColor = UIColor(red: 253.0/255.0, green: 219.0/255.0, blue: 23.0/255.0, alpha: 1.0)
            yourWeightLabel.shadowColor = UIColor.blackColor()
            yourWeightLabel.shadowOffset = CGSize(width: 1.0, height: 1.0)
            yourWeightLabel.textAlignment = NSTextAlignment.Right
            
            gravitationalForceLabel = UILabel(frame: CGRect(x: (self.view.frame.size.width/2) - 225, y: 28, width: 350, height: 50))
            gravitationalForceLabel.font = UIFont(name:"AvenirNextCondensed-DemiBold", size:10.0)
            gravitationalForceLabel.textColor = UIColor(red: 253.0/255.0, green: 219.0/255.0, blue: 23.0/255.0, alpha: 1.0)
            gravitationalForceLabel.shadowColor = UIColor.blackColor()
            gravitationalForceLabel.shadowOffset = CGSize(width: 1.0, height: 1.0)
            gravitationalForceLabel.textAlignment = NSTextAlignment.Center
            gravitationalForceLabel.hidden = true
            
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.Center
            
            let attributedString = NSMutableAttributedString(string: "Force of Gravity Compared to Earth: 28.0x")
            
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:15.0)!, range:NSMakeRange(0,35))
            attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:15.0)!, range:NSMakeRange(36,5))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyle, range:NSMakeRange(0,40))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(0,35))
            attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(36,5))
            
            gravitationalForceLabel.attributedText = attributedString
            
            // fix the numberPad keyboard by adding a done button
            
            weightTextField = UITextField(frame: CGRect(x: (self.view.frame.size.width/2)-40, y: self.view.frame.size.height - 215, width: 125, height: 30))
            weightTextField.text = "100"
            weightTextField.textColor = UIColor.whiteColor()
            weightTextField.backgroundColor = UIColor.clearColor()
            weightTextField.borderStyle = UITextBorderStyle.Line
            weightTextField.layer.borderColor = UIColor.whiteColor().CGColor
            weightTextField.layer.borderWidth = 1.0
            weightTextField.layer.masksToBounds = true
            weightTextField.font = UIFont(name:"AvenirNextCondensed-DemiBold", size:20.0)
            weightTextField.textAlignment = NSTextAlignment.Center
            weightTextField.keyboardType = .NumberPad
            weightTextField.delegate = self
            weightTextField.addTarget(self, action: "changeWeightViews", forControlEvents: .EditingDidEndOnExit)
        
            
            weightResult = UILabel(frame: CGRect(x: (self.view.frame.size.width/2) - 250, y: (self.view.frame.size.height/2) - 175, width: 400, height: 200))
            weightResult.font = UIFont(name:"AvenirNextCondensed-DemiBold", size:70.0)
            weightResult.shadowColor = UIColor.blackColor()
            weightResult.textColor = UIColor(red: 253.0/255.0, green: 219.0/255.0, blue: 23.0/255.0, alpha: 1.0)
            weightResult.shadowOffset = CGSize(width: 1.0, height: 1.0)
            weightResult.text = ""
            weightResult.textAlignment = NSTextAlignment.Center
            weightResult.hidden = true
            
            
            youWouldWeighLabel = UILabel(frame: CGRect(x: (self.view.frame.size.width/2) - 250, y: (self.view.frame.size.height/2)-142.5, width: 400, height: 50))
            youWouldWeighLabel.font = UIFont(name:"AvenirNextCondensed-DemiBold", size:15.0)
            youWouldWeighLabel.shadowColor = UIColor.blackColor()
            youWouldWeighLabel.textColor = UIColor.whiteColor()
            youWouldWeighLabel.shadowOffset = CGSize(width: 1.0, height: 1.0)
            youWouldWeighLabel.text = "You Would Weigh:"
            youWouldWeighLabel.textAlignment = NSTextAlignment.Center
            youWouldWeighLabel.hidden = true
            
            
            
            
            self.view.addSubview(weightSuperView)
            weightSuperView.addSubview(selectedPlanetLabel)
            weightSuperView.addSubview(yourWeightLabel)
            weightSuperView.addSubview(gravitationalForceLabel)
            weightSuperView.addSubview(weightTextField)
            weightSuperView.addSubview(weightResult)
            weightSuperView.addSubview(youWouldWeighLabel)
            
            // Changes elements based on screen size
            
            if UIScreen.mainScreen().bounds.size.height == 375 {
                // iPhone 6 (not plus)
                youWouldWeighLabel.font = youWouldWeighLabel.font.fontWithSize(12)
                youWouldWeighLabel.frame = CGRect(x: (self.view.frame.size.width/2) - 250, y: (self.view.frame.size.height/2)-135, width: 400, height: 50)
                weightResult.font = weightResult.font.fontWithSize(45)
            } else if UIScreen.mainScreen().bounds.size.height == 320 {
                // IPhone 5 and 4
                youWouldWeighLabel.hidden = true
                weightResult.font = weightResult.font.fontWithSize(30)
            }
            
            
        }

    }
    
    private func changeWeightViews() {
        
        selectedPlanetLabel.text = self.selectedPlanet
        self.behindTextImage.image = UIImage(named:"\(String(self.selectedPlanet).lowercaseString)")
        
        if(selectedPlanetLabel.text! == "Sun"){
            selectedPlanetLabel.text = "The Sun"
        }
        
        
        let gravityForces = ["Sun": 28.0, "Mercury": 0.38, "Venus": 0.91, "Earth": 1.01, "Mars": 0.38, "Jupiter": 2.14, "Saturn": 0.91, "Uranus": 0.86, "Neptune": 1.11]
        
        let attributedStringParagraphStyle = NSMutableParagraphStyle()
        attributedStringParagraphStyle.alignment = NSTextAlignment.Center
        
        var attributedString = NSMutableAttributedString(string: "Force of Gravity Compared to Earth: \(gravityForces["\(self.selectedPlanet)"]!)x")
        
        if(attributedString.string == "Force of Gravity Compared to Earth: 1.01x"){
            attributedString = NSMutableAttributedString(string:"Force of Gravity Compared to Earth: 1.00x")
        } else if(attributedString.string == "Force of Gravity Compared to Earth: 1.11x"){
            attributedString = NSMutableAttributedString(string:"Force of Gravity Compared to Earth: 1.10x")
        }
        
        attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:15.0)!, range:NSMakeRange(0,35))
        attributedString.addAttribute(NSFontAttributeName, value:UIFont(name:"AvenirNextCondensed-DemiBold", size:15.0)!, range:NSMakeRange(36,5))
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyle, range:NSMakeRange(0,40))
        attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.996, green:0.876, blue:0.102, alpha:1.0), range:NSMakeRange(0,35))
        attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(36,5))
        

        
        
        gravitationalForceLabel.attributedText = attributedString
        
        
        
        if(!(self.selectedPlanet == "Earth" || self.selectedPlanet == "Neptune")){
            weightResult.text = "\(Double(weightTextField.text!)! * gravityForces["\(self.selectedPlanet)"]!) lbs."
        } else if(self.selectedPlanet == "Earth"){
            weightResult.text = "\(Double(weightTextField.text!)! * 1.0) lbs."
        } else if (self.selectedPlanet == "Neptune"){
            weightResult.text = "\(Double(weightTextField.text!)! * 1.1) lbs."
        }
        
        
        
        weightResult.hidden = false
        youWouldWeighLabel.hidden = false
        gravitationalForceLabel.hidden = false
        
        if UIScreen.mainScreen().bounds.size.height == 375 {
            // iPhone 6 (not plus)
            youWouldWeighLabel.font = youWouldWeighLabel.font.fontWithSize(12)
            youWouldWeighLabel.frame = CGRect(x: (self.view.frame.size.width/2) - 250, y: (self.view.frame.size.height/2)-135, width: 400, height: 50)
            weightResult.font = weightResult.font.fontWithSize(45)
        } else if UIScreen.mainScreen().bounds.size.height == 320 {
            // IPhone 5 and 4
            youWouldWeighLabel.hidden = true
            weightResult.font = weightResult.font.fontWithSize(30)
        }
        
        
        

    }
    
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        weightTextField.inputAccessoryView = keyboardToolbar
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.weightTextField.text = ""
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {

        if(self.weightTextField.text! == ""){
            self.weightTextField.text = "100"
        }
        
        changeWeightViews()

        animateTextField(false)
    
    }
    
    func animateTextField(textFieldUp:Bool) {
        let movementDistance:CGFloat = keyboardHeight
        let movementDuration = 0.3
        var movement:CGFloat = (textFieldUp ? -movementDistance : movementDistance)
//        if UIScreen.mainScreen().bounds.size.height == 320 {
//            movement = (textFieldUp ? -movementDistance - 100 : movementDistance + 100)
//        } else {
//            movement = (textFieldUp ? -movementDistance : movementDistance)
//        }
        
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        if UIScreen.mainScreen().bounds.size.height == 320 {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement + 100)
        } else{
            self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        }
        
        if UIScreen.mainScreen().bounds.size.height == 320 {
            if(!textFieldUp){
                self.view.frame = CGRectOffset(self.view.frame, 0, -movement)
            }
        }
        
        UIView.commitAnimations()
    }
    
    func keyboardWillChange(notification:NSNotification) {
        let keyboardRect:CGRect = ((notification.userInfo![UIKeyboardFrameEndUserInfoKey])?.CGRectValue)!
        keyboardHeight = keyboardRect.height
        animateTextField(true)
    }
    
    func textField(textField: UITextField,
                   shouldChangeCharactersInRange range: NSRange,
                                                 replacementString string: String) -> Bool {
        
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        let inverseSet = NSCharacterSet(charactersInString:"0123456789").invertedSet
        
        // At every character in this "inverseSet" contained in the string,
        // split the string up into components which exclude the characters
        // in this inverse set
        let components = string.componentsSeparatedByCharactersInSet(inverseSet)
        
        // Rejoin these components
        let filtered = components.joinWithSeparator("")  // use join("", components) if you are using Swift 1.2
        
        // If the original string is equal to the filtered string, i.e. if no
        // inverse characters were present to be eliminated, the input is valid
        // and the statement returns true; else it returns false
        return string == filtered
        
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
