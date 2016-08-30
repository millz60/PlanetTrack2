//
//  WebViewController.swift
//  PlanetTrack2
//
//  Created by Matt Milner on 8/30/16.
//  Copyright © 2016 Matt Milner. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var backButton: UITabBarItem!
    @IBOutlet weak var forwardButton: UITabBarItem!
    @IBOutlet weak var refreshButton: UITabBarItem!

    override func viewDidLoad() {
        super.viewDidLoad()


        let url = NSURL(string: "https://solarsystem.nasa.gov/missions/target")
        
        self.webView.delegate = self
        
        webView.loadRequest(NSURLRequest(URL: url!))
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(){
    
        if(webView.canGoBack){
            webView.goBack()
        }
    
    }
    
    @IBAction func forwardButtonPressed(){
        
        if(webView.canGoForward){
            webView.goForward()
        }
        
    }
    
    @IBAction func refreshPageButtonPressed(){
        
         webView.reload()

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
