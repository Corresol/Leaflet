//
//  EventBundle.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 11/13/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit
import Parse

class EventBundle: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "EventBundle"
    }
    
    static func findAll(callback:(bundles:[EventBundle])->Void) {
        let query = PFQuery(className: "EventBundle")
        query.whereKeyExists("banner")
        query.includeKey("events")
        query.findObjectsInBackgroundWithBlock { (bundles, error) in
            if error == nil && bundles != nil {
                callback(bundles: bundles as! [EventBundle])
            }
            else {
                callback(bundles: [])
            }
        }
    }
    
    static func excludeEmptyBundles(bundles:[EventBundle]) -> [EventBundle] {
        var _bundles:[EventBundle] = []
        for bundle in bundles {
            if (bundle.objectForKey("events") as! NSMutableArray).count > 0 {
                _bundles.append(bundle)
            }
        }
        return _bundles
    }
}

