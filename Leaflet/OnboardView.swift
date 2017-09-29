//
//  OnboardView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/17/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import Foundation
import UIKit

class OnboardView: UIView {
    
    // Holds all views
    var holderView:UIView!
    
    // Onboarding flow
    var initialView:FBConnectView!
    var tourView:TutorialHolderView!
    var locationPermissionView:PermissionLocationView!
    var chooseTagView:ChooseTagView!
    var phoneVerifyView:PhoneVerifyView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func show() {
        initialView.player.play()
        UIView.animateWithDuration(DurationForUI, animations: {
                self.frame.origin.y = 0
            }) { (finished) in
        }
    }
    
    func hide() {
        initialView.player.pause()
        UIView.animateWithDuration(DurationForUI, animations: {
                self.frame.origin.y = self.frame.height
            }) { (finished) in
                self.displayViewAt(1)
                self.tourView.displayViewAt(0)
                self.phoneVerifyView.clear()
                self.chooseTagView.clear()
        }
    }
    
    func initializeTourView() {
        tourView = TutorialHolderView.loadFromXib()
        tourView.frame.origin.x = frame.width * 0
    }
    
    func initializeInitialView() {
        initialView = FBConnectView.loadFromXib()
        initialView.frame.origin.x = frame.width * 1
    }

    func initializePhoneVerifyView() {
        phoneVerifyView = PhoneVerifyView.loadFromXib()
        phoneVerifyView.frame.origin.x = frame.width * 2
    }
    
    func initializeLocationPermissionView() {
        locationPermissionView = PermissionLocationView.loadFromXib()
        locationPermissionView.frame.origin.x = frame.width * 3
    }

    func initializeChooseTagView() {
        chooseTagView = ChooseTagView.loadFromXib()
        chooseTagView.frame.origin.x = frame.width * 4
    }
    
    func initialize() {
        self.frame.origin.y = self.frame.height
        
        holderView = UIView(frame: bounds)
        addSubview(holderView)
        
        holderView.addSubview({ () -> UIView in
            self.initializeTourView()
            return tourView
        }())
        holderView.addSubview({ () -> UIView in
            self.initializeInitialView()
            return initialView
        }())
        holderView.addSubview({ () -> UIView in
            self.initializePhoneVerifyView()
            return phoneVerifyView
        }())
        holderView.addSubview({ () -> UIView in
            self.initializeLocationPermissionView()
            return locationPermissionView
        }())
        holderView.addSubview({ () -> UIView in
            self.initializeChooseTagView()
            return chooseTagView
        }())
        holderView.frame.size.width = frame.width * CGFloat(holderView.subviews.count)
    }
    
    func displayViewAt(index:CGFloat) {
        UIView.animateWithDuration(DurationForUI) { 
            self.holderView.frame.origin.x = -self.frame.width * index
        }
    }
    
    static func loadFromXib() -> OnboardView {
        let instance = OnboardView(frame:UIScreen.mainScreen().bounds)
        return instance
    }
}





