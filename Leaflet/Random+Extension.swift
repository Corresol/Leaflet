//
//  Random+Extension.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 10/19/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import Foundation

extension Int {
    static func random() -> Int {
        return Int(arc4random())
    }
    
    static func random(range: Range<Int>) -> Int {
        return Int(arc4random_uniform(UInt32(range.endIndex - range.startIndex))) + range.startIndex
    }
}

extension Double {
    static func random() -> Double {
        return drand48()
    }
}
