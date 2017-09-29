//
//  IntermediaryView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 11/9/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class IntermediaryView: UIView {
    
    func show() {
        self.hidden = false
        UIView.animateWithDuration(DurationForUI, animations: { 
                self.alpha = 1
            }) { (finished) in
        }
    }
    
    func hide() {
        UIView.animateWithDuration(DurationForUI, animations: { 
                self.alpha = 0
            }) { (finished) in
                self.hidden = true
        }
    }
    
    static func loadFromXib() -> IntermediaryView {
        let instance = NSBundle.mainBundle().loadNibNamed("IntermediaryView", owner: self, options: nil)!.first as! IntermediaryView
        instance.frame = UIScreen.mainScreen().bounds
        instance.layoutIfNeeded()
        return instance
    }
}
