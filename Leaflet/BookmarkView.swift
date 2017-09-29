//
//  BookmarkView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/26/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class BookmarkView: UIView, UICollectionViewDelegate, UICollectionViewDataSource  {

    var list:UICollectionView!
    var BookmarkWidthOffset:CGFloat = 60
    var BookmarkBottomMargin:CGFloat = 50
    var BookmarkHorizontalOffset:CGFloat = 20
    var itineraryView:ItineraryView!
   
    @IBOutlet weak var bookmarkListView: UIView!
    @IBOutlet weak var emptyView: UILabel!
    @IBAction func onClose(sender: AnyObject) {
        hide()
    }
    
    func show() {
        self.list.reloadData()
        if Session.bookmarks.count == 0 {
            self.emptyView.hidden = false
        }
        else {
            self.emptyView.hidden = true
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let itinerary = Session.bookmarks[indexPath.row].objectForKey("event") as! EventDetail
        itineraryView.show(itinerary)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Session.bookmarks.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let itinerary = Session.bookmarks[indexPath.row].objectForKey("event") as! EventDetail
        let locations = itinerary["locations"] as! [NSDictionary]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("InviteCollectionCell", forIndexPath: indexPath) as! InviteCollectionCell
        cell.bannerImage.nk_setImageWith(NSURL(string: itinerary["image"] as! String)!)
        cell.attendeeCountLabel.text = "\(itinerary["count_peoples"]!)"
        cell.priceLabel.text = "\(itinerary["estimated_cost"]!)"
        cell.categoryLabel.text = "\(itinerary["type_event"]!)"
        cell.nameLabel.text = "\(itinerary["title_event"]!)"
        cell.favoriteBtn.tag = indexPath.row
        cell.favoriteBtn.hidden = true
        
        cell.messageLabel.hidden = false
        cell.messageLabel.text = ""
        
        cell.remainingMessageLabel.hidden = false
        cell.remainingMessageLabel.text = ""
        
        if locations.count > 0 {
            let location:NSDictionary = locations[0]
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
    
    func configureUI() {
        frame.origin.y = frame.height
        
        list = UICollectionView(frame: bounds, collectionViewLayout: { () -> UICollectionViewFlowLayout in
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSizeMake(bounds.width-BookmarkWidthOffset, bookmarkListView.frame.height)
            layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
            layout.minimumLineSpacing = 5
            layout.minimumInteritemSpacing = 0
            return layout
        }())
        list.frame.size.height = bookmarkListView.frame.size.height
        list.backgroundColor = UIColor.clearColor()
        list.showsVerticalScrollIndicator = false
        list.showsHorizontalScrollIndicator = false
        list.delegate = self
        list.dataSource = self
        list.contentInset = UIEdgeInsets(top: 0, left: BookmarkHorizontalOffset, bottom: 0, right: BookmarkHorizontalOffset)
        list.registerNib(UINib(nibName: "InviteCollectionCell", bundle: nil), forCellWithReuseIdentifier: "InviteCollectionCell")
        list.backgroundColor = UIColor.clearColor()
        bookmarkListView.insertSubview(list, belowSubview: emptyView)
        
        itineraryView = ItineraryView.loadFromXib()
        addSubview(itineraryView)
        
    }
    
    static func loadFromXib() -> BookmarkView {
        let instance = NSBundle.mainBundle().loadNibNamed("BookmarkView", owner: self, options: nil)!.first as! BookmarkView
        instance.frame = UIScreen.mainScreen().bounds
        instance.layoutIfNeeded()
        instance.configureUI()
        return instance
    }
}


