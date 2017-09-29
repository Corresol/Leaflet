//
//  ChooseBundleView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/27/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class ChooseBundleView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var list: UITableView!
    
    @IBAction func onClose(sender: AnyObject) {
        hide()
    }

    var bundles:[EventBundle] = []
    var onSelected:((bundle:EventBundle)->Void)?
    
    func show() {
        pullBundles()
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = 0
        }
    }
    
    func hide() {
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = self.frame.height
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bundles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let bundle = bundles[indexPath.row]
        let eventsCount = (bundle.objectForKey("events") as! NSMutableArray).count
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ChooseBundleCell") as! ChooseBundleCell
        cell.banner.loadImageFromURL(NSURL(string: bundle.valueForKey("banner") as! String)!)
        cell.name.text = bundle.valueForKey("heading") as? String
        cell.activeCount.text = "\(eventsCount)"
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        onSelected?(bundle: bundles[indexPath.row])
    }
    
    func pullBundles() {
        self.bundles = []
        self.list.reloadData()
        EventBundle.findAll { (bundles) in
            for bundle in bundles {
                self.bundles.append(bundle)
            }
            self.list.reloadData()
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func configureUI() {
        frame.origin.y = frame.height
        list.delegate = self
        list.dataSource = self
        list.registerNib(UINib(nibName: "ChooseBundleCell", bundle: nil), forCellReuseIdentifier: "ChooseBundleCell")
    }
    
    static func loadFromXib() -> ChooseBundleView {
        let instance = NSBundle.mainBundle().loadNibNamed("ChooseBundleView", owner: self, options: nil)!.first as! ChooseBundleView
        instance.frame = UIScreen.mainScreen().bounds
        instance.configureUI()
        return instance
    }
}


