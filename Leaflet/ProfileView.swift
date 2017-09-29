//
//  ProfileView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/27/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class ProfileView: UIView {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var bioField: UITextView!
    
    @IBAction func onClose(sender: AnyObject) {
        hide()
    }
    
    func show(image:UIImage?) {
        icon.image = image
        nameField.text = "\(Session.me()!["full_name"] as! String)"
        nameField.enabled = false
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = 0
        }
    }
    
    func hide() {
        Session.me()!["bio"] = self.bioField.text!
        Session.me()!.saveInBackground()
        
        self.nameField.endEditing(true)
        self.bioField.endEditing(true)
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = self.frame.height
        }
        delay(DurationForUI) {
            AttentionView.displayBanner("Profile Saved!")
        }
    }
    
    func configureUI() {
        frame.origin.y = frame.height
    }
    
    static func loadFromXib() -> ProfileView {
        let instance = NSBundle.mainBundle().loadNibNamed("ProfileView", owner: self, options: nil)!.first as! ProfileView
        instance.frame = UIScreen.mainScreen().bounds
        instance.layoutIfNeeded()
        instance.configureUI()
        return instance
    }
}

