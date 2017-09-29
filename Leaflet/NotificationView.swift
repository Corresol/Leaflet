//
//  NotificationView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/6/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class NotificationView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var emptyView: UILabel!
    
    var ListWidthOffset:CGFloat = 40
    var ListBottomMargin:CGFloat = 50
    var ListHorizontalOffset:CGFloat = 20
    
    var notificationList: UICollectionView!
    var itineraryView:ItineraryView!
    
    @IBOutlet weak var notificationListView:UIView!
    
    @IBAction func onClose(sender: AnyObject) {
        hide()
    }
    
    func onBookmark(button:UIButton) {
        let notification =  Session.notifications[button.tag]
        let itinerary = (notification["group"] as! EventGroup)["event"] as! EventDetail
        if Session.hasBookmarked(itinerary) {
            Session.removeBookmark(itinerary)
            AttentionView.displayBanner("Bookmark Removed!")
        }
        else {
            Session.addBookmark(itinerary)
            AttentionView.displayBanner("Bookmarked!")
        }
        self.notificationList.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let ackNotification = { () in
            let notification =  Session.notifications[indexPath.row]
            notification.setValue(true, forKey: "ack")
            notification.saveInBackgroundWithBlock { (saved, error) in
                Session.fetchNotifications({
                    mainQueue({
                        if Session.notifications.count > 0 {
                            self.emptyView.hidden = true
                        }
                        else {
                            self.emptyView.hidden = false
                        }
                        self.notificationList.reloadData()
                    })
                })
            }
        }
        
        let popup = PopupDialog(title: "Join Itinerary", message: "Would you like to join this itinerary?")
        let buttonOne = DefaultButton(title: "YES") {
            mainQueue({
                let notification =  Session.notifications[indexPath.row]
                let itinerary = (notification["group"] as! EventGroup)["event"] as! EventDetail
                let group = EventGroup()
                group.setObject(Session.me()!, forKey: "user")
                group.setObject(itinerary, forKey: "event")
                group.saveInBackgroundWithBlock({ (saved, error) in
                    
                    let attendee = EventAttendee()
                    attendee.setObject(Session.me()!, forKey: "user")
                    attendee.setObject(group, forKey: "group")
                    attendee.saveInBackground()
                    
                    mainQueue({
                        MainView.instance?.chatList.show()
                    })
                })
                
                ackNotification()
            })
        }
        let buttonTwo = DefaultButton(title: "NO") {
            mainQueue({
                ackNotification()
            })
        }
        popup.addButtons([buttonOne,buttonTwo])
        MainView.viewController!.presentViewController(popup, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Session.notifications.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let notification =  Session.notifications[indexPath.row]
        let itinerary = (notification["group"] as! EventGroup)["event"] as! EventDetail
        let locations = itinerary["locations"] as! [NSDictionary]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("InviteCollectionCell", forIndexPath: indexPath) as! InviteCollectionCell
        cell.bannerImage.nk_setImageWith(NSURL(string: itinerary["image"] as! String)!)
        cell.attendeeCountLabel.text = "\(itinerary["count_peoples"]!)"
        cell.priceLabel.text = "\(itinerary["estimated_cost"]!)"
        cell.categoryLabel.text = "\(itinerary["type_event"]!)"
        cell.nameLabel.text = "\(itinerary["title_event"]!)"
        cell.favoriteBtn.tag = indexPath.row
        cell.favoriteBtn.addTarget(self, action: #selector(onBookmark(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.favoriteBtn.setImage(cell.favoriteBtn.imageForState(.Normal)!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        
        if Session.hasBookmarked(itinerary) {
            cell.favoriteBtn.tintColor = ItineraryBookmarkedColor
        }
        else {
            cell.favoriteBtn.tintColor = ItineraryUnbookmarkedColor
        }
        
        cell.messageLabel.hidden = false
        cell.messageLabel.text = ""
        
        cell.remainingMessageLabel.hidden = true
        cell.remainingMessageLabel.text = ""
        
        if locations.count > 0 {
            let location:NSDictionary = locations[0]
            let address = location["address"] as! [String]
            cell.timeLabel.text = ""
            cell.locationLabel.text = location["neighborhood"] != nil ? "\(location["neighborhood"] as! String)" : "\(location["name"]!)"
        }
        else {
            cell.timeLabel.text = ""
            cell.locationLabel.text = ""
        }
        cell.descriptionLabel.text = "\(itinerary["description_event"]!)"
        
        if locations.count >= 1 {
            let location:NSDictionary = locations[0]
            let address = location["address"] as! [String]
            cell.locationOneHolder.hidden = false
            cell.locationOneName.text = "\(location["name"]!)"
            cell.locationOneAddress.text = address.count > 0 ? "\((location["address"] as! [String])[0])" : "\(location["neighborhood"]!)"
        }
        else {
            cell.locationOneHolder.hidden = true
            cell.locationOneName.text = ""
            cell.locationOneAddress.text = ""
        }
        
        if locations.count >= 2 {
            let location:NSDictionary = locations[1]
            let address = location["address"] as! [String]
            cell.locationTwoHolder.hidden = false
            cell.locationTwoName.text = "\(location["name"]!)"
            cell.locationTwoAddress.text = address.count > 0 ? "\((location["address"] as! [String])[0])" : "\(location["neighborhood"]!)"
        }
        else {
            cell.locationTwoHolder.hidden = true
            cell.locationTwoName.text = ""
            cell.locationTwoAddress.text = ""
        }
        
        if locations.count >= 3 {
            let location:NSDictionary = locations[2]
            let address = location["address"] as! [String]
            cell.locationThreeHolder.hidden = false
            cell.locationThreeName.text = "\(location["name"]!)"
            cell.locationThreeAddress.text = address.count > 0 ? "\((location["address"] as! [String])[0])" : "\(location["neighborhood"]!)"
        }
        else {
            cell.locationThreeHolder.hidden = true
            cell.locationThreeName.text = ""
            cell.locationThreeAddress.text = ""
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let currentCell = cell as! InviteCollectionCell
        
        currentCell.holderView.layer.masksToBounds = true
        currentCell.holderView.layer.cornerRadius = 10
        
        currentCell.holderShadowView.layer.shadowColor = UIColor.lightGrayColor().CGColor
        currentCell.holderShadowView.layer.shadowOffset = CGSizeMake(1, 1)
        currentCell.holderShadowView.layer.shadowRadius = 6
        currentCell.holderShadowView.layer.shadowOpacity = 1
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func show() {
        Session.fetchNotifications {
            mainQueue({
                if Session.notifications.count > 0 {
                    self.emptyView.hidden = true
                }
                else {
                    self.emptyView.hidden = false
                }
                self.notificationList.reloadData()
            })
        }
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = 0
        }
    }
    
    func hide() {
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = self.frame.height
        }
    }
    
    func configureUI() {
        frame.origin.y = frame.height
        notificationList = UICollectionView(frame: bounds, collectionViewLayout: { () -> UICollectionViewFlowLayout in
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSizeMake(bounds.width-ListWidthOffset, self.notificationListView.frame.height)
            layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
            layout.minimumLineSpacing = 5
            layout.minimumInteritemSpacing = 0
            return layout
        }())
        notificationList.frame.size.height = notificationList.frame.size.height-notificationListView.frame.origin.y
        notificationList.backgroundColor = UIColor.clearColor()
        notificationList.showsVerticalScrollIndicator = false
        notificationList.showsHorizontalScrollIndicator = false
        notificationList.delegate = self
        notificationList.dataSource = self
        notificationList.contentInset = UIEdgeInsets(top: 0, left: ListHorizontalOffset, bottom: 0, right: ListHorizontalOffset)
        notificationList.registerNib(UINib(nibName: "InviteCollectionCell", bundle: nil), forCellWithReuseIdentifier: "InviteCollectionCell")
        notificationListView.addSubview(notificationList)
        notificationListView.backgroundColor = UIColor.clearColor()
        
        itineraryView = ItineraryView.loadFromXib()
        addSubview(itineraryView)
    }
    
    static func loadFromXib() -> NotificationView {
        let instance = NSBundle.mainBundle().loadNibNamed("NotificationView", owner: self, options: nil)!.first as! NotificationView
        instance.frame = UIScreen.mainScreen().bounds
        instance.layoutIfNeeded()
        instance.configureUI()
        return instance
    }
}
