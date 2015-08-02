//
//  ViewController.swift
//  FliudLoadingIndicator
//
//  Created by ViNiT. on 8/2/15.
//  Copyright (c) 2015 ViNiT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var titleLabels: UILabel!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var exampleContainerView: UIView!
    @IBOutlet var startAnime: UIButton!
    @IBOutlet var myImage: UIImageView!
    
    var gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setUpBackground()
        startAnime.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        titleLabels.text = ""
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startAnimation(sender: AnyObject) {
        
        var myView:BAFluidView = BAFluidView(frame: self.view.frame, startElevation: 0.5)
        
        myView.strokeColor = UIColor.whiteColor()
        myView.fillColor = UIColor(netHex: 0x2e353d)
        myView.keepStationary()
        myView.startAnimation()
        titleLabels.textColor = UIColor.whiteColor()
        self.exampleContainerView.hidden = false
        myView.startAnimation()
        
        self.view.insertSubview(myView, aboveSubview: self.backgroundView)
        
        UIView.animateWithDuration(0.5, animations: {
            myView.alpha=1.0
            }, completion: { _ in
                self.titleLabels.text = "Downloading"
                self.startAnime.enabled = false
                self.exampleContainerView.removeFromSuperview()
                self.exampleContainerView = myView
        })
        
        if let imageUrl = NSURL(string: "http://swinggolfireland.com/wp-content/uploads/2014/09/OldHead_7PanB.jpg") {
            let imageRequest: NSURLRequest = NSURLRequest(URL: imageUrl)
            let queue: NSOperationQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(imageRequest, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if data != nil {
                    self.titleLabels.text = "Complete!"
                    self.exampleContainerView.hidden = true
                    self.startAnime.enabled = true
                    println("done")
                    self.myImage.image = UIImage(data: data)
                    self.myImage.layer.borderWidth = 2.0
                    self.myImage.layer.borderColor = UIColor.whiteColor().CGColor
                    
                } else {
                    self.titleLabels.text = "Error Downloading"
                    self.exampleContainerView.hidden = true
                    self.startAnime.enabled = true
                    println("error")
                }
            })
        }
        
    }
    
    func setUpBackground() {
        
        if ((self.gradient) != nil) {
            self.gradient.removeFromSuperlayer()
            self.gradient = nil
        }
        
        var tempLayer: CAGradientLayer = CAGradientLayer()
        tempLayer.frame = self.view.bounds
        tempLayer.colors = [UIColor(netHex: 0x53cf84).CGColor, UIColor(netHex: 0x53cf84).CGColor, UIColor(netHex: 0x2aa581).CGColor, UIColor(netHex: 0x1b9680).CGColor]
        tempLayer.locations = [NSNumber(float: 0.0), NSNumber(float: 0.5), NSNumber(float: 0.8), NSNumber(float: 1.0)]
        tempLayer.startPoint = CGPointMake(0, 0)
        tempLayer.endPoint = CGPointMake(1, 1)
        
        self.gradient = tempLayer
        self.backgroundView.layer.insertSublayer(self.gradient, atIndex: 1)
        self.exampleContainerView.hidden = true
        
    }
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

