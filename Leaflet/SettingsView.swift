//
//  SettingsView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/26/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class SettingsView: UIView {

    var BottomOffset:CGFloat = 80
    var tagView:ChooseTagView!
    
    @IBOutlet weak var adminBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var holderView: UIScrollView!
    
    @IBOutlet weak var fieldName: UITextField!
    @IBOutlet weak var fieldEmail: UITextField!
    @IBOutlet weak var fieldAccount: UITextField!
    @IBOutlet weak var fieldVersion: UITextField!
    
    @IBOutlet weak var updatePreferenceBtn: UIButton!
    @IBAction func onUpdatePreferences(sender: AnyObject) {
        if Session.me()?["tags"] != nil {
            tagView.tagsSelected = Session.me()?["tags"] as! [String]
        }
        tagView.show()
    }
    
    @IBOutlet weak var notificationEmail: UISwitch!
    @IBOutlet weak var notificationPush: UISwitch!
    
    @IBAction func onClose(sender: AnyObject) {
        hide()
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        holderView.setContentOffset(CGPointZero, animated: true)
        Session.destroy()
        hideWithCallback({
            MainView.instance?.onboardView.show()
        })
    }
    
    @IBAction func onAdminView(sender: AnyObject) {
        MainView.instance?.adminView.show()
    }
    
    func show() {
        if Session.me()?["is_admin"] != nil && String(Session.me()?["is_admin"]!) != "no" && String(Session.me()?["is_admin"]!) != "Optional(0)" {
            adminBtn.hidden = false
        }
        else {
            adminBtn.hidden = true
        }
        
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = 0
        }
    }
    
    func hide() {
        endEditing(true)
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = self.frame.height
        }
    }
    
    func hideWithCallback(callback:(()->Void)) {
        UIView.animateWithDuration(DurationForUI, animations: { 
                self.frame.origin.y = self.frame.height
            }) { (finished) in
                callback()
        }
    }
    
    func hideKeyboard() {
        endEditing(true)
    }
    
    func configureUI() {
        frame.origin.y = frame.height
        dispatch_async(dispatch_get_main_queue()) { 
            self.holderView.contentSize = CGSizeMake(self.frame.width, self.adminBtn.frame.origin.y+self.adminBtn.frame.height+self.BottomOffset)
        }
        self.holderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        tagView = ChooseTagView.loadFromXib()
        tagView.ignoreTagLimit = true
        tagView.frame.origin.y = tagView.frame.height
        tagView.populateUI()
        tagView.onNext = {
            Session.me()?["tags"] = self.tagView.tagsSelected
            Session.me()?.saveInBackground()
            self.tagView.hide()
        }
        addSubview(tagView)
    }
    
    static func loadFromXib() -> SettingsView {
        let instance = NSBundle.mainBundle().loadNibNamed("SettingsView", owner: self, options: nil)!.first as! SettingsView
        instance.frame = UIScreen.mainScreen().bounds
        instance.configureUI()
        instance.layoutIfNeeded()
        return instance
    }
}

