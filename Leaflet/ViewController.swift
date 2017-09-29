//
//  ViewController.swift
//  Leaflet
//
//  Created by Dondrey Taylor on 8/14/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeApp()
    }
    
    func initializeApp() {
        
        // Configure App
        let app = App()
        app.configure()
        
        // App main view
        let mainView = MainView.loadFromXib()
        view.addSubview(mainView)
        
        // Globally set view controller
        MainView.viewController = self
        
        // Globally set instance of MainView
        MainView.instance = mainView
        
    }
}








