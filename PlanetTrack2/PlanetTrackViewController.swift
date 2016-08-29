//
//  PlanetTrackViewController.swift
//  PlanetTrack-Swift
//
//  Created by Matt Milner on 8/13/16.
//  Copyright © 2016 Matt Milner. All rights reserved.
//



// Still Left to do: 
//  -- Functioning Unit Button
//  -- Upload Data and make different links depending on the time of year
//  -- Make sure the same planet can't be selected twice
//  -- Add commas to the distance string
//  -- Try to add the Sun to the Stackview without it messing up
//  -- Make the number update to reflect the amount of time passed instead of restarting every time its selected


import UIKit

class PlanetTrackViewController: UIViewController {
    
    @IBOutlet weak var planetsDisplayText: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var unitOfMeasurementLabel: UIButton!
    @IBOutlet weak var sunButton: UIButton!
    @IBOutlet weak var mercuryButton: UIButton!
    @IBOutlet weak var venusButton: UIButton!
    @IBOutlet weak var earthButton: UIButton!
    @IBOutlet weak var marsButton: UIButton!
    @IBOutlet weak var jupiterButton: UIButton!
    @IBOutlet weak var saturnButton: UIButton!
    @IBOutlet weak var uranusButton: UIButton!
    @IBOutlet weak var neptuneButton: UIButton!
    @IBOutlet weak var leftSelectedPlanet: UIButton!
    @IBOutlet weak var rightSelectedPlanet: UIButton!
    
    var leftPlanet:  String!
    var rightPlanet: String?
    var leftSelected = true
    var milesSelected = false

    
    var ratePerHalfSecond: Double!
    var secondsPassedSincePreviousDate: Double!
    var actualDistance: Double!
    
    var selectedPlanet: String!
    var selectedPlanetData: NSMutableArray!
    var selectedPlanetDictionary: NSDictionary!
    
    var sunDataArray: NSMutableArray!
    var mercuryDataArray: NSMutableArray!
    var venusDataArray: NSMutableArray!
    var earthDataArray: NSMutableArray!
    var marsDataArray: NSMutableArray!
    var jupiterDataArray: NSMutableArray!
    var saturnDataArray: NSMutableArray!
    var uranusDataArray: NSMutableArray!
    
    var sunToMercuryData: NSDictionary!
    var sunToVenusData: NSDictionary!
    var sunToEarthData: NSDictionary!
    var sunToMarsData: NSDictionary!
    var sunToJupiterData: NSDictionary!
    var sunToSaturnData: NSDictionary!
    var sunToUranusData: NSDictionary!
    var sunToNeptuneData: NSDictionary!
    
    var mercuryToVenusData: NSDictionary!
    var mercuryToEarthData: NSDictionary!
    var mercuryToMarsData: NSDictionary!
    var mercuryToJupiterData: NSDictionary!
    var mercuryToSaturnData: NSDictionary!
    var mercuryToUranusData: NSDictionary!
    var mercuryToNeptuneData: NSDictionary!
    
    var venusToEarthData: NSDictionary!
    var venusToMarsData: NSDictionary!
    var venusToJupiterData: NSDictionary!
    var venusToSaturnData: NSDictionary!
    var venusToUranusData: NSDictionary!
    var venusToNeptuneData: NSDictionary!
    
    var earthToMarsData: NSDictionary!
    var earthToJupiterData: NSDictionary!
    var earthToSaturnData: NSDictionary!
    var earthToUranusData: NSDictionary!
    var earthToNeptuneData: NSDictionary!
    
    var marsToJupiterData: NSDictionary!
    var marsToSaturnData: NSDictionary!
    var marsToUranusData: NSDictionary!
    var marsToNeptuneData: NSDictionary!
    
    var jupiterToSaturnData: NSDictionary!
    var jupiterToUranusData: NSDictionary!
    var jupiterToNeptuneData: NSDictionary!
    
    var saturnToUranusData: NSDictionary!
    var saturnToNeptuneData: NSDictionary!
    
    var uranusToNeptuneData: NSDictionary!
    
