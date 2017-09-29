//
//  Profile.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 10/30/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class Profile: UIView {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bio: UILabel!
    
    @IBAction func onCloseHandler(sender: AnyObject) {
        hide()
    }
    
    func show(icon:String, username:String, bio:String) {
        self.icon.nk_setImageWith(NSURL(string: icon)!)
        self.name.text = username
        self.bio.text = bio
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = 0
        }
    }
    
    func hide() {
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = self.frame.height
        }
    }

    func configureUI() {
        frame.origin.y = frame.height
    }
    
    static func loadFromXib() -> Profile {
        let instance = NSBundle.mainBundle().loadNibNamed("Profile", owner: self, options: nil)!.first as! Profile
        instance.frame = UIScreen.mainScreen().bounds
        instance.layoutIfNeeded()
        instance.configureUI()
        return instance
    }
}

