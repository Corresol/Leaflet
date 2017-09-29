//
//  ChatListView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 10/30/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class ChatListView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var list: UITableView!
    @IBOutlet weak var emptyView: UILabel!
    @IBAction func onClose(sender: AnyObject) {
        hide()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let group = Session.groups[indexPath.row]
        let event = group["event"] as! EventDetail
        let locations = event["locations"] as! [NSDictionary]
        let startDay = event["start_day"] as! NSDate
        let isOpen = startDay.compare(NSDate()) == NSComparisonResult.OrderedAscending
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatListCell") as! ChatListCell
        cell.preview.nk_setImageWith(NSURL(string:event["image"] as! String)!)
        cell.name.text = event["title_event"] as? String
        cell.status.text = isOpen ? "OPEN" : "PENDING"
        cell.location.text = locations[0]["neighborhood"] as? String
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Session.groups.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let group = Session.groups[indexPath.row]
        let event = group["event"] as! EventDetail
        let startDay = event["start_day"] as! NSDate
        let isOpen = startDay.compare(NSDate()) == NSComparisonResult.OrderedAscending
        if isOpen {
            MainView.instance?.chatView.show(group)
        }
        else {
            AttentionView.displayBanner("Chat not yet available")
        }
    }
    
    func populateGroups() {
        self.list.reloadData()
        Session.fetchGroups {
            if Session.groups.count > 0 {
                mainQueue({
                    self.emptyView.hidden = true
                    self.list.reloadData()
                })
            }
            else {
                mainQueue({
                    self.emptyView.hidden = false
                })
            }
        }
    }
    
    func show() {
        populateGroups()
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
        list.delegate = self
        list.dataSource = self
        list.registerNib(UINib(nibName: "ChatListCell", bundle: nil), forCellReuseIdentifier: "ChatListCell")
        emptyView.hidden = true
    }
    
    static func loadFromXib() -> ChatListView {
        let instance = NSBundle.mainBundle().loadNibNamed("ChatListView", owner: self, options: nil)!.first as! ChatListView
        instance.frame = UIScreen.mainScreen().bounds
        instance.configureUI()
        return instance
    }
}