    var targetView: UIImageView!


    // Begin Code
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.title = "PlanetTrack"
        self.planetsDisplayText.text = "Sun to Mercury"
        
        
        downloadPlanetData()
        
        sunToMercuryData = NSDictionary(); sunToVenusData = NSDictionary(); sunToEarthData = NSDictionary(); sunToMarsData = NSDictionary(); sunToJupiterData = NSDictionary();
        sunToSaturnData = NSDictionary(); sunToUranusData = NSDictionary(); sunToNeptuneData = NSDictionary();
        
        mercuryToVenusData = NSDictionary(); mercuryToEarthData = NSDictionary(); mercuryToMarsData = NSDictionary(); mercuryToJupiterData = NSDictionary(); mercuryToSaturnData = NSDictionary();
        mercuryToUranusData = NSDictionary(); mercuryToNeptuneData = NSDictionary()
        
        venusToEarthData = NSDictionary(); venusToMarsData = NSDictionary(); venusToJupiterData = NSDictionary(); venusToSaturnData = NSDictionary(); venusToUranusData = NSDictionary();
        venusToNeptuneData = NSDictionary()
        
        earthToMarsData = NSDictionary(); earthToJupiterData = NSDictionary(); earthToSaturnData = NSDictionary(); earthToUranusData = NSDictionary(); earthToNeptuneData = NSDictionary();
        
        marsToJupiterData = NSDictionary(); marsToSaturnData = NSDictionary(); marsToUranusData = NSDictionary(); marsToNeptuneData = NSDictionary();
        
        jupiterToSaturnData = NSDictionary(); jupiterToUranusData = NSDictionary(); jupiterToNeptuneData = NSDictionary();
        
        saturnToUranusData = NSDictionary(); saturnToNeptuneData = NSDictionary();
        
        uranusToNeptuneData = NSDictionary();
        
        sunDataArray = NSMutableArray(); mercuryDataArray = NSMutableArray(); venusDataArray = NSMutableArray();
        earthDataArray = NSMutableArray(); marsDataArray = NSMutableArray(); jupiterDataArray = NSMutableArray();
        saturnDataArray = NSMutableArray(); uranusDataArray = NSMutableArray();
        
        
        selectedPlanetData = NSMutableArray()
        selectedPlanetDictionary = NSDictionary()
        
        self.targetView = UIImageView(frame: CGRect(x: 0, y: 0, width: 420, height: 420))
        targetView.image = UIImage(named: "crosshairs2")
        targetView.layer.zPosition = 2
        targetView.alpha = 0.0
        
        self.view.addSubview(self.targetView)
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func leftPlanetSelected() {
    
        self.leftSelected = true

    }
    
    
    @IBAction func rightPlanetSelected() {
     
        self.leftSelected = false
        
    }
    
