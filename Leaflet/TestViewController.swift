//
//  ViewController.swift
//  Leaflet
//
//  Created by Dondrey Taylor on 8/14/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit
import Parse

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let app = App()
        app.configure()
        
        view.addSubview({ () -> UIView in
            return FBConnectView.loadFromXib()
            }())
        
        
        //        view.addSubview({ () -> UIView in
        //            let tutorial:TutorialView = TutorialView.loadFromXib()
        //            tutorial.configureUI(UIImage(named: "onboard-image-tutorial-1")!, heading: "Personalized\nRecommendations", text: "Discover curated itineraries for any day, any time. Itineraries are based on your preferences.")
        //            tutorial.tutorialHeadingLabelHeightConstraint.constant = 66
        //            return tutorial
        //        }())
        
        //        view.addSubview({ () -> UIView in
        //            let tutorial:TutorialView = TutorialView.loadFromXib()
        //            tutorial.configureUI(UIImage(named: "onboard-image-tutorial-2")!, heading: "Find out who’s coming", text: "Share your chosen itinerary with your friends or Leaflets will find a small group nearby to join you.")
        //            return tutorial
        //        }())
        
        //        view.addSubview({ () -> UIView in
        //            let tutorial:TutorialView = TutorialView.loadFromXib()
        //            tutorial.configureUI(UIImage(named: "onboard-image-tutorial-3")!, heading: "Less Planning, More Doing", text: "Once all attendees have confirmed, a group chat opens. Since the plans have already been made, you can chat about anything other than when and where.")
        //            return tutorial
        //        }())
        
        //        view.addSubview({ () -> UIView in
        //            let cv = CategoriesView(frame: view.bounds)
        //            cv.addCategory(Category(name: "New in Town", bannerURL: NSURL(string: "https://www.caesars.com/content/scaffold_pages/restaurant/rio/rlv/en/all_american_bar_and/_jcr_content/cards/card/slides2.stdimg.hd.l.cover.jpg/1385412127250.jpg")!))
        //            cv.addCategory(Category(name: "Festivals", bannerURL: NSURL(string: "http://obfessed.com/wp-content/uploads/2015/05/festivalgirl.jpg")!))
        //            cv.addCategory(Category(name: "Night Life", bannerURL: NSURL(string: "http://img.timeinc.net/time/photoessays/2008/vegas/vegas_club.jpg")!))
        //            cv.addCategory(Category(name: "Sports", bannerURL: NSURL(string: "https://i.ytimg.com/vi/mNNj3WoPI6s/maxresdefault.jpg")!))
        //            cv.addCategory(Category(name: "Shows", bannerURL: NSURL(string: "http://www.theepochtimes.com/n3/eet-content/uploads/2014/01/2014.01.11Dai-Bing-1024x683.jpg")! ))
        //            cv.addCategory(Category(name: "Attractions", bannerURL: NSURL(string: "http://www.hercampus.com/sites/default/files/2013/10/29/cedar-park-1040cs060612.jpg")! ))
        //            cv.addCategory(Category(name: "Local Favorites", bannerURL: NSURL(string: "https://media-cdn.tripadvisor.com/media/photo-s/09/fc/2e/f4/our-menu-features-local.jpg")! ))
        //            return cv
        //        }())
        
        
        //          view.addSubview({ () -> UIView in
        //                let fv = FriendsView.loadFromXib()
        //
        //                fv.addFriend(User(name: "Esther Crawford", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/esthercrawford/128.jpg")!))
        //                fv.addFriend(User(name: "Matt Surguy", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/msurguy/128.jpg")!))
        //                fv.addFriend(User(name: "Chad Lee", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/ok/128.jpg")!))
        //                fv.addFriend(User(name: "Allison Grayce", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/allisongrayce/128.jpg")!))
        //                fv.addFriend(User(name: "Jennifer Cho", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/uxceo/128.jpg")!))
        //                fv.addFriend(User(name: "Eva Giselle", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/evagiselle/128.jpg")!))
        //                fv.addFriend(User(name: "Lilly Lee", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/ladylexy/128.jpg")!))
        //                fv.addFriend(User(name: "Krystyn Heide", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/krystynheide/128.jpg")!))
        //                fv.addFriend(User(name: "Tom Claro", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/teclaro/128.jpg")!))
        //                fv.addFriend(User(name: "Tim Clancy", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/teleject/128.jpg")!))
        //                fv.addFriend(User(name: "Darrell White", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/darrellwhitelaw/128.jpg")!))
        //
        //
        //                fv.addRecommended(User(name: "", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/marktimemedia/128.jpg")!))
        //                fv.addRecommended(User(name: "", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/myusuf3/128.jpg")!))
        //                fv.addRecommended(User(name: "", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/hvpandya/128.jpg")!))
        //                fv.addRecommended(User(name: "", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/raquelromanp/128.jpg")!))
        //                fv.addRecommended(User(name: "", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/skeletonkey/128.jpg")!))
        //                fv.addRecommended(User(name: "", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/adellecharles/128.jpg")!))
        //                fv.addRecommended(User(name: "", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/mizko/128.jpg")!))
        //                fv.addRecommended(User(name: "", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/nzcode/128.jpg")!))
        //                fv.addRecommended(User(name: "", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/jina/128.jpg")!))
        //                fv.addRecommended(User(name: "", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/peterme/128.jpg")!))
        //                fv.addRecommended(User(name: "", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/chadengle/128.jpg")!))
        //                fv.addRecommended(User(name: "", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/sindresorhus/128.jpg")!))
        //                fv.addRecommended(User(name: "", iconURL: NSURL(string: "https://s3.amazonaws.com/uifaces/faces/twitter/kfriedson/128.jpg")!))
        //
        //                return fv
        //          }())
        
        //            view.addSubview({ () -> UIView in
        //                return ItineraryView.loadFromXib()
        //            }())
        
        //            view.addSubview({ () -> UIView in
        //                return NotificationView.loadFromXib()
        //            }())
        
        
        
        //            view.addSubview({ () -> UIView in
        //                return ChooseTagView.loadFromXib()
        //            }())
        //
        //            view.addSubview({ () -> UIView in
        //                return HeaderView.loadFromXib()
        //            }())
        
        
        //        view.addSubview({ () -> UIView in
        //            return TutorialHolderView.loadFromXib()
        //        }())
        
        //        view.addSubview({ () -> UIView in
        //            return PermissionLocationView.loadFromXib()
        //        }())
        
        //            view.addSubview({ () -> UIView in
        //                return PermissionContactsView.loadFromXib()
        //            }())
        
        
        //        let session = Session()
        //        session.fetchUserByFBID("0NheGXDpRg") { (user, error) in
        //        }
        
        let FB = Facebook()
        if FB.isLoggedIn() {
            FB.retrieveUser({ (fbUser) in
                print(fbUser.objectForKey("name"))
                print(fbUser.objectForKey("email"))
                print(fbUser.mutableArrayValueForKey("friends").count)
                
                FB.findByFacebookID(fbUser.objectForKey("fbID") as! String, callback: { (me) in
                    if me == nil {
                        fbUser.saveInBackgroundWithBlock({ (saved, error) in
                            print(saved)
                            print(error)
                        })
                    }
                    else {
                    }
                })
            })
        }
        else {
            print("Not Logged in")
        }
        
    }
}

