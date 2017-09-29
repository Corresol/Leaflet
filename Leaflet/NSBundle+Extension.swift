//
//  NSBundle+Extension.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 10/23/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import Foundation

extension NSBundle {
    
    var releaseVersionNumber: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
    }
    
}
