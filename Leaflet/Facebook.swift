//
//  FacebookLogin.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/9/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import Foundation
import UIKit
import Parse

import FBSDKCoreKit
import FBSDKLoginKit

class Facebook:NSObject, FBSDKLoginButtonDelegate {
    
    static let readPermissions:[String] = ["public_profile", "email", "user_friends"]
    private let buttonWidth:CGFloat = 200
    private let buttonHeight:CGFloat = 50
    
    var onLogout:(()->Void)?
    var onLogin:((fbUser:FacebookUser?)->Void)?
    var onCancel:(()->Void)?
    var onError:((error:NSError)->Void)?
    
    override init() {
        super.init()
    }
    
    func isLoggedIn() -> Bool {
        return FBSDKAccessToken.currentAccessToken() != nil
    }
    
    func getButton() -> FBSDKLoginButton  {
        let button = FBSDKLoginButton(frame: CGRectMake(0,0,buttonWidth,buttonHeight))
        button.readPermissions = Facebook.readPermissions
        button.delegate = self
        return button
    }
    
    func retrieveUser(callback:(fbUser:FacebookUser)->Void) {
        
        let fbUser = FacebookUser()
        var fbCount = 0;
        let fbMaxCount = 2
        let permissions = FBSDKAccessToken.currentAccessToken().permissions
        
        if permissions != nil && permissions.count > 0 {
            if permissions.contains("public_profile") {
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,picture.width(480).height(480)"]).startWithCompletionHandler({ (connection, result, error) in
                    if error == nil {
                        if result.valueForKey("id") != nil {
                            fbUser.setObject(result.valueForKey("id") as! String, forKey:"fbID")
                        }
                        else {
                            fbUser.setObject("", forKey: "fbID")
                        }
                        
                        if result.valueForKey("name") != nil {
                            fbUser.setObject(result.valueForKey("name") as! String, forKey:"name")
                        }
                        else {
                            fbUser.setObject("", forKey: "name")
                        }
                        
                        if result.valueForKey("email") != nil {
                            fbUser.setObject(result.valueForKey("email") as! String, forKey:"email")
                        }
                        else {
                            fbUser.setObject("", forKey: "email")
                        }
                        
                        if result.valueForKey("picture") != nil {
                            let picture = (result.valueForKey("picture") as! NSDictionary)["data"]  as! NSDictionary
                            fbUser.setObject(picture["url"] as! String, forKey:"icon")
                        }
                        else {
                            fbUser.setObject("", forKey: "icon")
                        }
                    }
                    fbCount += 1
                    if fbCount == fbMaxCount {
                        callback(fbUser: fbUser)
                    }
                })
            }
            else {
                fbCount += 1
            }
            
            if permissions.contains("user_friends") {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                let url = "https://graph.facebook.com/v2.7/me/taggable_friends?limit=100&access_token="+accessToken
                do {
                    let opt = try HTTP.GET(url)
                    opt.start { response in
                        let data = JSON(string: response.text!)
                        let friends = data["data"]
                        
                        /*
                        var fbFriends:[NSDictionary] = []
                        if friends != nil {
                            for friend in friends.asArray! {
                                fbFriends.append([
                                    "id": friend["id"].asString!,
                                    "picture": friend["picture"]["data"]["url"].asString!,
                                    "is_silhouette": friend["picture"]["data"]["is_silhouette"].asBool!,
                                    "name": friend["name"].asString!
                                ])
                            }
                        }
                        fbUser.setObject(fbFriends, forKey: "friends")
                        */
                        
                        fbCount += 1
                        if fbCount == fbMaxCount {
                            callback(fbUser: fbUser)
                        }
                    }
                }
                catch _ {
                    fbCount += 1
                    if fbCount == fbMaxCount {
                        callback(fbUser: fbUser)
                    }
                }
            }
            else {
                fbCount += 1
                if fbCount == fbMaxCount {
                    callback(fbUser: fbUser)
                }
            }
        }
    }
    
    internal func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            onError?(error: error)
        }
        else if result.isCancelled {
            FBSDKLoginManager().logOut()
            onCancel?()
        }
        else {
            retrieveUser({ (fbUser) in
                self.onLogin?(fbUser: fbUser)
            })
        }
    }
    
    internal func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        onLogout?()
    }
    
    func findByFacebookID(fbID:String, callback:(fbUser:FacebookUser?)->Void) {
        let query = FacebookUser.query()
        query?.whereKey("fbID", equalTo: fbID)
        query?.findObjectsInBackgroundWithBlock({ (fbUsers, error) in
            if error == nil && fbUsers?.count > 0 {
                callback(fbUser: fbUsers![0] as? FacebookUser)
            }
            else {
                callback(fbUser: nil)
            }
        })
    }
}




