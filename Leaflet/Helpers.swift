//
//  Helpers.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 10/23/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import Foundation
import UIKit

var mainQueue = { (callback:(()->Void)) in
    dispatch_async(dispatch_get_main_queue()) {
        callback()
    }
}

var delay = { (delay:Double, closure:()->()) in
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}


var generateID = { () -> String in
    return NSUUID().UUIDString
}
