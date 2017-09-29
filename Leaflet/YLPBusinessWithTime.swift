//
//  YLPBusinessWithTime.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 11/16/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import Foundation

class YLPBusinessWithTime {
    
    var dateTime:String!
    var business:YLPBusiness!
    
    func useBusiness(business:YLPBusiness) {
        self.business = business
    }
    
    func useDateTime(time:String) {
        self.dateTime = time
    }
    
}
