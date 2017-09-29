//
//  MainView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/18/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import Foundation
import UIKit
import Parse

class MainView: UIView {

    var profileView:ProfileView!
    var adminView:AdminView!
    var bookmarkView:BookmarkView!
    var notificationView:NotificationView!
    var friendsView:FriendsView!
    var helpView:HelpView!
    var settingsView:SettingsView!
    var menuView:MenuView!
    var headerView:HeaderView!
    var onboardView:OnboardView!
    var bundlesView:BundlesView!
    var itinerariesView:ItinerariesView!
    var locationRequest:LocationRequestView!
    var pushPermission:PermissionPushView!
    var chatList:ChatListView!
    var chatView:ChatView!
    
    static var viewController:UIViewController? = nil
    static var instance:MainView? = nil
    
    
    func initialize() {
        
        // Bundles
        bundlesView = BundlesView.loadFromXib()
        addSubview(bundlesView)
        
        // Header
        headerView = HeaderView.loadFromXib()
        addSubview(headerView)
        headerView.titleLabel.text = "Discover"
        headerView.subTitleLabel.text = ""
        headerView.rightBtn.hidden = false
        headerView.onRightNav = {
            if Session.me() != nil {
                self.chatList.show()
            }
            else {
                MainView.instance?.onboardView.show()
            }
        }
        headerView.onLeftNav = { () in
            if Session.me() != nil {
                self.menuView.show()
            }
            else {
                MainView.instance?.onboardView.show()
            }
        }
        
        // Itineraries
        itinerariesView = ItinerariesView.loadFromXib()
        addSubview(itinerariesView)
        
        // Request Itineraries
        locationRequest = LocationRequestView.loadFromXib()
        addSubview(locationRequest)
        
        // Menu Profile
        profileView = ProfileView.loadFromXib()
        addSubview(profileView)
        
        /// Menu Bookmarks
        bookmarkView = BookmarkView.loadFromXib()
        addSubview(bookmarkView)
        
        // Menu Notifications
        notificationView = NotificationView.loadFromXib()
        addSubview(notificationView)
        
        // Menu Friends
        friendsView = FriendsView.loadFromXib()
        addSubview(friendsView)
        
        // Menu Settings
        settingsView = SettingsView.loadFromXib()
        addSubview(settingsView)
        
        // Menu Help
        helpView = HelpView.loadFromXib()
        addSubview(helpView)
        
        // Menu
        menuView = MenuView.loadFromXib()
        addSubview(menuView)
        
        // Admin
        adminView = AdminView.loadFromXib()
        addSubview(adminView)
        
        // Push permission
        pushPermission = PermissionPushView.loadFromXib()
        addSubview(pushPermission)
        
        // Chats
        chatList = ChatListView.loadFromXib()
        addSubview(chatList)
        
        chatView = ChatView.loadFromXib()
        addSubview(chatView)
        
        // Onboarding
        onboardView = OnboardView.loadFromXib()
        addSubview(onboardView)
        
        // Displayed while user is being fetched from DB
        let intermediaryView = IntermediaryView.loadFromXib()
        addSubview(intermediaryView)
        
        // We'll create shorthand references to increase readability
        let FB = onboardView.initialView.FB
        let ON = onboardView
       
       // Handle Facebook Login Events
        FB.onLogin = { (fbUser) in
            if fbUser != nil {
                User.findByFacebookID(fbUser!.valueForKey("fbID") as! String, callback: { (user) in
                    if user != nil {
                        Session.user = user
                        let installation = PFInstallation.currentInstallation()
                        installation?["user"] = user
                        installation?["userID"] = user!.objectId!
                        installation?.saveInBackground()
                        
                        //ON.displayViewAt(2)
                        
                        ON.hide()
                        self.updateSessionDependentUI()
                    }
                    else {
                        ON.displayViewAt(2)
                        User.createFromFBUser(fbUser!, callback: { (user) in
                            Session.user = user
                            let installation = PFInstallation.currentInstallation()
                            installation?["user"] = user
                            installation?["userID"] = user.objectId!
                            installation?.saveInBackground()
                        })
                    }
                })
            }
        }
        FB.onLogout = { () in
            ON.displayViewAt(0) // Go to login
        }
        FB.onError = { (error) in
        }
        
        // Check for user login state and show relevant screens
        if FB.isLoggedIn() {
            FB.retrieveUser({ (fbUser) in
                User.findByFacebookID(fbUser.valueForKey("fbID") as! String, callback: { (user) in
                    intermediaryView.hide()
                    if user != nil {
                        Session.user = user
                        let installation = PFInstallation.currentInstallation()
                        installation?["user"] = user
                        installation?["userID"] = user!.objectId!
                        installation?.saveInBackground()
                        
                        ON.hide()
                        self.updateSessionDependentUI()
                        delay(DurationForUI) {
                            if self.pushPermission.shouldShow() {
                                self.pushPermission.show()
                            }
                        }
                    }
                    else {
                        ON.displayViewAt(2)
                        User.createFromFBUser(fbUser, callback: { (user) in
                            Session.user = user
                        })
                    }
                })
            })
        }
        else {
            intermediaryView.hide()
            ON.show()
        }
        
        // Handle Skip
        ON.initialView.onSkip = { () in
            MainView.instance?.bundlesView.pullBundles()
            ON.hide()
        }
        
        // Handle Tour
        ON.tourView.onSkip = { () -> Void in
            ON.displayViewAt(1)
            delay(0.5) {
                ON.tourView.reset()
            }
        }
        
        ON.tourView.onTourBeforeAfter = { (position) in
            if position == TutorialHolderViewPosition.AfterLast {
                ON.displayViewAt(1) // Initial screen
            }
        }
        
        // Phone
        ON.phoneVerifyView.onVerified = { phoneNumber in
            Session.me()?["verified"] = true
            Session.me()?["phone"] = phoneNumber.formatAsPhone()
            Session.me()?.saveInBackground()
            ON.displayViewAt(3)
        }
        
        // Handle Location
        ON.locationPermissionView.onNext = { (status) in
           ON.displayViewAt(4)
        }
        
        // Handle Choose Tag
        ON.chooseTagView.onNext = { () in
            Session.me()?["tags"] = ON.chooseTagView.tagsSelected
            Session.me()?.saveInBackground()
            
            ON.hide()
            self.updateSessionDependentUI()
            delay(DurationForUI) {
                if self.pushPermission.shouldShow() {
                    self.pushPermission.show()
                }
            }
        }
    }
    
