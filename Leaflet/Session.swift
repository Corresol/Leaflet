//
//  Session.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/17/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import Foundation
import Parse
import FBSDKLoginKit

class Session: NSObject {
    
    static var user:User? = nil
    static var bookmarks:[EventBookmark] = []
    static var notifications:[EventNotification] = []
    static var groups:[EventGroup] = []
    static var onLocation:(()->Void)?
    static var onAccurateLocation:(()->Void)?
    static var permissionLocation:Permission = Permission.LocationAlways
    static var locationRequest:Request!
    static var location:UserLocation!
    static var coordinates:CLLocationCoordinate2D! = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    private static var locationTimer:NSTimer!
    private static var locationGeoCoder = CLGeocoder()
    
    static func me() -> User? {
        return user
    }
    
    static func isActive() -> Bool {
        return user != nil
    }
    
    static func destroy() {
        FBSDKLoginManager().logOut()
        Session.user = nil
    }
    
    static func startPollingLocation() {
        locationTimer?.invalidate()
        locationTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(pollForLocation), userInfo: nil, repeats: true)
    }
    
    static func pollForLocation() {
        if permissionLocation.status == .Authorized {
            locationRequest = Location.getLocation(withAccuracy: Accuracy.City, onSuccess: { (foundLocation) in
                    self.coordinates = foundLocation.coordinate
                    self.locationGeoCoder.reverseGeocodeLocation(foundLocation, completionHandler: { (placemarks, error) in
                        if error == nil && placemarks != nil && placemarks?.count > 0 {
                            let placeMark:CLPlacemark = placemarks![0]
                            
                            let userLocation = UserLocation()
                            userLocation.setValue(self.coordinates.latitude, forKey: "locationLatitude")
                            userLocation.setValue(self.coordinates.longitude, forKey: "locationLongitude")
                            
                            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                                userLocation.setValue(locationName, forKey: "locationName")
                            }
                            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                                userLocation.setValue(street, forKey: "locationThoroughfare")
                            }
                            if let city = placeMark.addressDictionary!["City"] as? NSString {
                                userLocation.setValue(city, forKey: "locationCity")
                            }
                            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                                userLocation.setValue(zip, forKey: "locationZIP")
                            }
                            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                                userLocation.setValue(country, forKey: "locationCountry")
                            }
                            
                            userLocation.saveInBackground()
                            self.location = userLocation
                            
                            self.onAccurateLocation?()
                        }
                    })
                }, onError: { (lastValidLocation, error) in
            })
        }
    }
    
    static func updateUserLocation() {
        if self.user != nil {
            let ipChecker = APPublicIP();
            ipChecker.getCurrentIP { (ip) -> Void in
                if ip != nil {
                    PFCloud.callFunctionInBackground("locationFromIP", withParameters: ["ip": ip!], block: { (response, error) in
                        if error == nil && response != nil {
                            let data = response! as! NSDictionary
                            Session.me()?.setValue(data, forKey: "location")
                            Session.me()?.setValue(data["locality"] as! String, forKey: "locality")
                            Session.me()?.saveInBackground()
                            self.onLocation?()
                        }
                    })
                }
            }
        }
    }
    
    static func inGroup(event:EventDetail) -> Bool {
        for group in Session.groups {
            if (group["event"] as! EventDetail).objectId! == event.objectId! {
                return true
            }
        }
        return false
    }
    
    static func fetchGroups(callback:(()->Void)) {
        let query = EventGroup.query()
        query?.whereKey("user", equalTo: Session.me()!)
        query?.includeKey("group")
        query?.includeKey("group.event")
        query?.includeKey("group.user")
        query?.includeKey("user")
        query?.includeKey("event")
        query?.findObjectsInBackgroundWithBlock({ (groups, error) in
            if error == nil {
                self.groups = groups as! [EventGroup]
                self.groups = self.groups.reverse()
                callback()
            }
            else {
                self.groups = []
                callback()
            }
        })
    }
    
    static func fetchNotifications(callback:(()->Void)) {
        let query = EventNotification.query()
        query?.whereKey("to", equalTo: Session.me()!)
        query?.whereKeyDoesNotExist("ack")
        query?.includeKey("group")
        query?.includeKey("group.event")
        query?.includeKey("group.user")
        query?.includeKey("to")
        query?.includeKey("from")
        query?.findObjectsInBackgroundWithBlock({ (notifications, error) in
            
            if error == nil {
                self.notifications = notifications as! [EventNotification]
                self.notifications = self.notifications.reverse()
            }
            else {
                self.notifications = []
            }
            
            mainQueue({
                if self.notifications.count > 0 {
                    MainView.instance?.menuView.notificationAlert.text = "\(self.notifications.count)"
                    MainView.instance?.menuView.notificationAlert.hidden = false
                }
                else {
                    MainView.instance?.menuView.notificationAlert.hidden = true
                }
            })
            
            callback()
            
        })
    }
    
    static func hasBookmarked(event:EventDetail) -> Bool {
        for bookmark in bookmarks {
            if (bookmark.objectForKey("event") as! EventDetail).objectId! == event.objectId! {
                return true
            }
        }
        return false
    }
    
    static func fetchBookmarks() {
        let query = EventBookmark.query()
        query?.limit = 1000
        query?.whereKey("user", equalTo: user!)
        query?.includeKey("event")
        query?.includeKey("user")
        query?.findObjectsInBackgroundWithBlock({ (bookmarks, error) in
            if error == nil {
                self.bookmarks = bookmarks as! [EventBookmark]
            }
        })
    }
    
    static func removeBookmark(event:EventDetail) {
        var removeIndex:Int = -1
        for (index,bookmark) in bookmarks.enumerate() {
            if (bookmark.objectForKey("event") as! EventDetail).objectId! == event.objectId! {
                removeIndex = index
                bookmark.deleteInBackground()
            }
        }
        
        if removeIndex != -1 {
            bookmarks.removeAtIndex(removeIndex)
        }
    }
    
    static func addBookmark(event:EventDetail) {
        let bookmark = EventBookmark()
        bookmark.setObject(Session.me()!, forKey: "user")
        bookmark.setObject(event, forKey: "event")
        bookmark.saveInBackgroundWithBlock { (saved, error) in
        }
        bookmarks.append(bookmark)
    }
}

