//
//  LocationView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 11/30/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit
import Parse

class LocationView: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var list: UITableView!
    
    var state:String = "NJ"
    var cachedCities:[NSDictionary] = []
    var cities:[NSDictionary] = []
    var citySelected:NSDictionary? = nil
    var onClose:((city:NSDictionary?)->Void)?
    var statePicker:PickerView!
    
    @IBAction func onCloseHandler(sender: AnyObject) {
        hide()
    }

    @IBAction func onStateHandler(sender: AnyObject) {
        endEditing(true)
        statePicker.show()
    }
    
    func search(text:String) {
        if text != "" {
            self.cities = []
            for city in cachedCities {
                if (city["city"] as! String).lowercaseString.containsString(text.lowercaseString) {
                    var containsCity:Bool = false
                    for c in cities {
                        if (city["city"] as! String).lowercaseString == (c["city"] as! String).lowercaseString {
                            containsCity = true
                        }
                    }
                    if !containsCity {
                        self.cities.append(city)
                    }
                }
            }
            self.list.reloadData()
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let city = cities[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationViewCell") as! LocationViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.Gray
        cell.name.text = city["city"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        endEditing(true)
        citySelected = cities[indexPath.row]
        let cityName:String = cities[indexPath.row]["city"] as! String
        AttentionView.displayBanner("\(cityName) selected")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        endEditing(true)
        if searchField.text != "" {
            search(searchField.text!)
        }
        else {
            clear()
        }
        return false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        if text.characters.count > 0 {
            search(text)
        }
        else {
            clear()
        }
        return true
    }
    
    func clear() {
        self.cities = []
        self.list.reloadData()
    }
    
    func show() {
        self.loadCitiesUsingState()
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = 0
        }
    }
    
    func hide() {
        onClose?(city: citySelected)
        endEditing(true)
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = self.frame.height
        }
    }
    
    func loadCitiesUsingState() {
        self.state = self.state == "" ? "NY" : self.state
        self.searchField.placeholder = "Search for cities in \(self.state)"
        PFCloud.callFunctionInBackground("citiesFromState", withParameters: ["state": self.state]) { (result, error) in
            if result != nil {
                self.cachedCities = result as! [NSDictionary]
            }
        }
    }
    
    func configureUI() {
        frame.origin.y = frame.height
        
        list.delegate = self
        list.dataSource = self
        list.registerNib(UINib(nibName: "LocationViewCell", bundle: nil), forCellReuseIdentifier: "LocationViewCell")
        searchField.delegate = self
        
        statePicker = PickerView.loadFromXib()
        addSubview(statePicker)
        statePicker.useData(StateAbbreviations)
        statePicker.onDone = { value in
            self.state = value
            self.loadCitiesUsingState()
        }
    }

    
    static func loadFromXib() -> LocationView {
        let instance = NSBundle.mainBundle().loadNibNamed("LocationView", owner: self, options: nil)!.first as! LocationView
        instance.frame = UIScreen.mainScreen().bounds
        instance.configureUI()
        return instance
    }
}

