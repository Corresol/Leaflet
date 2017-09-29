//
//  Constants.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 8/14/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit
import Foundation

// App Configuration
let AppName:String              = "Leaf"

// App Static URLS
let HelpURL:String          = "http://joinleaf.com/faqs/"
let TermsURL:String         = "http://joinleaf.com/terms-conditions"
let PrivacyURL:String       = "http://joinleaf.com/privacy-policy"
let AppURL:String           = "https://itunes.apple.com/us/app/leaflets-reimagine-your-social/id1040588046?mt=8"

// Parse Configuration
let ParseApplicationId:String   = "leaflets"
let ParseClientKey:String       = ""
var ParseServerEndpoint:String  = ({ () -> String in
        return "http://api.getleaflets.co:1337/parse"
        //return "http://Dondreys-MacBook-Pro.local:1337/parse"
})()

// CDN
let CDNEndpoint:String          = "https://files.parsetfss.com/ff90d94d-2042-4d54-9d35-fde1dae44067/"

// Default User Icon
let DefaultUserIcon:String      = "\(CDNEndpoint)tfss-b533046c-a35e-40b7-819d-6b008bb6ceaa-userPic.jpg"

// Facebook
let FacebookAppId:String        = "420009571539693"

// Yelp Configuration
let YelpConsumerKey:String      = "vxKwwcR_NMQ7WaEiQBK_CA"
let YelpConsumerSecret:String   = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
let YelpToken:String            = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
let YelpTokenSecret:String      = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"

// Google SDK
//let GoogleSDKKey:String         = "AIzaSyCbvq29A0Jm2iYXIq2sajgRM0Nv9oQk6dY"
let GoogleSDKKey:String         = "AIzaSyBKYUNUjNavl2kA-k0n7sO137zL0xVAZTU"

// Animations
let DurationForUI:Double        = 0.2
let DurationForMenu:Double      = 0.2

// Header
let HeaderHeight:CGFloat        = 84

// Menu
let MenuOpenConstraint:CGFloat = 100

// Device
let Device = UIDevice.currentDevice()
let iOSVersion = NSString(string: Device.systemVersion).doubleValue
let SystemName = Device.systemName
let DeviceLocale = NSLocale.currentLocale()
let DeviceCountryCode:String = {
    let cc = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as! String?
    if cc == nil {
        return ""
    }
    else {
        return cc!
    }
}()


let ItineraryDescriptionLimit:Int = 250

let DefaultLocation:[String:String] = [
    "zipcode": "10002",
    "state_abbr": "NY",
    "latitude": "40.717040",
    "longitude": "-73.98700",
    "city": "New York",
    "state": "NY"
];

let StateAbbreviations:[String] = [
    "AL",
    "AK",
    "AZ",
    "AR",
    "CA",
    "CO",
    "CT",
    "DE",
    "FL",
    "GA",
    "HI",
    "ID",
    "IL",
    "IN",
    "IA",
    "KS",
    "KY",
    "LA",
    "ME",
    "MD",
    "MA",
    "MI",
    "MN",
    "MS",
    "MO",
    "MT",
    "NE",
    "NV",
    "NH",
    "NJ",
    "NM",
    "NY",
    "NC",
    "ND",
    "OH",
    "OK",
    "OR",
    "PA",
    "RI",
    "SC",
    "SD",
    "TN",
    "TX",
    "UT",
    "VT",
    "VA",
    "WA",
    "WV",
    "WI",
    "WY",
    "GU",
    "PR",
    "VI"
];




