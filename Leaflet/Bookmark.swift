//
//  Bookmark.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 11/13/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit
import Parse

class Bookmark: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Bookmark"
    }
}
