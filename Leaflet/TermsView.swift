//
//  TermsView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/26/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class TermsView: UIView {
    
    @IBOutlet weak var webView:UIWebView!
    
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
    
    func configureUI() {
        frame.origin.y = frame.height
        webView.loadRequest(NSURLRequest(URL: NSURL(string: TermsURL)!))
    }
    
    static func loadFromXib() -> TermsView {
        let instance = NSBundle.mainBundle().loadNibNamed("TermsView", owner: self, options: nil)!.first as! TermsView
        instance.frame = UIScreen.mainScreen().bounds
        instance.configureUI()
        return instance
    }
}

