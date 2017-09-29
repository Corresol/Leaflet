//
//  App.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/6/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit
import Foundation
import Parse

class App:NSObject {
    
    override init() {
        super.init()
    }
    
    func configure() {
        configureStatusBar()
        configureParse()
    }
    
    private func configureStatusBar() {
        UIApplication.sharedApplication().statusBarStyle = .Default
        UIApplication.sharedApplication().statusBarHidden = true
    }
    
    private func configureParse() {
        
        // Enable datastore
        Parse.enableLocalDatastore()
        
        // PFUser session
        PFUser.enableRevocableSessionInBackground()
        
        // Initialize Parse
        Parse.initializeWithConfiguration(ParseClientConfiguration {
            $0.applicationId = ParseApplicationId
            $0.clientKey = ParseClientKey
            $0.server = ParseServerEndpoint
        })
    }
}
