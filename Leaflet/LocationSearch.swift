//
//  LocationSearch.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 10/24/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class LocationSearch: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var Y:YLPClient!
    var locations:[YLPBusiness] = []
    var selected:[YLPBusinessWithTime] = []
    var timeOfDayPicker:PickerTimeView!
    var locationView:LocationView!
    var cityLocation:NSDictionary! = DefaultLocation
    
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var list: UITableView!
    @IBAction func onClose(sender: AnyObject) {
        onClose?(locations: selected)
        hide()
    }
    
    @IBAction func onCityHandler(sender: AnyObject) {
        endEditing(true)
        locationView.show()
    }
    
    var onClose:((locations:[YLPBusinessWithTime])->Void)?
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let business = locations[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell") as! LocationCell
        cell.name.text = business.name
        cell.address.text = business.location.address.count > 0 ? business.location.address[0] : ""
        cell.reviews.text = ""
        cell.rating.nk_setImageWith(ImageRequest(URL: business.ratingImgURL))
        if business.imageURL != nil {
            cell.preview.nk_setImageWith(ImageRequest(URL: business.imageURL!))
        }
        else {
            cell.preview.nk_displayImage(nil)
        }
        cell.overlay.alpha = isLocationSelected(business) ? 1 : 0
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        endEditing(true)
        search.text = ""
        timeOfDayPicker.onDone = { time in
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! LocationCell
            cell.overlay.alpha = 1
            let business = YLPBusinessWithTime()
            business.business = self.locations[indexPath.row]
            business.dateTime = time
            self.addLocation(business)
        }
        timeOfDayPicker.show()
        
    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        endEditing(true)
        search.text = ""
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! LocationCell
        cell.overlay.alpha = 0
        
        let business = YLPBusinessWithTime()
        business.business = self.locations[indexPath.row]
        
        removeLocation(business)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        endEditing(true)
        if search.text != "" {
            searchForLocations(search.text!)
        }
        else {
            clear()
        }
        return false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        if text.characters.count >= 3 {
            searchForLocations(text)
        }
        else {
            clear()
        }
        return true
    }

    func isLocationSelected(business:YLPBusiness) -> Bool {
        var index:Int = -1
        for (k,location) in selected.enumerate() {
            if location.business.identifier == business.identifier {
                index = k
            }
        }
        if index == -1 {
            return false
        }
        else {
            return true
        }
    }
    
    func addLocation(business:YLPBusinessWithTime) {
        var index:Int = -1
        for (k,location) in selected.enumerate() {
            if location.business.identifier == business.business.identifier {
                index = k
            }
        }
        if index == -1 {
            selected.append(business)
        }
    }
    
    func removeLocation(business:YLPBusinessWithTime) {
        var index:Int = -1
        for (k,location) in selected.enumerate() {
            if location.business.identifier == business.business.identifier {
                index = k
            }
        }
        if index != -1 {
            selected.removeAtIndex(index)
        }
    }
    
    func searchForLocations(text:String) {
        let cityName:String = cityLocation["city"] as! String
        let cityState:String = cityLocation["state"] as! String
        Y.searchWithLocation("\(cityName),\(cityState)", currentLatLong: nil, term: text, limit: 20, offset: 0, sort: YLPSortType.BestMatched, completionHandler: { (result, error) in
            if error == nil && result != nil {
                self.locations = result!.businesses
                mainQueue({
                    self.list.reloadData()
                })
            }
        })
//        Y.searchWithQuery(YLPQuery(location: text, currentLatLong: nil)) { (search, error) in
//            if error == nil && search != nil {
//                self.locations = search!.businesses
//                mainQueue({
//                    self.list.reloadData()
//                })
//            }
//        }
    }
    
    func clear() {
        self.locations = []
        mainQueue({
            self.list.reloadData()
        })
    }
    
    func clearSelected() {
        selected = []
    }
    
    func show() {
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = 0
        }
    }
    
    func hide() {
        endEditing(true)
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = self.frame.height
        }
    }
    
    func configureUI() {
        frame.origin.y = frame.height
        
        Y = YLPClient(consumerKey: YelpConsumerKey, consumerSecret: YelpConsumerSecret, token: YelpToken, tokenSecret: YelpTokenSecret)
        list.delegate = self
        list.dataSource = self
        list.registerNib(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        search.delegate = self
        
        timeOfDayPicker = PickerTimeView.loadFromXib()
        addSubview(timeOfDayPicker)
        
        locationView = LocationView.loadFromXib()
        locationView.onClose = { city in
            self.cityLocation = city
        }
        addSubview(locationView)
    }
    
    static func loadFromXib() -> LocationSearch {
        let instance = NSBundle.mainBundle().loadNibNamed("LocationSearch", owner: self, options: nil)!.first as! LocationSearch
        instance.frame = UIScreen.mainScreen().bounds
        instance.configureUI()
        return instance
    }
}
