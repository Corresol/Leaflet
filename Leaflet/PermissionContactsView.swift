//
//  PermissionLocationView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/11/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class PermissionContactsView: UIView {

    @IBOutlet weak var allowPermissionBtn: UIButton!
    
    var permission:Permission = Permission.AddressBook
    var permissionDialogTitle:String = "Access to Contacts"
    var permissionDialogMessage:String = "Find people to invite within your address book. "
    var permissionDialogMessageAlt:String = "Find people to invite within your address book. Enable your contacts in settings."
    var onNext:((status:PermissionStatus)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureUI() {
        allowPermissionBtn.layer.masksToBounds = true
        allowPermissionBtn.layer.cornerRadius = 5
        allowPermissionBtn.addTarget(self, action: #selector(askForAddressBook), forControlEvents: UIControlEvents.TouchUpInside)
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
    
    func askForAddressBook() {
        
        var popup:PopupDialog!
        var buttonOne:DefaultButton!
        var buttonTwo:DefaultButton!
        
        // Handle Not Determined
        if permission.status == PermissionStatus.NotDetermined {
            //popup = PopupDialog(title: permissionDialogTitle, message: permissionDialogMessage)
            //buttonOne = DefaultButton(title: "Not Now") {
            //    self.handleNext()
            //}
            //buttonTwo = DefaultButton(title: "Give Access") {
                self.permission.requestAddressBook({ (status) in
                    self.handleNext()
                })
            //}
            //popup.addButtons([buttonOne, buttonTwo])
            //MainView.viewController!.presentViewController(popup, animated: true, completion: nil)
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
    
    static func loadFromXib() -> PermissionContactsView {
        let instance = NSBundle.mainBundle().loadNibNamed("PermissionContactsView", owner: self, options: nil)!.first as! PermissionContactsView
        instance.frame = UIScreen.mainScreen().bounds
        instance.configureUI()
        return instance
    }
}
