//
//  LocationRequest.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 10/30/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit
import Parse

class LocationRequestView: UIView {

    var city:String = ""
    var locality:String = ""
    var location:NSDictionary!
    var LocationRequestLimit:Int = 999
    var requests:[EventRequest] = []
    
    @IBOutlet weak var requestCount: UILabel!
    @IBOutlet weak var requestCity: UILabel!
    
    @IBAction func onClose(sender: AnyObject) {
        if Session.me() != nil {
            MainView.instance?.menuView.show()
        }
        else {
            MainView.instance?.onboardView.show()
        }
    }
 
    @IBOutlet weak var requestBtn: UIButton!
    @IBAction func onRequest(sender: AnyObject) {
        if self.location != nil && !self.hasRequested() {
            let request = EventRequest()
            request.setObject(Session.me()!, forKey: "user")
            request.setValue(self.locality, forKey: "country")
            request.setValue(self.city, forKey: "city")
            request.setValue(0, forKey: "request_count")
            request.setValue(0, forKey: "zip_code")
            
            if Session.location != nil {
                request.setObject(Session.location, forKey: "localLocation")
            }
            
            request.saveInBackground()
            requests.append(request)
            applyRequestedBtnStyle()
        }
    }
    
    func applyUnRequestBtnStyle() {
        self.requestBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.requestBtn.backgroundColor = RequestBtnColor
        self.requestBtn.enabled = true
        self.requestCount.text = "\(LocationRequestLimit)"
        self.requestBtn.setTitle("Request", forState: UIControlState.Normal)
    }
    
    func applyRequestedBtnStyle() {
        self.requestBtn.setTitleColor(RequestBtnColor, forState: UIControlState.Normal)
        self.requestBtn.backgroundColor = UIColor.whiteColor()
        self.requestBtn.enabled = false
        self.requestCount.text = "\(LocationRequestLimit-self.requests.count)"
        self.requestBtn.setTitle("Requested", forState: UIControlState.Normal)
    }
    
    func hasRequested() -> Bool {
        if Session.me() != nil {
            for request in requests {
                if request["user"] != nil {
                    let user:User  = request["user"] as! User
                    if user.objectId! == Session.me()!.objectId! {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func show() {
        setLocation()
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = 0
        }
    }
    
    func hide() {
        UIView.animateWithDuration(DurationForUI, animations: { 
                self.frame.origin.y = self.frame.height
            }) { (finished) in
                self.requests = []
                self.applyUnRequestBtnStyle()
        }
    }
    
    func configureUI() {
        frame.origin.y = frame.height
    }
    
    func setAccurateLocation() {
        if Session.me() != nil {
            self.city = Session.location.valueForKey("locationCity") as! String
            self.requestCity.text = "\(self.city)"
            
            let query = EventRequest.query()
            query?.whereKey("city", equalTo: self.city)
            query?.includeKey("user")
            query?.findObjectsInBackgroundWithBlock({ (requests, error) in
                if error == nil {
                    self.requests = requests as! [EventRequest]
                    if self.hasRequested() {
                        self.applyRequestedBtnStyle()
                    }
                    else {
                        self.applyUnRequestBtnStyle()
                    }
                }
            })
        }
    }
    
    
    func setLocationWithoutSession() {
        let ipChecker = APPublicIP();
        ipChecker.getCurrentIP { (ip) -> Void in
            if ip != nil {
                PFCloud.callFunctionInBackground("locationFromIP", withParameters: ["ip": ip!], block: { (response, error) in
                    if error == nil && response != nil {
                        let data = response! as! NSDictionary
                        let location = data
                        if location["ipLocation"] != nil  && location["locality"] != nil {
                            let locality = location["locality"] as! String
                            let ipLocation = location["ipLocation"] as! NSDictionary
                            if ipLocation["city"] != nil {
                                self.locality = locality
                                self.city = ipLocation["city"] as! String
                                self.city = self.city == "" ? "Your Area" : self.city
                                self.requestCity.text = "\(self.city)"
                                self.location = location
                                
                                let query = EventRequest.query()
                                query?.whereKey("city", equalTo: self.city)
                                query?.includeKey("user")
                                query?.findObjectsInBackgroundWithBlock({ (requests, error) in
                                    if error == nil {
                                        self.requests = requests as! [EventRequest]
                                        self.applyRequestedBtnStyle()
                                    }
                                })
                            }
                        }
                        
                    }
                })
            }
        }
    }
    
    func setLocation() {
        if Session.me() != nil && Session.me()?.valueForKey("location") != nil {
            let location = Session.me()?.valueForKey("location") as! NSDictionary
            if location["ipLocation"] != nil  && location["locality"] != nil {
                let locality = location["locality"] as! String
                let ipLocation = location["ipLocation"] as! NSDictionary
                if ipLocation["city"] != nil {
                    self.locality = locality
                    self.city = ipLocation["city"] as! String
                    self.city = self.city == "" ? "Your Area" : self.city
                    self.requestCity.text = "\(self.city)"
                    self.location = location
                    
                    let query = EventRequest.query()
                    query?.whereKey("city", equalTo: self.city)
                    query?.includeKey("user")
                    query?.findObjectsInBackgroundWithBlock({ (requests, error) in
                        if error == nil {
                            self.requests = requests as! [EventRequest]
                            if self.hasRequested() {
                                self.applyRequestedBtnStyle()
                            }
                            else {
                                self.applyUnRequestBtnStyle()
                            }
                        }
                    })
                }
            }
        }
    }
    
    static func loadFromXib() -> LocationRequestView {
        let instance = NSBundle.mainBundle().loadNibNamed("LocationRequestView", owner: self, options: nil)!.first as! LocationRequestView
        instance.frame = UIScreen.mainScreen().bounds
        instance.configureUI()
        instance.setLocationWithoutSession()
        return instance
    }
}
