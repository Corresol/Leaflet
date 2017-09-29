//
//  ItinerariesView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/27/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class ItinerariesView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var holder:UIView!
    @IBAction func onClose(sender: AnyObject) {
        hide()
    }
    
    var bundle:EventBundle!
    var ListWidthOffset:CGFloat = 40
    var ListBottomMargin:CGFloat = 50
    var ListHorizontalOffset:CGFloat = 20
    var list: UICollectionView!
    var itineraryView:ItineraryView!
    var bookmarkPopup:PopupDialog!
    var buttonOne:DefaultButton!
    
    func onBookmark(button:UIButton) {
        let itinerary = ((bundle!.objectForKey("events") as! NSMutableArray).reverse())[button.tag] as! EventDetail
        if Session.hasBookmarked(itinerary) {
            Session.removeBookmark(itinerary)
            AttentionView.displayBanner("Bookmark Removed!")
        }
        else {
            Session.addBookmark(itinerary)
            AttentionView.displayBanner("Bookmarked!")
        }
        self.list.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func useBundle(bundle:EventBundle) {
        self.bundle = bundle
        self.list.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let itinerary = ((bundle!.objectForKey("events") as! NSMutableArray).reverse())[indexPath.row] as! EventDetail
        itineraryView.show(itinerary)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if bundle != nil {
            return (bundle!.objectForKey("events") as! NSMutableArray).count
        }
        else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let createdAt = bundle!.createdAt! as NSDate
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE, MMMM dd"
        
        let itinerary = ((bundle!.objectForKey("events") as! NSMutableArray).reverse())[indexPath.row] as! EventDetail
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
        
        cell.remainingMessageLabel.hidden = false
        cell.remainingMessageLabel.text = NSString(format: "%@", dateFormat.stringFromDate(createdAt)) as String
        
        if locations.count > 0 {
            let location:NSDictionary = locations[0]
            cell.timeLabel.text = ""
            cell.locationLabel.text = location["neighborhood"] != nil ? "\(location["neighborhood"] as! String)" : "\(location["name"]!), \((location["address"] as! [String])[0])"
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
        list = UICollectionView(frame: holder.bounds, collectionViewLayout: { () -> UICollectionViewFlowLayout in
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSizeMake(bounds.width-ListWidthOffset, self.holder.frame.height)
            layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
            layout.minimumLineSpacing = 5
            layout.minimumInteritemSpacing = 0
            return layout
        }())
        list.backgroundColor = UIColor.clearColor()
        list.showsVerticalScrollIndicator = false
        list.showsHorizontalScrollIndicator = false
        list.delegate = self
        list.dataSource = self
        list.contentInset = UIEdgeInsets(top: 0, left: ListHorizontalOffset, bottom: 0, right: ListHorizontalOffset)
        list.registerNib(UINib(nibName: "InviteCollectionCell", bundle: nil), forCellWithReuseIdentifier: "InviteCollectionCell")
        holder.addSubview(list)
        list.backgroundColor = UIColor.clearColor()
        
        itineraryView = ItineraryView.loadFromXib()
        addSubview(itineraryView)
        
        headerView.layer.masksToBounds = false
        headerView.layer.shadowOffset = CGSizeMake(0, 2);
        headerView.layer.shadowRadius = 5
        headerView.layer.shadowOpacity = 0.2;
        headerView.layer.addSublayer({ () -> CALayer in
            let border = CALayer()
            border.frame = CGRectMake(0, 0, frame.width, 1)
            border.frame.origin.y = headerView.frame.height - border.frame.height
            border.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor
            return border
        }())
        
    }
    
    static func loadFromXib() -> ItinerariesView {
        let instance = NSBundle.mainBundle().loadNibNamed("ItinerariesView", owner: self, options: nil)!.first as! ItinerariesView
        instance.frame = UIScreen.mainScreen().bounds
        instance.layoutIfNeeded()
        instance.configureUI()
        return instance
    }
}
