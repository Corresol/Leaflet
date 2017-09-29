//
//  CreateItineraryView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/27/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit
import Parse

class CreateItineraryView: UIView, UITextViewDelegate, UIScrollViewDelegate {

    var bundle:EventBundle? = nil
    
    @IBOutlet weak var holderView: UIScrollView!
    
    // Choose Bundle
    @IBOutlet weak var bundleBtn: UIButton!
    @IBAction func onChooseBundle(sender: AnyObject) {
        endEditing(true)
        chooseBundleView.show()
    }
    
    // Choose Banner
    @IBOutlet weak var banner: UITextField!
    @IBAction func onBannerSearch(sender: AnyObject) {
        endEditing(true)
        chooseBannerView.show()
    }
    
    // Title
    @IBOutlet weak var title: UITextField!
    
    // Description
    @IBOutlet weak var descriptionText: UITextView!
    
    // Tags
    @IBOutlet weak var tags: UILabel!
    
    // Location
    @IBOutlet weak var locationSearchBtn: UIButton!
    @IBOutlet weak var location: UITextField!
    @IBAction func onLocations(sender: AnyObject) {
        endEditing(true)
        locationSearch.show()
    }
    
    // Partner
    @IBOutlet weak var partner: UISwitch!
    
    // Start Day
    @IBOutlet weak var startDay: UILabel!
    
    // Time of Day
    @IBOutlet weak var timeOfDay: UILabel!
    
    // Attendees
    @IBOutlet weak var numberOfAttendees: UILabel!
    
    // Experience Type
    @IBOutlet weak var experienceType: UILabel!
    
    // Over 21
    @IBOutlet weak var adultOnly: UISwitch!
    
    // Estimated Cost
    @IBOutlet weak var estimatedCost: UILabel!
    
    // End Date
    @IBOutlet weak var endDate: UILabel!
    
    // Repeat Weekly
    @IBOutlet weak var repeatWeekly: UISwitch!
    
    // Repeat Daily
    @IBOutlet weak var repeatDaily: UISwitch!
    
    // Featured
    @IBOutlet weak var featured: UISwitch!
    @IBOutlet weak var featuredName: UITextField!
    @IBOutlet weak var featuredLink: UITextField!
    
    // Message
    @IBOutlet weak var firstMessage: UITextView!
    
    // Reoccur
    @IBOutlet weak var reoccur_monday: UISwitch!
    @IBOutlet weak var reoccur_tuesday: UISwitch!
    @IBOutlet weak var reoccur_wednesday: UISwitch!
    @IBOutlet weak var reoccur_thursday: UISwitch!
    @IBOutlet weak var reoccur_friday: UISwitch!
    @IBOutlet weak var reoccur_saturday: UISwitch!
    @IBOutlet weak var reoccur_sunday: UISwitch!
    
    
    
    // Pickers
    var startDayPicker:PickerDateView!
    var timeOfDayPicker:PickerTimeView!
    var numberOfAttendeesPicker:PickerView!
    var experienceTypePicker:PickerView!
    var estimatedCostPicker:PickerView!
    var endDayPicker:PickerDateView!
    
    // Locations View
    var locationsSelected:[YLPBusinessWithTime] = []
    var locationSearch:LocationSearch!
    
    // Tag Selector
    var tagView:ChooseTagView!
    
    // Banner Search
    var chooseBannerView:ChooseBannerView!
    
    // Choose Bundle
    var chooseBundleView:ChooseBundleView!
    
    // Header Actions
    @IBAction func onClose(sender: AnyObject) {
        hide()
    }
    
