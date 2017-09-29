//
//  AdminView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/11/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import Foundation
import UIKit

class AdminView: UIView, UIScrollViewDelegate {
    
    var createBundleView:CreateBundleView!
    var createItineraryView:CreateItineraryView!
    
    @IBOutlet weak var holderView: UIScrollView!
    @IBAction func onClose(sender: AnyObject) {
        hide()
    }
    
    @IBAction func onCreateBundle(sender: AnyObject) {
        createBundleView.show()
    }
    
    @IBAction func onCreateItinerary(sender: AnyObject) {
        createItineraryView.show()
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
        
        createBundleView = CreateBundleView.loadFromXib()
        addSubview(createBundleView)
        
        createItineraryView = CreateItineraryView.loadFromXib()
        addSubview(createItineraryView)
        
        holderView.delegate = self
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    static func loadFromXib() -> AdminView {
        let instance = NSBundle.mainBundle().loadNibNamed("AdminView", owner: self, options: nil)!.first as! AdminView
        instance.frame = UIScreen.mainScreen().bounds
        instance.configureUI()
        return instance
    }
}




















