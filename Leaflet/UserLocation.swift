//
//  UserLocation.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 11/16/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import Foundation
import Parse

class UserLocation: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "UserLocation"
    }
    
}
