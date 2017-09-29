//
//  ItineraryView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 8/16/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit
import GoogleMaps

class ItineraryView: UIView {
    
    var itinerary:EventDetail!
    var mapView:MapView!
    
    @IBOutlet weak var scrollableView: UIScrollView!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    @IBOutlet weak var bannerImage:UIImageView!
    @IBOutlet weak var attendeeCountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var locationOneHolder: UIView!
    @IBOutlet weak var locationOneName: UILabel!
    @IBOutlet weak var locationOneAddress: UILabel!
    
    @IBOutlet weak var locationTwoHolder: UIView!
    @IBOutlet weak var locationTwoName: UILabel!
    @IBOutlet weak var locationTwoAddress: UILabel!
    
    @IBOutlet weak var locationThreeHolder: UIView!
    @IBOutlet weak var locationThreeName: UILabel!
    @IBOutlet weak var locationThreeAddress: UILabel!
    
    @IBOutlet weak var locationFourHolder: UIView!
    @IBOutlet weak var locationFourName: UILabel!
    @IBOutlet weak var locationFourAddress: UILabel!
    
    @IBOutlet weak var locationFiveHolder: UIView!
    @IBOutlet weak var locationFiveName: UILabel!
    @IBOutlet weak var locationFiveAddress: UILabel!
    
    var LocationsFiveHeight:CGFloat = 450
    var LocationsFourHeight:CGFloat = 380
    var LocationsThreeHeight:CGFloat = 320
    var LocationsTwoHeight:CGFloat = 260
    var LocationsOneHeight:CGFloat = 200
    var LocationsNoneHeight:CGFloat = 140
    
    @IBOutlet weak var locationsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var map: UIView!
    @IBAction func onClose(sender: AnyObject) {
        hide()
    }
    
    @IBAction func onCloseButton(sender: AnyObject) {
        hide()
    }
    
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var actionView: UIView!
    @IBAction func onAction(sender: AnyObject) {
        mainQueue({
            if Session.inGroup(self.itinerary) {
                MainView.instance?.chatList.show()
                self.hide()
            }
            else {
                MainView.instance?.friendsView.show(self.itinerary)
                self.hide()
            }
        })
    }
    
