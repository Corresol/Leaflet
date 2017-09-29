//
//  ChooseBannerPreview.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/27/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class ChooseBannerPreview: UIView {

    @IBOutlet weak var preview: UIImageView!
    
    var onSelected:(()->Void)?
    
    @IBAction func onChoose(sender: AnyObject) {
        hideWithSelection()
    }
    
    @IBAction func onClose(sender: AnyObject) {
        hide()
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
    
    func hideWithSelection() {
        UIView.animateWithDuration(DurationForUI, animations: { 
                self.frame.origin.y = self.frame.height
            }) { (finished) in
                self.onSelected?()
        }
    }
    
    
    func configureUI() {
        frame.origin.y = frame.height
    }
    
    static func loadFromXib() -> ChooseBannerPreview {
        let instance = NSBundle.mainBundle().loadNibNamed("ChooseBannerPreview", owner: self, options: nil)!.first as! ChooseBannerPreview
        instance.frame = UIScreen.mainScreen().bounds
        instance.configureUI()
        return instance
    }
    
}
