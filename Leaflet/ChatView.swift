//
//  ChatView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 10/30/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class ChatView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var group:EventGroup!
    var event:EventDetail!
    
    var messages:[Message] = []
    var timer:NSTimer!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var locationHeaderView: UIView!
    
    @IBOutlet weak var locationOrder: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationAddress: UILabel!
    @IBOutlet weak var locationPreview: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var list: UITableView!
    @IBAction func onClose(sender: AnyObject) {
        hide()
    }
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBAction func onSend(sender: AnyObject) {
        if field.text != "" {
            let message = Message()
            message.setValue(field.text!, forKey: "text")
            message.setObject(Session.me()!, forKey: "from")
            message.setObject(event, forKey: "to")
            message.saveInBackgroundWithBlock({ (saved, error) in
                if error == nil {
                    if !self.hasMessage(message) {
                        mainQueue({
                            self.messages.append(message)
                            self.list.insertRowsAtIndexPaths([NSIndexPath(forRow: self.messages.count-1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
                            delay(0.2) {
                                self.scrollToBottom()
                            }
                        })
                    }
                }
            })
            field.text = ""
        }
    }
    
    @IBOutlet weak var field: UITextView!
    @IBOutlet weak var fieldBottomConstraint: NSLayoutConstraint!
    
    func updateHeaderUI() {
        title.text = event["title_event"] as? String
        let locations = event["locations"] as! [NSDictionary]
        locationName.text = locations[0]["name"] as? String
        locationAddress.text = locations[0]["neighborhood"] as? String
        locationPreview.nk_setImageWith(NSURL(string: locations[0]["preview"] as! String)!)
    }
    
    func hasMessage(message:Message) -> Bool {
        for _message in messages {
            if _message.objectId! == message.objectId {
                return true
            }
        }
        return false
    }
    
    func fetchMessages() {
        let query = Message.query()
        query?.limit = 1000
        query?.whereKey("to", equalTo: event)
        query?.includeKey("to")
        query?.includeKey("from")
        query?.findObjectsInBackgroundWithBlock({ (messages, error) in
            if error == nil {
                self.messages = messages as! [Message]
                mainQueue({
                    self.list.reloadData()
                })
                self.startPolling()
            }
        })
    }
    
    func pollMessages() {
        let query = Message.query()
        query?.limit = 1000
        query?.whereKey("to", equalTo: event)
        query?.includeKey("to")
        query?.includeKey("from")
        query?.findObjectsInBackgroundWithBlock({ (messages, error) in
            if error == nil {
                let _messages = messages as! [Message]
                for message in _messages {
                    if !self.hasMessage(message) {
                        mainQueue({
                            self.messages.append(message)
                            self.list.insertRowsAtIndexPaths([NSIndexPath(forRow: self.messages.count-1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
                            delay(0.5) {
                                self.scrollToBottom()
                            }
                        })
                    }
                }
            }
        })
    }
    
    func startPolling() {
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(pollMessages), userInfo: nil, repeats: true)
    }
    
    func stopPolling() {
        timer?.invalidate()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.objectForKey("from") != nil {
            let user = message.objectForKey("from") as! User
            if user.objectId! == Session.me()!.objectId! {
               let cell = tableView.dequeueReusableCellWithIdentifier("ChatLeftCell") as! ChatLeftCell
                cell.icon.nk_setImageWith(NSURL(string: user.valueForKey("image") as! String)!)
                cell.message.text = message.valueForKey("text") as? String
                cell.message.numberOfLines = 0
                cell.time.text = ""
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier("ChatRightCell") as! ChatRightCell
                cell.icon.nk_setImageWith(NSURL(string: user.valueForKey("image") as! String)!)
                cell.message.text = message.valueForKey("text") as? String
                cell.message.numberOfLines = 0
                cell.time.text = ""
                return cell
            }
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let message = messages[indexPath.row]
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: FontNameRegular, size: 14)
        label.text = message.valueForKey("text") as? String
        return label.sizeThatFits(CGSizeMake(self.frame.width-120, CGFloat.max)).height+60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: self.list.contentSize.height - self.list.bounds.size.height)
        self.list.setContentOffset(bottomOffset, animated: true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        fieldBottomConstraint.constant = keyboardFrame.height
        UIView.animateWithDuration(DurationForUI) { 
            self.layoutIfNeeded()
        }
        
        delay(DurationForUI) {
            self.scrollToBottom()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        fieldBottomConstraint.constant = 0
        UIView.animateWithDuration(DurationForUI) {
            self.layoutIfNeeded()
        }
    }
    
    func show(group:EventGroup) {
        
        self.group = group
        self.event = group["event"] as! EventDetail
        
        updateHeaderUI()
        fetchMessages()
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = 0
        }
    }
    
    func hide() {
        stopPolling()
        hideKeyboard()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self)
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = self.frame.height
        }
    }
    
    func hideKeyboard() {
        field.endEditing(true)
    }
    
    func configureUI() {
        frame.origin.y = frame.height
        list.delegate = self
        list.dataSource = self
        list.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        list.registerNib(UINib(nibName: "ChatRightCell", bundle: nil), forCellReuseIdentifier: "ChatRightCell")
        list.registerNib(UINib(nibName: "ChatLeftCell", bundle: nil), forCellReuseIdentifier: "ChatLeftCell")
        list.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        locationHeaderView.layer.masksToBounds = false
        locationHeaderView.layer.shadowOffset = CGSizeMake(0, 2);
        locationHeaderView.layer.shadowRadius = 5
        locationHeaderView.layer.shadowOpacity = 0.2;
        locationHeaderView.layer.addSublayer({ () -> CALayer in
            let border = CALayer()
            border.frame = CGRectMake(0, 0, frame.width, 1)
            border.frame.origin.y = locationHeaderView.frame.height - border.frame.height
            border.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor
            return border
        }())
    }
    
    static func loadFromXib() -> ChatView {
        let instance = NSBundle.mainBundle().loadNibNamed("ChatView", owner: self, options: nil)!.first as! ChatView
        instance.frame = UIScreen.mainScreen().bounds
        instance.layoutIfNeeded()
        instance.configureUI()
        return instance
    }
}