    func updateSessionDependentUI() {
        if Session.me() != nil {
            
            // Update Menu
            menuView.useIcon(Session.me()!["image"] as! String)
            menuView.useName(Session.me()!["full_name"] as! String)
            
            // Update Settings
            settingsView.fieldName.text = Session.me()!["full_name"] as? String
            settingsView.fieldEmail.text = Session.me()!["user_email"] as? String
            settingsView.fieldAccount.text = "Standard"
            settingsView.fieldVersion.text = "\(NSBundle.mainBundle().releaseVersionNumber!).\(NSBundle.mainBundle().buildVersionNumber!)"
            
            // Update Recommended
            friendsView.populateRecommended()
            
            // Bookmarks
            Session.fetchBookmarks()
            
            // Update location
            Session.updateUserLocation()
            
            // Fetch bundles
            bundlesView.pullBundles()
            
            // Fetch groups
            Session.fetchGroups({ 
            })
            
            // Fetch Notifications
            Session.fetchNotifications({ 
            })
            
            // Set Location Request
            Session.onAccurateLocation = {
                mainQueue({
                    self.locationRequest.setAccurateLocation()
                })
            }
            
            // Set Location
            Session.onLocation = {
                mainQueue({
                    self.locationRequest.setLocation()
                })
            }
            
            // Start location
            Session.startPollingLocation()
            
        }
    }
    
    static func loadFromXib() -> MainView {
        let instance = NSBundle.mainBundle().loadNibNamed("MainView", owner: self, options: nil)!.first as! MainView
        instance.frame = UIScreen.mainScreen().bounds
        instance.initialize()
        return instance
    }
}



