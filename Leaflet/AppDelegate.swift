//
//  AppDelegate.swift
//  Leaflet
//
//  Created by Dondrey Taylor on 8/14/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Parse
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var permissionNotifications:Permission = Permission.Notifications
    
    func registerForPushNotifications() {
        let application:UIApplication = UIApplication.sharedApplication()
        let userNotificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Track installations
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        // Google Maps
        GMSServices.provideAPIKey(GoogleSDKKey)
        
        // Sessions
        PFUser.enableRevocableSessionInBackground()
        
        // Installation data
        let installation = PFInstallation.currentInstallation()
        installation?["IOSVersion"] = iOSVersion
        installation?["SystemName"] = SystemName
        installation?["DeviceCountryCode"] = DeviceCountryCode
        
        // Persist user installation details
        installation?.saveInBackground()
        
        // Clear Push badge
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        // Register for push notification is permission was given
        if permissionNotifications.status == .Authorized {
            registerForPushNotifications()
        }
        
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let handled:Bool = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        return handled
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation?.setDeviceTokenFromData(deviceToken)
        installation?.channels = ["global"]
        installation?.saveInBackgroundWithBlock({ (saved, error) in
            if saved {
                print("Associated device token \(deviceToken) with installation \(installation?.objectId).")
            }
            else {
                print("Unable to associate device token \(deviceToken) with installation \(installation?.objectId).")
            }
        })
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