    @IBAction func onSave(sender: AnyObject) {
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        hideKeyboard()
        var locations:[NSDictionary] = []
        for stop in locationsSelected {
            locations.append([
                "id": generateID(),
                "time": dateFormat.dateFromString(stop.dateTime)!,
                "name": stop.business.name,
                "address": stop.business.location.address,
                "phone": stop.business.phone == nil ? "" : stop.business.phone!,
                "location": PFGeoPoint(latitude: stop.business.location.coordinate?.latitude == nil ? 0 : stop.business.location.coordinate!.latitude, longitude: stop.business.location.coordinate?.longitude == nil ? 0 : stop.business.location.coordinate!.longitude),
                "latitude": "\(stop.business.location.coordinate?.latitude == nil ? 0 : stop.business.location.coordinate!.latitude)",
                "longitude": "\(stop.business.location.coordinate?.longitude == nil ? 0 : stop.business.location.coordinate!.longitude)",
                "preview": stop.business.imageURL != nil ? stop.business.imageURL!.absoluteString! : "",
                "neighborhood": stop.business.location.neighborhoods?.count > 0 ? stop.business.location.neighborhoods![0] : stop.business.location.city,
            ])
        }
        
        // Save event to bundle
        if bundle != nil {
            
            // Check for banner
            if banner!.text == "" {
                AttentionView.displayBanner("Choose a banner image")
            }
                
            // Check for title
            else if title.text == "" {
                AttentionView.displayBanner("Provide a title")
            }
                
            // Check for description
            else if descriptionText.text == "" {
                AttentionView.displayBanner("Provide a description")
            }
             
            // Check for tags
            else if tags.text == "" {
                AttentionView.displayBanner("Choose at least 1 tag")
            }
                
            // Check for locations
            else if locationsSelected.count == 0 {
                AttentionView.displayBanner("Choose at least 1 location")
            }
                
            // Check for experience type
            else if experienceType.text == "" {
                AttentionView.displayBanner("Provide an experience type")
            }
                
            // Check for estimated cost
            else if estimatedCost.text == "" {
                AttentionView.displayBanner("Provide estimated cost")
            }
                
            // Check for time
            else if timeOfDay.text == "" {
                AttentionView.displayBanner("Provide time of day")
            }
                
            // Check for start day
            else if startDay.text == "" {
                AttentionView.displayBanner("Provide start day")
            }
                
            // Check for end day
            else if endDate.text == "" {
                AttentionView.displayBanner("Provide end day")
            }
                
            // Create Banner
            else {
                let attendeeCount:Int = numberOfAttendees.text == "" ? 2 : Int(numberOfAttendees.text!)!
                let event = EventDetail()
                event.setValue(banner.text!, forKey: "image")
                event.setValue(true, forKey: "approved")
                event.setValue(estimatedCost.text!, forKey: "estimated_cost")
                event.setObject([], forKey: "user_name")
                event.setObject([], forKey: "users_array")
                event.setValue(false, forKey: "any_day")
                event.setValue(attendeeCount, forKey: "count_peoples")
                event.setValue(descriptionText.text!, forKey: "description_event")
                event.setValue(experienceType.text!, forKey: "type_event")
                event.setValue(location.text!, forKey: "address")
                event.setValue(0, forKey: "age")
                event.setValue(false, forKey: "is_vip")
                event.setObject([], forKey: "image_links")
                event.setValue("", forKey: "place")
                event.setValue(NSDate(), forKey: "day_time")
                event.setValue(dateFormat.dateFromString(startDay.text!)!, forKey: "start_day")
                event.setValue(dateFormat.dateFromString(endDate.text!)!, forKey: "end_day")
                event.setValue(title.text!, forKey: "title_event")
                event.setValue(dateFormat.dateFromString(startDay.text!)!, forKey: "date")
                event.setValue(false, forKey: "is_recurring")
                event.setValue(repeatDaily.on, forKey: "repeat_daily")
                event.setValue(repeatWeekly.on, forKey: "repeat_weekly")
                event.setValue(0, forKey: "count_attended")
                event.setValue(adultOnly.on, forKey: "is21_age")
                event.setValue(tags.text!.componentsSeparatedByString(","), forKey: "tags")
                event.setValue(partner.on, forKey: "partner")
                event.setValue(dateFormat.dateFromString(timeOfDay.text!)!, forKey: "time")
                event.setValue(locations, forKey: "locations")
                event.setValue(featured.on, forKey: "featured")
                event.setValue(featuredName.text!, forKey: "featured_name")
                event.setValue(featuredLink.text!, forKey: "featured_link")
                event.setValue(firstMessage.text!, forKey: "first_message")
                event.setValue(reoccur_monday.on, forKey: "reoccur_monday")
                event.setValue(reoccur_tuesday.on, forKey: "reoccur_tuesday")
                event.setValue(reoccur_wednesday.on, forKey: "reoccur_wednesday")
                event.setValue(reoccur_thursday.on, forKey: "reoccur_thursday")
                event.setValue(reoccur_friday.on, forKey: "reoccur_friday")
                event.setValue(reoccur_saturday.on, forKey: "reoccur_saturday")
                event.setValue(reoccur_sunday.on, forKey: "reoccur_sunday")
                
                if locationsSelected.count > 0 {
                    let stop = locationsSelected[0]
                    event["location"] = PFGeoPoint(latitude: stop.business.location.coordinate?.latitude == nil ? 0 : stop.business.location.coordinate!.latitude, longitude: stop.business.location.coordinate?.longitude == nil ? 0 : stop.business.location.coordinate!.longitude)
                    event.setValue(stop.business.location.coordinate?.latitude == nil ? 0 : stop.business.location.coordinate!.latitude, forKey: "latitude")
                    event.setValue(stop.business.location.coordinate?.longitude == nil ? 0 : stop.business.location.coordinate!.longitude, forKey: "longitude")
                }
                event.setObject(self.bundle!, forKey: "bundle")
                event.saveInBackgroundWithBlock({ (saved, error) in
                    if error == nil && saved {
                        let events = self.bundle!.objectForKey("events") as! NSMutableArray
                        events.addObject(event)
                        self.bundle!.setValue(events, forKey: "events")
                        self.bundle!.saveInBackgroundWithBlock({ (saved, error) in
                            AttentionView.displayBanner("Itinerary created")
                            MainView.instance?.bundlesView.pullToRefresh()
                            self.setDefaults()
                        })
                    }
                    else {
                        AttentionView.displayBanner("Failed to save event")
                    }
                })
            }
        }
            
        // Bundle missing
        else {
            AttentionView.displayBanner("Choose bundle")
        }
    }
    