    func updateUIWithItinerary() {
        
        mapView.clearMarkers()
        
        if itinerary != nil {
            let locations = itinerary["locations"] as! [NSDictionary]
            
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateStyle = .NoStyle
            timeFormatter.timeStyle = .ShortStyle
            let time:String = timeFormatter.stringFromDate(itinerary["time"] as! NSDate)
            
            bannerImage.nk_setImageWith(NSURL(string: itinerary["image"] as! String)!)
            attendeeCountLabel.text = "\(itinerary["count_peoples"]!)"
            priceLabel.text = "\(itinerary["estimated_cost"]!)"
            categoryLabel.text = "\(itinerary["type_event"]!)"
            nameLabel.text = "\(itinerary["title_event"]!)"
            if locations.count > 0 {
                let location:NSDictionary = locations[0]
                let address = location["address"] as! [String]
                timeLabel.text = time
                locationLabel.text = location["neighborhood"] != nil ? "\(location["neighborhood"] as! String)" : "\(location["name"]!)"
            }
            else {
                timeLabel.text = ""
                locationLabel.text = ""
            }
            descriptionLabel.text = "\(itinerary["description_event"]!)"
            
            if locations.count == 0 {
                locationsHeightConstraint.constant = LocationsNoneHeight
            }
            
            if locations.count >= 1 {
                let location:NSDictionary = locations[0]
                let address = location["address"] as! [String]
                locationOneHolder.hidden = false
                locationOneName.text = "\(location["name"]!)"
                locationOneAddress.text = address.count > 0 ? "\((location["address"] as! [String])[0])" : "\(location["neighborhood"]!)"
                mapView.addMarkers(CLLocationCoordinate2D(latitude: (location["latitude"] as! NSString).doubleValue, longitude: (location["longitude"] as! NSString).doubleValue ))
                locationsHeightConstraint.constant = LocationsOneHeight
            }
            else {
                locationOneHolder.hidden = true
                locationOneName.text = ""
                locationOneAddress.text = ""
            }
            
            if locations.count >= 2 {
                let location:NSDictionary = locations[1]
                let address = location["address"] as! [String]
                locationTwoHolder.hidden = false
                locationTwoName.text = "\(location["name"]!)"
                locationTwoAddress.text = address.count > 0 ? "\((location["address"] as! [String])[0])" : "\(location["neighborhood"]!)"
                mapView.addMarkers(CLLocationCoordinate2D(latitude: (location["latitude"] as! NSString).doubleValue, longitude: (location["longitude"] as! NSString).doubleValue ))
                locationsHeightConstraint.constant = LocationsTwoHeight
            }
            else {
                locationTwoHolder.hidden = true
                locationTwoName.text = ""
                locationTwoAddress.text = ""
            }
            
            if locations.count >= 3 {
                let location:NSDictionary = locations[2]
                let address = location["address"] as! [String]
                locationThreeHolder.hidden = false
                locationThreeName.text = "\(location["name"]!)"
                locationThreeAddress.text = address.count > 0 ? "\((location["address"] as! [String])[0])" : "\(location["neighborhood"]!)"
                mapView.addMarkers(CLLocationCoordinate2D(latitude: (location["latitude"] as! NSString).doubleValue, longitude: (location["longitude"] as! NSString).doubleValue ))
                locationsHeightConstraint.constant = LocationsThreeHeight
            }
            else {
                locationThreeHolder.hidden = true
                locationThreeName.text = ""
                locationThreeAddress.text = ""
            }
            
            if locations.count >= 4 {
                let location:NSDictionary = locations[3]
                let address = location["address"] as! [String]
                locationFourHolder.hidden = false
                locationFourName.text = "\(location["name"]!)"
                locationFourAddress.text = address.count > 0 ? "\((location["address"] as! [String])[0])" : "\(location["neighborhood"]!)"
                mapView.addMarkers(CLLocationCoordinate2D(latitude: (location["latitude"] as! NSString).doubleValue, longitude: (location["longitude"] as! NSString).doubleValue ))
                locationsHeightConstraint.constant = LocationsFourHeight
            }
            else {
                locationFourHolder.hidden = true
                locationFourName.text = ""
                locationFourAddress.text = ""
            }
            
            if locations.count >= 5 {
                let location:NSDictionary = locations[4]
                let address = location["address"] as! [String]
                locationFiveHolder.hidden = false
                locationFiveName.text = "\(location["name"]!)"
                locationFiveAddress.text = address.count > 0 ? "\((location["address"] as! [String])[0])" : "\(location["neighborhood"]!)"
                mapView.addMarkers(CLLocationCoordinate2D(latitude: (location["latitude"] as! NSString).doubleValue, longitude: (location["longitude"] as! NSString).doubleValue ))
                locationsHeightConstraint.constant = LocationsFiveHeight
            }
            else {
                locationFiveHolder.hidden = true
                locationFiveName.text = ""
                locationFiveAddress.text = ""
            }
            
            
            scrollableView.layoutIfNeeded()
            mapView.positionCentered()
        }
        
    }
    
    func show(itinerary:EventDetail) {
        self.itinerary = itinerary
        self.updateUIWithItinerary()
        
        if Session.inGroup(itinerary) {
            actionBtn.setTitle("View Chat", forState: UIControlState.Normal)
        }
        else {
            actionBtn.setTitle("Invite Attendees", forState: UIControlState.Normal)
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
    
    func configureStyle() {
        frame.origin.y = frame.height
    }
    
    func configureUI() {
        mapView = MapView(frame: map.bounds)
        map.addSubview(mapView)
        map.addSubview(UIView(frame: map.bounds))
        mapView.addMarkers(CLLocationCoordinate2D(latitude: -33.868, longitude: 151.2086))
        scrollableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: actionView.frame.height, right: 0)
    }
    
    static func loadFromXib() -> ItineraryView {
        let instance = NSBundle.mainBundle().loadNibNamed("ItineraryView", owner: self, options: nil)!.first as! ItineraryView
        instance.frame = UIScreen.mainScreen().bounds
        instance.layoutIfNeeded()
        instance.configureStyle()
        instance.configureUI()
        return instance
    }
}





