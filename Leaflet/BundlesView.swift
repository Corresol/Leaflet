//
//  BundlesView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 8/15/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import Foundation
import UIKit
import Parse

class BundlesView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private var bundlesList:UITableView!
    private let BundleCellHeight:CGFloat = 170
    private var bundles:[EventBundle] = []
    private var refreshControl:UIRefreshControl = UIRefreshControl()
    
    func initialize() {
        bundlesList = UITableView()
        bundlesList.backgroundColor = UIColor.clearColor()
        bundlesList.frame = bounds
        bundlesList.separatorColor = UIColor.whiteColor()
        bundlesList.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        bundlesList.contentInset = UIEdgeInsetsMake(HeaderHeight-10, 0, 0, 0)
        bundlesList.registerNib(UINib(nibName: "BundleCell", bundle: nil), forCellReuseIdentifier: "BundleCell")
        bundlesList.delegate = self
        bundlesList.dataSource = self
        bundlesList.showsVerticalScrollIndicator = false
        bundlesList.showsHorizontalScrollIndicator = false
        addSubview(bundlesList)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bundles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:BundleCell = tableView.dequeueReusableCellWithIdentifier("BundleCell") as! BundleCell
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if bundles.count > indexPath.row {
            let bundle:EventBundle = bundles[indexPath.row]
            let events = (bundle.objectForKey("events") as! NSMutableArray)
            
            let bundleCell:BundleCell = cell as! BundleCell
            bundleCell.selectionStyle = .None
            bundleCell.bundleName.text = "\(bundle.valueForKey("heading")!)"
            
            bundleCell.itinearyCountLabel.text = "\(events.count) Plans"
            bundleCell.itinearyCountLabel.layer.masksToBounds = true
            bundleCell.itinearyCountLabel.layer.cornerRadius = 5
            bundleCell.bundleImageView.loadImageFromURL(NSURL(string:bundle.valueForKey("banner") as! String)!)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return BundleCellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if Session.me() != nil {
            let bundle:EventBundle = bundles[indexPath.row]
            let events = (bundle.objectForKey("events") as! NSMutableArray)
            if events.count > 0 {
                MainView.instance?.itinerariesView.useBundle(bundle)
                MainView.instance?.itinerariesView.show()
            }
            else {
                MainView.instance?.locationRequest.show()
            }
        }
        else {
            MainView.instance?.onboardView.show()
        }
    }
    
    func pullBundles() {
        EventBundle.findAll { (bundles) in
            var _bundles:[EventBundle] = []
            for bundle in bundles.reverse() {
               let events = (bundle.objectForKey("events") as! NSMutableArray)
                if events.count > 0 {
                    _bundles.append(bundle)
                }
            }
            self.bundles = _bundles
            self.bundlesList.reloadData()
            self.refreshControl.endRefreshing()
            
            if _bundles.count == 0 {
                MainView.instance?.locationRequest.show()
            }
            else {
                MainView.instance?.locationRequest.hide()
            }
            
            if Session.me() != nil {
                Session.fetchNotifications({
                })
                
                Session.fetchGroups({ 
                })
            }
        }
    }
    
    func pullToRefresh() {
        bundles = []
        pullBundles()
    }
    
    func addBundle(bundle:EventBundle) {
        bundles.append(bundle)
        bundlesList.reloadData()
    }
    
    func removebundles() {
        bundles = []
        bundlesList.reloadData()
    }
    
    func removeBundleAtIndex(index:Int) {
        if bundles.count > index && index >= 0 {
            bundles.removeAtIndex(index)
            bundlesList.reloadData()
        }
    }
    
    func configureUI() {
        refreshControl.addTarget(self, action: #selector(pullToRefresh), forControlEvents: UIControlEvents.ValueChanged)
        bundlesList.addSubview(refreshControl)
    }
    
    static func loadFromXib() -> BundlesView {
        let instance = BundlesView(frame:UIScreen.mainScreen().bounds)
        instance.initialize()
        instance.configureUI()
        instance.backgroundColor = MainBackgroundColor
        return instance
    }
}