    @IBAction func planetChosen(sender: AnyObject) {

        let planetNames = ["Sun","Mercury","Venus","Earth","Mars","Jupiter","Saturn","Uranus","Neptune"]
        let sunIndices = ["Mercury","Venus","Earth","Mars","Jupiter","Saturn","Uranus","Neptune"]
        let mercuryIndices = ["Venus","Earth","Mars","Jupiter","Saturn","Uranus","Neptune"]
        let venusIndices = ["Earth","Mars","Jupiter","Saturn","Uranus","Neptune"]
        let earthIndices = ["Mars","Jupiter","Saturn","Uranus","Neptune"]
        let marsIndices = ["Jupiter","Saturn","Uranus","Neptune"]
        let jupiterIndices = ["Saturn","Uranus","Neptune"]
        let saturnIndices = ["Uranus","Neptune"]
        let uranusIndices = ["Neptune"]
        var selectedIndices = [String]()
        
        let planetSent = sender as! UIButton
        
        let planetName = planetSent.titleLabel!.text!


        if(self.leftSelected){
            
            if(!(planetName == rightSelectedPlanet.titleLabel!.text!)){
                self.leftSelectedPlanet.setImage(UIImage(named: planetName.lowercaseString), forState: .Normal)
                self.targetView.center = self.leftSelectedPlanet.center
                self.leftSelectedPlanet.setTitle(planetName, forState: .Normal)
                self.planetsDisplayText.text = "\(leftSelectedPlanet.titleLabel!.text!) to \(rightSelectedPlanet.titleLabel!.text!)"
                
                UIView.animateWithDuration(0.5, animations: {
                    self.targetView.alpha = 1
                }) { (g) in
                    UIView.animateWithDuration(0.25, animations: {
                        self.targetView.alpha = 0.0
                    }) { (h) in
                        UIView.animateWithDuration(0.5, animations: {
                            self.targetView.alpha = 1.0
                        }) { (i) in
                            UIView.animateWithDuration(1.5, animations: {
                                self.targetView.alpha = 0.0
                            })}}}}
            
            
        } else {
            
            if(!(planetName == leftSelectedPlanet.titleLabel!.text!)){
                self.rightSelectedPlanet.setTitle(planetName, forState: .Normal)
                self.targetView.center = self.rightSelectedPlanet.center

                self.rightSelectedPlanet.setImage(UIImage(named: planetName.lowercaseString), forState: .Normal)
                self.planetsDisplayText.text = "\(leftSelectedPlanet.titleLabel!.text!) to \(rightSelectedPlanet.titleLabel!.text!)"
                
                UIView.animateWithDuration(0.5, animations: {
                    self.targetView.alpha = 1
                }) { (g) in
                    UIView.animateWithDuration(0.25, animations: {
                        self.targetView.alpha = 0.0
                    }) { (h) in
                        UIView.animateWithDuration(0.5, animations: {
                            self.targetView.alpha = 1.0
                        }) { (i) in
                            UIView.animateWithDuration(1.5, animations: {
                                self.targetView.alpha = 0.0
                            })}}}}
        
        }
        
        // Set the selectedPlanetData var to equal the selected planets
        

        let rightPlanet = rightSelectedPlanet.titleLabel!.text!
        let leftPlanet = leftSelectedPlanet.titleLabel!.text!
//        print("leftPlanet: \(leftPlanet)")
        var planetToGetDataFrom = ""
        var planetToGetDataFor = ""
        
        if(planetNames.indexOf(leftPlanet) <= planetNames.indexOf(rightPlanet)){
            planetToGetDataFrom = leftPlanet
            planetToGetDataFor = rightPlanet
        } else {
            planetToGetDataFrom = rightPlanet
            planetToGetDataFor = leftPlanet
        }
        
        if(planetToGetDataFrom == planetNames[0]){
            self.selectedPlanetData = self.sunDataArray
            selectedIndices = sunIndices
        } else if (planetToGetDataFrom == planetNames[1]) {
            self.selectedPlanetData = self.mercuryDataArray
            selectedIndices = mercuryIndices
        } else if (planetToGetDataFrom == planetNames[2]) {
            self.selectedPlanetData = self.venusDataArray
            selectedIndices = venusIndices
        } else if (planetToGetDataFrom == planetNames[3]) {
            self.selectedPlanetData = self.earthDataArray
            selectedIndices = earthIndices
        } else if (planetToGetDataFrom == planetNames[4]) {
            self.selectedPlanetData = self.marsDataArray
            selectedIndices = marsIndices
        } else if (planetToGetDataFrom == planetNames[5]) {
            self.selectedPlanetData = self.jupiterDataArray
            selectedIndices = jupiterIndices
        } else if (planetToGetDataFrom == planetNames[6]) {
            self.selectedPlanetData = self.saturnDataArray
            selectedIndices = saturnIndices
        } else if (planetToGetDataFrom == planetNames[7]) {
            self.selectedPlanetData = self.uranusDataArray
            selectedIndices = uranusIndices
        }
        
        // Put these values into a global var and use them in the updateDistances function
        // Example:
//        {
//            "2016-08-01 15:00:00.000000 UTC" = "69652828.5516644";
//            "2016-08-19 16:02:00.000000 UTC" = "69652666.0887063";
//            "2016-08-20 16:04:00.000000 UTC" = "69652503.5454849";
//            "2016-08-21 18:40:00.000000 UTC" = "71234821.2182537";
//            "2016-08-22 22:08:00.000000 UTC" = "69652340.9220006";
//            "2016-08-23 22:10:00.000000 UTC" = "77642123.4342448";
//            "2016-08-24 23:12:00.000000 UTC" = "79123101.5699739";
//        }
        
//        print("planetToGetDataFrom: \(planetToGetDataFrom)")
//        print("selectedPlanetData from \(planetToGetDataFrom) for \(planetToGetDataFor) \(self.selectedPlanetData[selectedIndices.indexOf(planetToGetDataFor)!])")
        
        self.selectedPlanetDictionary = self.selectedPlanetData[selectedIndices.indexOf(planetToGetDataFor)!] as! NSDictionary
        print("selectedPlanetDictionary: \(self.selectedPlanetDictionary)")
        
        self.updatePlanetDistances()
        
    }
    
