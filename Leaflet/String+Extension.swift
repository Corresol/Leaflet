//
//  String+Extension.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 11/15/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import Foundation

extension String {
    
    func formatAsPhone() -> String {
        var newString = self.stringByReplacingOccurrencesOfString(" ", withString: "")
        newString = newString.stringByReplacingOccurrencesOfString("-", withString: "")
        newString = newString.stringByReplacingOccurrencesOfString(")", withString: "")
        newString = newString.stringByReplacingOccurrencesOfString("(", withString: "")
        if !newString.containsString("+") {
            newString = "+" + ("1" + newString).digitsOnly()
        }
        else {
            newString = "+" + (newString).digitsOnly()
        }
        return newString
    }
    
    func digitsOnly() -> String {
        let stringArray = self.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        let newString = stringArray.joinWithSeparator("")
        return newString
    }
}
