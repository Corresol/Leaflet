//
//  User.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 8/15/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import Foundation
import Parse

class User: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "User"
    }
    
    static func createFromFBUser(fbUser:FacebookUser, callback:(user:User)->Void) {
        let moment = YLMoment()
        let user = User()
        user.setObject(moment.format(), forKey: "created_at")
        user.setObject(moment.format(), forKey: "updated_at")
        user.setObject("", forKey: "username")
        user.setObject("", forKey: "session_token")
        user.setObject("", forKey: "hashed_password")
        user.setObject("", forKey: "perishable_token")
        user.setObject(false, forKey: "push_notifications")
        user.setObject(fbUser.valueForKey("email") as! String, forKey: "user_email")
        user.setObject(false, forKey: "is_admin")
        user.setObject(true, forKey: "email_notifications")
        user.setObject(fbUser.valueForKey("fbID") as! String, forKey: "fbID")
        user.setObject("", forKey: "education_history")
        user.setObject("", forKey: "bio")
        user.setObject("", forKey: "first_name")
        user.setObject("", forKey: "last_name")
        user.setObject("", forKey: "age_count")
        user.setObject(fbUser.valueForKey("name") as! String, forKey: "full_name")
        user.setObject(fbUser.valueForKey("icon") as! String, forKey: "image")
        user.setObject("", forKey: "gender")
        user.setObject("", forKey: "birthday")
        user.setObject(moment.format(), forKey: "lastMsgChecked")
        user.setObject(moment.format(), forKey: "lastNotificationsChecked")
        user.saveInBackgroundWithBlock { (saved, error) in
            callback(user: user)
        }
    }
    
    static func findByFacebookID(fbID:String, callback:(user:User?)->Void) {
        let query = User.query()
        query?.whereKey("fbID", equalTo: fbID)
        query?.findObjectsInBackgroundWithBlock({ (users, error) in
            if error == nil && users?.count > 0 {
                callback(user: users![0] as? User)
            }
            else {
                callback(user: nil)
            }
        })
    }
    
    static func fetchByID(id:String, callback:(user:PFObject?, error:NSError?)->Void) {
        let query = User.query()
        query?.getObjectInBackgroundWithId(id) { (user, error) in
            callback(user: user, error: error)
        }
    }
}



