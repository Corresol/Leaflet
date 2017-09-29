//
//  PickerDateView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/27/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class PickerDateView: UIView {

    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var holder: UIView!
    @IBOutlet weak var picker: UIDatePicker!
    
    @IBAction func onClose(sender: AnyObject) {
        hide()
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        let date = dateFormat.stringFromDate(picker.date)
        onDone?(date: date)
    }
    
    var onDone:((date:String)->Void)?
    
    func show() {
        hidden = false
        UIView.animateWithDuration(DurationForUI, animations: { 
                self.alpha = 1
            }) { (finished) in
                UIView.animateWithDuration(DurationForUI, animations: { 
                        self.holder.frame.origin.y = self.frame.height-self.holder.frame.height
                    }, completion: { (finished) in
                })
        }
    }
    
    func hide() {
        UIView.animateWithDuration(DurationForUI, animations: {
                self.alpha = 0
                self.holder.frame.origin.y = self.frame.height
            }) { (finished) in
                self.hidden = true
        }
    }
    
    func configureUI() {
        self.hidden = true
        self.alpha = 0
        self.holder.frame.origin.y = self.frame.height
    }
    
    static func loadFromXib() -> PickerDateView {
        let instance = NSBundle.mainBundle().loadNibNamed("PickerDateView", owner: self, options: nil)!.first as! PickerDateView
        instance.frame = UIScreen.mainScreen().bounds
        instance.layoutIfNeeded()
        instance.configureUI()
        return instance
    }
}

