//
//  MenuView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/25/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    @IBOutlet weak var notificationAlert: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var menu:UIView!
    @IBOutlet weak var menuConstraint:NSLayoutConstraint!
    @IBOutlet weak var overlay:UIView!
    
    @IBAction func onHome(sender: AnyObject) {
        hideWithCallback { 
        }
    }
    
    @IBAction func onNotifications(sender: AnyObject) {
        hideWithCallback {
            MainView.instance?.notificationView.show()
        }
    }
    
    @IBAction func onBookmarks(sender: AnyObject) {
        hideWithCallback {
            MainView.instance?.bookmarkView.show()
        }
    }
    
    @IBAction func onHelp(sender: AnyObject) {
        hideWithCallback {
            mainQueue({
                UIApplication.sharedApplication().openURL(NSURL(string: HelpURL)!)
            })
        }
    }
    
    @IBAction func onSettings(sender: AnyObject) {
        hideWithCallback {
            MainView.instance?.settingsView.show()
        }
    }
    
    func onProfileView() {
        hideWithCallback { 
            MainView.instance?.profileView.show(self.icon.image)
        }
    }
    
    func initialize() {
        hidden = true
        overlay.alpha = 0
        overlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hide)))
        menuConstraint.constant = -menu.frame.width
        icon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onProfileView)))
    }
    
    func useIcon(url:String) {
        icon.loadImageFromURL(NSURL(string: url)!)
    }
    
    func useName(text:String) {
        name.text = text
    }
    
    func show() {
        hidden = false
        UIView.animateWithDuration(DurationForMenu) {
            self.menuConstraint.constant = 0
            self.layoutIfNeeded()
            self.overlay.alpha = 1
        }
    }
    
    func hide() {
        hideWithCallback { () -> Void in
        }
    }
    
    func hideWithCallback(callback:(()->Void)) {
        self.menuConstraint.constant = -menu.frame.width
        UIView.animateWithDuration(DurationForMenu, animations: {
                self.layoutIfNeeded()
            }) { (finished) in
                UIView.animateWithDuration(DurationForMenu, animations: {
                        self.overlay.alpha = 0
                    }, completion: { (finished) in
                        self.hidden = true
                        callback()
                })
        }
    }
    
    static func loadFromXib() -> MenuView {
        let instance = NSBundle.mainBundle().loadNibNamed("MenuView", owner: self, options: nil)!.first as! MenuView
        instance.frame = UIScreen.mainScreen().bounds
        instance.initialize()
        instance.layoutIfNeeded()
        return instance
    }
}