    @IBAction func changeUnits(sender: AnyObject) {
        
        let buttonName = sender as! UIButton
        
       
        
        // Do conversions here
        
//        print(buttonName.titleLabel!.text!)

        
        if (buttonName.titleLabel!.text! == "Miles ➪")  {
            self.unitOfMeasurementLabel.setTitle("Kilometers ➪", forState: .Normal)
            self.milesSelected = false
            
            //  "927,846,334.13341690" <- earth to jupiter
            // 4348761326.28964500 <- mars to neptune
            
            //"908,702,761.99447730" <- mars to jupuiter
            
//            self.distanceLabel.text =  "57910000.219819"
            
        } else if(buttonName.titleLabel!.text! == "Kilometers ➪"){
            self.unitOfMeasurementLabel.setTitle("Miles ➪", forState: .Normal)
                    self.milesSelected = true

//            self.distanceLabel.text = "2,702,195,009.89227129"
            
        }
        
    }
    
    private func downloadPlanetData() {
        
        let planetDataString = "https://dl.dropboxusercontent.com/s/w2gga9nsf7fkwby/document%20%284%29.json?dl=0"
        
        guard let url = NSURL(string: planetDataString) else { fatalError("Invalid URL") }
        
        let session = NSURLSession.sharedSession()
        
        session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            
            let planetData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSMutableDictionary
            
            let sunToMercury = planetData.valueForKeyPath("Sun.Mercury") as! NSDictionary
            let sunToVenus = planetData.valueForKeyPath("Sun.Venus") as! NSDictionary
            let sunToEarth = planetData.valueForKeyPath("Sun.Earth") as! NSDictionary
            let sunToMars = planetData.valueForKeyPath("Sun.Mars") as! NSDictionary
            let sunToJupiter = planetData.valueForKeyPath("Sun.Jupiter") as! NSDictionary
            let sunToSaturn = planetData.valueForKeyPath("Sun.Saturn") as! NSDictionary
            let sunToUranus = planetData.valueForKeyPath("Sun.Uranus") as! NSDictionary
            let sunToNeptune = planetData.valueForKeyPath("Sun.Neptune") as! NSDictionary
            
            self.sunToMercuryData = sunToMercury
            self.sunToVenusData = sunToVenus
            self.sunToEarthData = sunToEarth
            self.sunToMarsData = sunToMars
            self.sunToJupiterData = sunToJupiter
            self.sunToSaturnData = sunToSaturn
            self.sunToUranusData = sunToUranus
            self.sunToNeptuneData = sunToNeptune
            
            let mercuryToVenus = planetData.valueForKeyPath("Mercury.Venus") as! NSDictionary
            let mercuryToEarth = planetData.valueForKeyPath("Mercury.Earth") as! NSDictionary
            let mercuryToMars = planetData.valueForKeyPath("Mercury.Mars") as! NSDictionary
            let mercuryToJupiter = planetData.valueForKeyPath("Mercury.Jupiter") as! NSDictionary
            let mercuryToSaturn = planetData.valueForKeyPath("Mercury.Saturn") as! NSDictionary
            let mercuryToUranus = planetData.valueForKeyPath("Mercury.Uranus") as! NSDictionary
            let mercuryToNeptune = planetData.valueForKeyPath("Mercury.Neptune") as! NSDictionary
            
            self.mercuryToVenusData = mercuryToVenus
            self.mercuryToEarthData = mercuryToEarth
            self.mercuryToMarsData = mercuryToMars
            self.mercuryToJupiterData = mercuryToJupiter
            self.mercuryToSaturnData = mercuryToSaturn
            self.mercuryToUranusData = mercuryToUranus
            self.mercuryToNeptuneData = mercuryToNeptune
            
            let venusToEarth = planetData.valueForKeyPath("Venus.Earth") as! NSDictionary
            let venusToMars = planetData.valueForKeyPath("Venus.Mars") as! NSDictionary
            let venusToJupiter = planetData.valueForKeyPath("Venus.Jupiter") as! NSDictionary
            let venusToSaturn = planetData.valueForKeyPath("Venus.Saturn") as! NSDictionary
            let venusToUranus = planetData.valueForKeyPath("Venus.Uranus") as! NSDictionary
            let venusToNeptune = planetData.valueForKeyPath("Venus.Neptune") as! NSDictionary

            self.venusToEarthData = venusToEarth
            self.venusToMarsData = venusToMars
            self.venusToJupiterData = venusToJupiter
            self.venusToSaturnData = venusToSaturn
            self.venusToUranusData = venusToUranus
            self.venusToNeptuneData = venusToNeptune
            
            let earthToMars = planetData.valueForKeyPath("Earth.Mars") as! NSDictionary
            let earthToJupiter = planetData.valueForKeyPath("Earth.Jupiter") as! NSDictionary
            let earthToSaturn = planetData.valueForKeyPath("Earth.Saturn") as! NSDictionary
            let earthToUranus = planetData.valueForKeyPath("Earth.Uranus") as! NSDictionary
            let earthToNeptune = planetData.valueForKeyPath("Earth.Neptune") as! NSDictionary
            
            self.earthToMarsData = earthToMars
            self.earthToJupiterData = earthToJupiter
            self.earthToSaturnData = earthToSaturn
            self.earthToUranusData = earthToUranus
            self.earthToNeptuneData = earthToNeptune
            
            let marsToJupiter = planetData.valueForKeyPath("Mars.Jupiter") as! NSDictionary
            let marsToSaturn = planetData.valueForKeyPath("Mars.Saturn") as! NSDictionary
            let marsToUranus = planetData.valueForKeyPath("Mars.Uranus") as! NSDictionary
            let marsToNeptune = planetData.valueForKeyPath("Mars.Neptune") as! NSDictionary
            
            self.marsToJupiterData = marsToJupiter
            self.marsToSaturnData = marsToSaturn
            self.marsToUranusData = marsToUranus
            self.marsToNeptuneData = marsToNeptune
            
            let jupiterToSaturn = planetData.valueForKeyPath("Jupiter.Saturn") as! NSDictionary
            let jupiterToUranus = planetData.valueForKeyPath("Jupiter.Uranus") as! NSDictionary
            let jupiterToNeptune = planetData.valueForKeyPath("Jupiter.Neptune") as! NSDictionary
            
            self.jupiterToSaturnData = jupiterToSaturn
            self.jupiterToUranusData = jupiterToUranus
            self.jupiterToNeptuneData = jupiterToNeptune
            
            let saturnToUranus = planetData.valueForKeyPath("Saturn.Uranus") as! NSDictionary
            let saturnToNeptune = planetData.valueForKeyPath("Saturn.Neptune") as! NSDictionary
            
            self.saturnToUranusData = saturnToUranus
            self.saturnToNeptuneData = saturnToNeptune
            
            let uranusToNeptune = planetData.valueForKeyPath("Uranus.Neptune") as! NSDictionary
            
            self.uranusToNeptuneData = uranusToNeptune
            
            self.sunDataArray.addObject(self.sunToMercuryData); self.sunDataArray.addObject(self.sunToVenusData);
            self.sunDataArray.addObject(self.sunToEarthData); self.sunDataArray.addObject(self.sunToMarsData);
            self.sunDataArray.addObject(self.sunToJupiterData); self.sunDataArray.addObject(self.sunToSaturnData);
            self.sunDataArray.addObject(self.sunToUranusData); self.sunDataArray.addObject(self.sunToNeptuneData);
            
            self.mercuryDataArray.addObject(self.mercuryToVenusData); self.mercuryDataArray.addObject(self.mercuryToEarthData);
            self.mercuryDataArray.addObject(self.mercuryToMarsData); self.mercuryDataArray.addObject(self.mercuryToJupiterData);
            self.mercuryDataArray.addObject(self.mercuryToSaturnData); self.mercuryDataArray.addObject(self.mercuryToUranusData);
            self.mercuryDataArray.addObject(self.mercuryToNeptuneData);
            
            self.venusDataArray.addObject(self.venusToEarthData); self.venusDataArray.addObject(self.venusToMarsData);
            self.venusDataArray.addObject(self.venusToJupiterData); self.venusDataArray.addObject(self.venusToSaturnData);
            self.venusDataArray.addObject(self.venusToUranusData); self.venusDataArray.addObject(self.venusToNeptuneData);
            
            self.earthDataArray.addObject(self.earthToMarsData); self.earthDataArray.addObject(self.earthToJupiterData);
            self.earthDataArray.addObject(self.earthToSaturnData); self.earthDataArray.addObject(self.earthToUranusData);
            self.earthDataArray.addObject(self.earthToNeptuneData);
            
            self.marsDataArray.addObject(self.marsToJupiterData); self.marsDataArray.addObject(self.marsToSaturnData);
            self.marsDataArray.addObject(self.marsToUranusData); self.marsDataArray.addObject(self.marsToNeptuneData);
            
            self.jupiterDataArray.addObject(self.jupiterToSaturnData); self.jupiterDataArray.addObject(self.jupiterToUranusData);
            self.jupiterDataArray.addObject(self.jupiterToNeptuneData);
            
            self.saturnDataArray.addObject(self.saturnToUranusData); self.saturnDataArray.addObject(self.saturnToNeptuneData);
            
            self.uranusDataArray.addObject(self.uranusToNeptuneData);
            
            
//            print(self.sunToMercuryData)
//            print("Sun to Neptune: \(self.sunToNeptuneData)")
//            print("Uranus to Neptune: \(self.uranusToNeptuneData)")
            
//            print(self.uranusDataArray)
            
            
            self.updatePlanetDistances()
            

            dispatch_async(dispatch_get_main_queue(), {
                self.downloadComplete()
            })
            
            
            }.resume()
        
    }
    
    func downloadComplete() {
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(updatePlanetDistances), userInfo:nil,  repeats: true)
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(self.distanceUpdate), userInfo:nil,  repeats: true)
    
    }
    
    @objc private func updatePlanetDistances() {
        
        // Steps: 
        
        // 1) create a new date object to get the current time
        
        // 2) convert date strings from sunToMercuryData into dates
        
        // 3) find the date in the dictionary that is the closet to actual date (make sure it is in the past, not future)
        
        // 4) get the distance from that date, and then the next date. Then, create an equation to match those 2 values that updates by the second/half-second
        
        // 5) update self.distanceLabel.text to reflect the equation
        
        // 6) if a new time from the sunToMercury dictionary passes, redo all above steps (Idea: create an animation or label that displays "tracking... or honing in.." while updating)
        
        
        // Steps 1, 2, and 3
        
        let currentTime = NSDate()
//        print("currentTime: \(currentTime)")
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S Z"
        
        let selectedPlanetKeys = self.selectedPlanetDictionary.allKeys
        let selectedPlanetValues = self.selectedPlanetDictionary.allValues
        
//        print("selectedPlanetKeys: \(selectedPlanetKeys)")
//        print("selectedPlanetValues: \(selectedPlanetValues)")
        
        let sunToMercuryKeys = self.sunToMercuryData.allKeys
        let sunToMercuryValues = self.sunToMercuryData.allValues
        
        let datesArray = NSMutableArray()
        
        var dictionaryToUse = NSDictionary()
        var arrayToUse = NSArray()
        
        if(selectedPlanetKeys.isEmpty){
            arrayToUse = sunToMercuryKeys
            dictionaryToUse = sunToMercuryData
        } else {
            arrayToUse = selectedPlanetKeys
            dictionaryToUse = selectedPlanetDictionary
        }
        
        for date in arrayToUse {
            
            let formattedDate = dateFormatter.dateFromString(String(date))
            datesArray.addObject(formattedDate!)
        }
        
        var descriptor: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
        var sortedResults: NSArray = datesArray.sortedArrayUsingDescriptors([descriptor])

        let beforeDates = NSMutableArray()
        let afterDates = NSMutableArray()
        
        for date in sortedResults {
            
            if date.compare(currentTime) == NSComparisonResult.OrderedDescending
            {
                    // After
                afterDates.addObject(date)
                
                
                
            } else if date.compare(currentTime) == NSComparisonResult.OrderedAscending
            {
                    // Before
                
                beforeDates.addObject(date)
                
            }
            
        }
        
//        print(beforeDates)
//        print(afterDates)
        
        // Steps 3 and 4
        
        let previousDate = beforeDates.lastObject!
        let nextDate = afterDates.firstObject!
        
//        print(previousDate)
//        print(nextDate)
        
        let convertedPrevDate = convertToUTC(String(previousDate))
        let convertedNextDate = convertToUTC(String(nextDate))
        
        let previousDateDistance = dictionaryToUse.valueForKey(String(convertedPrevDate))
        let nextDateDistance = dictionaryToUse.valueForKey(String(convertedNextDate))
        
//        print(previousDateDistance!)
//        print(nextDateDistance!)
        
        // Create Equation Here
        
        let prevDistanceDouble = previousDateDistance as! Double
        let nextDistanceDouble = nextDateDistance as! Double
        
        self.distanceLabel.text = String(prevDistanceDouble)
        
        let calendar = NSCalendar.currentCalendar()
        
        let datecomponenets = calendar.components(NSCalendarUnit.Second, fromDate: previousDate as! NSDate, toDate: nextDate as! NSDate, options: [])
        let seconds = datecomponenets.second
//        print("Seconds: \(seconds)")
        
        let halfSecondsBetweenDates = seconds * 2
        let secondsPassedSincePreviousDateComponents = calendar.components(.Second, fromDate: previousDate as! NSDate, toDate: currentTime as! NSDate, options: [])
        self.secondsPassedSincePreviousDate = Double(secondsPassedSincePreviousDateComponents.second)
//        print("secondsPassedSincePreviousDate: \(secondsPassedSincePreviousDate)")
        
        ratePerHalfSecond = (nextDistanceDouble - prevDistanceDouble) / Double(halfSecondsBetweenDates)
        
        self.actualDistance = prevDistanceDouble + (ratePerHalfSecond * secondsPassedSincePreviousDate)
        
//        print(ratePerHalfSecond)
        
    }
    
    private func convertToUTC(date: String) -> String {
        
        let intIndex = date.startIndex...date.startIndex.advancedBy(18)
        
        var text = date[intIndex]
        text = text + ".000000 UTC"
        
        return text
    }
    
    
    func distanceUpdate(){
        
//        let formattedString = String(format: "%.02f", self.actualDistance)
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.maximumFractionDigits = 4;
        let distanceText = formatter.stringFromNumber(self.actualDistance)
        
        if(milesSelected){
            
            self.actualDistance = self.actualDistance*(0.6213711922)
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .DecimalStyle
            formatter.maximumFractionDigits = 4;
            let distanceText = formatter.stringFromNumber(self.actualDistance)
            self.distanceLabel.text = distanceText
            
        }else{
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .DecimalStyle
            formatter.maximumFractionDigits = 4;
            let distanceText = formatter.stringFromNumber(self.actualDistance)
            self.distanceLabel.text = distanceText
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
