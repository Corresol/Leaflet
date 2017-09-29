//
//  FBUser.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/11/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import Foundation
import Parse

class FacebookUser: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "FacebookUser"
    }
}