    func setDefaults() {
        reoccur_monday.on = false
        reoccur_tuesday.on = false
        reoccur_wednesday.on = false
        reoccur_thursday.on = false
        reoccur_friday.on = false
        reoccur_saturday.on = false
        reoccur_sunday.on = false
        
        firstMessage.text = ""
        featured.on = false
        featuredName.text = ""
        featuredLink.text = ""
        banner.text = ""
        title.text = ""
        descriptionText.text = ""
        tags.text = ""
        location.text = ""
        partner.on = false
        startDay.text = ""
        timeOfDay.text = ""
        numberOfAttendees.text = "2"
        experienceType.text = ""
        adultOnly.on = false
        estimatedCost.text = ""
        endDate.text = ""
        repeatWeekly.on = false
        repeatDaily.on = false
        bundle = nil
        self.locationSearch.clear()
        self.locationSearch.clearSelected()
        self.locationsSelected = []
        self.locationSearchBtn.setTitle("\(self.locationsSelected.count) location(s) have been added", forState: UIControlState.Normal)
        self.bundleBtn.setTitle("Choose Bundle", forState: UIControlState.Normal)
        self.holderView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func show() {
        setDefaults()
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = 0
        }
    }
    
    func hide() {
        endEditing(true)
        setDefaults()
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = self.frame.height
        }
    }
    
    func hideKeyboard() {
        endEditing(true)
    }
    
    func showTags() {
        hideKeyboard()
        tagView.show()
    }
    
    func showStartDay() {
        hideKeyboard()
        startDayPicker.show()
    }
    
    func showTimeOfDay() {
        hideKeyboard()
        timeOfDayPicker.show()
    }
    
    func showNumberOfAttendees() {
        hideKeyboard()
        numberOfAttendeesPicker.show()
    }
    
    func showExperienceType() {
        hideKeyboard()
        experienceTypePicker.show()
    }
    
    func showEstimatedCost() {
        hideKeyboard()
        estimatedCostPicker.show()
    }
    
    func showEndDay() {
        hideKeyboard()
        endDayPicker.show()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if textView.tag == 1 {
            let newText = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
            let numberOfChars = newText.characters.count
            return numberOfChars <= ItineraryDescriptionLimit
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.tag == 2 {
            self.holderView.setContentOffset(CGPointMake(0, self.holderView.contentSize.height - self.holderView.bounds.size.height + self.holderView.contentInset.bottom), animated: true)
        }
    }
    
    func configureUI() {
        frame.origin.y = frame.height
        
        holderView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
        holderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        startDay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showStartDay)))
        startDayPicker = PickerDateView.loadFromXib()
        addSubview(startDayPicker)
        startDayPicker.onDone = { date in
            self.startDay.text = date
        }
        
        timeOfDay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTimeOfDay)))
        timeOfDayPicker = PickerTimeView.loadFromXib()
        addSubview(timeOfDayPicker)
        timeOfDayPicker.onDone = { time in
            self.timeOfDay.text = time
        }
        
        numberOfAttendees.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showNumberOfAttendees)))
        numberOfAttendeesPicker = PickerView.loadFromXib()
        addSubview(numberOfAttendeesPicker)
        numberOfAttendeesPicker.useData(["2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"])
        numberOfAttendeesPicker.onDone = { value in
            self.numberOfAttendees.text = value
        }
        
        experienceType.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showExperienceType)))
        experienceTypePicker = PickerView.loadFromXib()
        addSubview(experienceTypePicker)
        experienceTypePicker.useData(["Adventure","Coffee","Dance","Drinks","Food","Ladies Only", "Museum", "Music", "Relax", "Sports", "Theatre", "VIP", "Volunteer", "Workout", "Test"])
        experienceTypePicker.onDone = { value in
            self.experienceType.text = value
        }
        
        estimatedCost.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showEstimatedCost)))
        estimatedCostPicker = PickerView.loadFromXib()
        addSubview(estimatedCostPicker)
        estimatedCostPicker.useData(["FREE", "$", "$$", "$$$", "$$$$", "$$$$$"])
        estimatedCostPicker.onDone = { value in
            self.estimatedCost.text = value
        }
        
        endDate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showEndDay)))
        endDayPicker = PickerDateView.loadFromXib()
        addSubview(endDayPicker)
        endDayPicker.onDone = { date in
            self.endDate.text = date
        }
        
        tags.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTags)))
        tagView = ChooseTagView.loadFromXib()
        tagView.frame.origin.y = tagView.frame.height
        tagView.headerTitle.text = "Choose Tags"
        tagView.headerSubtitle.text = ""
        tagView.searchField.placeholder = "Find tags"
        tagView.populateUI()
        tagView.onNext = {
            var tagText:String = ""
            for tag in self.tagView.tagsSelected {
                if tagText == "" {
                    tagText = tag
                }
                else {
                    tagText = tagText + "," + tag
                }
            }
            self.tags.text = tagText
            self.tagView.hide()
        }
        addSubview(tagView)
        
        chooseBannerView = ChooseBannerView.loadFromXib()
        chooseBannerView.onBanner = { url in
            self.banner.text = url
        }
        addSubview(chooseBannerView)
        
        chooseBundleView = ChooseBundleView.loadFromXib()
        chooseBundleView.onSelected = { bundle in
            self.bundle = bundle
            self.bundleBtn.setTitle("Update Bundle", forState: UIControlState.Normal)
        }
        addSubview(chooseBundleView)
        
        locationSearch = LocationSearch.loadFromXib()
        locationSearch.onClose = { locations in
            self.locationsSelected = locations
            self.locationSearchBtn.setTitle("\(self.locationsSelected.count) location(s) have been added", forState: UIControlState.Normal)
        }
        addSubview(locationSearch)
        
        descriptionText.tag = 1
        descriptionText.delegate = self
        
        firstMessage.tag = 2
        firstMessage.delegate = self
        
        holderView.delegate = self
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    static func loadFromXib() -> CreateItineraryView {
        let instance = NSBundle.mainBundle().loadNibNamed("CreateItineraryView", owner: self, options: nil)!.first as! CreateItineraryView
        instance.frame = UIScreen.mainScreen().bounds
        instance.configureUI()
        return instance
    }
}

