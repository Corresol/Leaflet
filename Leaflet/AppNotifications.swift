//
//  AppNotifications.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 11/15/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import Foundation
import Parse

class AppNotifications: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "AppNotifications"
    }
}
