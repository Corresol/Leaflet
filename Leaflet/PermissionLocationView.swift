//
//  PermissionContactsView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/11/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class PermissionLocationView: UIView {

    @IBOutlet weak var allowPermissionBtn: UIButton!
    
    var permission:Permission = Permission.LocationAlways
    var permissionDialogTitle:String = "Access to Location"
    var permissionDialogMessage:String = "\(AppName) works best when you provide your location. \(AppName) will display the best personalized plans near you."
    var permissionDialogMessageAlt:String = "\(AppName) works best when you provide your location. Enable your location in settings."
    var onNext:((status: PermissionStatus)->Void)?
    var timer:NSTimer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureUI() {
        allowPermissionBtn.layer.masksToBounds = true
        allowPermissionBtn.layer.cornerRadius = 5
        allowPermissionBtn.addTarget(self, action: #selector(askForLocationPermission), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func shouldShow() -> Bool {
        return permission.status != PermissionStatus.Authorized
    }
    
    func continuousLocationCheck() {
        if !shouldShow() {
            self.handleNext()
            timer?.invalidate()
        }
    }
    
    func show() {
        UIView.animateWithDuration(DurationForUI) { 
            self.frame.origin.y = 0
        }
    }
    
    func hide() {
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = self.frame.height
        }
    }
    
    func askForLocationPermission() {
        var popup:PopupDialog!
        var buttonOne:DefaultButton!
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(continuousLocationCheck), userInfo: nil, repeats: true)
        
        // Handle Not Determined
        if permission.status == PermissionStatus.NotDetermined {
            //popup = PopupDialog(title: permissionDialogTitle, message: permissionDialogMessage)
            //buttonOne = DefaultButton(title: "Give Access") {
                self.permission.requestLocationAlways({ (status) in
                })
           // }
           // popup.addButtons([buttonOne])
           // MainView.viewController!.presentViewController(popup, animated: true, completion: nil)
        }
        
        // Handle Denied
        else if permission.status == PermissionStatus.Denied {
            popup = PopupDialog(title: permissionDialogTitle, message: permissionDialogMessageAlt)
            buttonOne = DefaultButton(title: "Got it") {
                self.handleRedirectToSettings()
            }
            popup.addButtons([buttonOne])
            MainView.viewController!.presentViewController(popup, animated: true, completion: nil)
        }
        
        // Handle Authorized
        else if permission.status == PermissionStatus.Authorized {
            self.handleNext()
        }
        
        // Handle Disable
        else if permission.status == PermissionStatus.Disabled {
            popup = PopupDialog(title: permissionDialogTitle, message: permissionDialogMessageAlt)
            buttonOne = DefaultButton(title: "Got it") {
                self.handleRedirectToSettings()
            }
            popup.addButtons([buttonOne])
            MainView.viewController!.presentViewController(popup, animated: true, completion: nil)
        }
    }
    
    func handleNext() {
        onNext?(status: permission.status)
    }
    
    func handleRedirectToSettings() {
        UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
    }
    
    static func loadFromXib() -> PermissionLocationView {
        let instance = NSBundle.mainBundle().loadNibNamed("PermissionLocationView", owner: self, options: nil)!.first as! PermissionLocationView
        instance.frame = UIScreen.mainScreen().bounds
        instance.configureUI()
        return instance
    }
}
