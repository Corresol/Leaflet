//
//  PermissionPushView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 10/30/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit


class PermissionPushView: UIView {
    
    @IBOutlet weak var allowPermissionBtn: UIButton!
    
    var permission:Permission = Permission.Notifications
    var permissionDialogTitle:String = "Push Notifications"
    var permissionDialogMessage:String = "Never miss out. Get updates about your itineraries."
    var permissionDialogMessageAlt:String = "Never miss out. Get updates about your itineraries. Enable notifications in settings."
    var onNext:((status:PermissionStatus)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureUI() {
        frame.origin.y = frame.height
        allowPermissionBtn.layer.masksToBounds = true
        allowPermissionBtn.layer.cornerRadius = 5
        allowPermissionBtn.addTarget(self, action: #selector(askForPush), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func shouldShow() -> Bool {
        return permission.status != PermissionStatus.Authorized
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
    
    func askForPush() {
        
        var popup:PopupDialog!
        var buttonOne:DefaultButton!
        var buttonTwo:DefaultButton!
        
        // Handle Not Determined
        if permission.status == PermissionStatus.NotDetermined {
            //popup = PopupDialog(title: permissionDialogTitle, message: permissionDialogMessage)
            //buttonOne = DefaultButton(title: "Not Now") {
            //   mainQueue({
            //        self.handleNext()
            //        self.hide()
            //   })
            //}
            //buttonTwo = DefaultButton(title: "Give Access") {
                mainQueue({
                    self.handleNext()
                    self.hide()
                })
                self.permission.requestNotifications({ (status) in
                })
            //}
            //popup.addButtons([buttonOne, buttonTwo])
            //MainView.viewController!.presentViewController(popup, animated: true, completion: nil)
        }
            
            // Handle Denied
        else if permission.status == PermissionStatus.Denied {
            popup = PopupDialog(title: permissionDialogTitle, message: permissionDialogMessageAlt)
            buttonOne = DefaultButton(title: "Got it") {
                mainQueue({
                    self.handleNext()
                    self.hide()
                })
            }
            popup.addButtons([buttonOne])
            MainView.viewController!.presentViewController(popup, animated: true, completion: nil)
        }
            
            // Handle Authorized
        else if permission.status == PermissionStatus.Authorized {
            mainQueue({
                self.handleNext()
                self.hide()
            })
        }
            
            // Handle Disable
        else if permission.status == PermissionStatus.Disabled {
            popup = PopupDialog(title: permissionDialogTitle, message: permissionDialogMessageAlt)
            buttonOne = DefaultButton(title: "Got it") {
                mainQueue({
                    self.handleNext()
                    self.hide()
                })
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
    
    static func loadFromXib() -> PermissionPushView {
        let instance = NSBundle.mainBundle().loadNibNamed("PermissionPushView", owner: self, options: nil)!.first as! PermissionPushView
        instance.frame = UIScreen.mainScreen().bounds
        instance.configureUI()
        return instance
    }
}
