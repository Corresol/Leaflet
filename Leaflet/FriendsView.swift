//
//  FriendsView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 8/15/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import Foundation
import UIKit
import Parse

class FriendsView: UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var HeaderLabelColor:UIColor = Color.fromHex("#5D6B73", alpha: 1)
    private var HeaderBackgroundColor:UIColor = Color.fromHex("#BBC6CB", alpha: 1)
    
    @IBOutlet weak var listTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var selectedList: UICollectionView!
    @IBOutlet weak var list: UITableView!
    
    private var addressBook:APAddressBook = APAddressBook()
    private var permissionView:PermissionContactsView!
    
    private var CellListName:String = "FriendsListCell"
    private var CellListHeight:CGFloat =  75
    
    private var CellCondensedName:String = "FriendsRecommendedCell"
    private var CellCondensedWidth:CGFloat = 75
    private var CellCondensedHeight:CGFloat = 100
    private var SelectedVisibleHeight:CGFloat = 150
    
    private var users:[User] = []
    private var selectedUsers:[User] = []
    
    private var deviceContacts:[Contact] = []
    private var contacts:[Contact] = []
    private var selectedContacts:[Contact] = []
    
    private var event:EventDetail!
    
    @IBAction func onClose(sender: AnyObject) {
        hide()
    }
    
    @IBAction func onSend(sender: AnyObject) {
        let group = EventGroup()
        group.setObject(Session.me()!, forKey: "user")
        group.setObject(event, forKey: "event")
        group.saveInBackgroundWithBlock { (saved, error) in
            if error == nil && saved {
                for user in self.selectedUsers {
                    let notification = EventNotification()
                    notification.setObject(user, forKey: "to")
                    notification.setObject(Session.me()!, forKey: "from")
                    notification.setObject(group, forKey: "group")
                    notification.setValue("invite", forKey: "type")
                    notification.setValue("", forKey: "phone")
                    notification.saveInBackground()
                    
                    let appNotification = AppNotifications()
                    appNotification.setObject(user, forKey: "toNotify")
                    appNotification.setObject(Session.me()!, forKey: "notifier")
                    appNotification.setObject("Invited", forKey: "type")
                    appNotification.saveInBackground()
                    self.sendInvitePushToUser(user)
                }
                
                for contact in self.selectedContacts {
                    let notification = EventNotification()
                    notification.setObject(Session.me()!, forKey: "from")
                    notification.setObject(group, forKey: "group")
                    notification.setValue("invite", forKey: "type")
                    notification.setValue(contact.phones[0].digitsOnly(), forKey: "phone")
                    notification.saveInBackground()
                    self.sendInviteSMSToContact(contact)
                }
            }
            
            mainQueue({
                MainView.instance?.chatList.show()
                self.hide()
            })
        }
    }
    
    func sendInviteSMSToContact(contact:Contact) {
        let number:String = (contact.phones[0].formatAsPhone())
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "EEEE"
        let dayOfWeek:String = formatter.stringFromDate(event["start_day"] as! NSDate)
        let message:String = "SMS invite: \(Session.me()!.valueForKey("full_name") as! String) has invited you to plans for \(dayOfWeek) on \(AppName).\nCheck 'em out:\(AppURL)"
        PFCloud.callFunctionInBackground("sendSMS", withParameters: ["message": message, "number": number]) { (response, error) in
        }
    }
    
    func sendInvitePushToUser(user:User) {
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "EEEE"
        let dayOfWeek:String = formatter.stringFromDate(event["start_day"] as! NSDate)
        let message:String = "Push Notification: \(Session.me()!.valueForKey("full_name") as! String) has invited you to plans for \(dayOfWeek)."
        PFCloud.callFunctionInBackground("sendPush", withParameters: ["message": message, "user": user.objectId!]) { (response, error) in
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func containsContact(contact:Contact) -> Bool {
        for _contact in selectedContacts {
            if _contact === contact  {
                return true
            }
        }
        return false
    }
    
    func removeContact(contact:Contact) {
        var index:Int = -1
        for (k,v) in selectedContacts.enumerate() {
            if v === contact {
                index = k
            }
        }
        if index != -1 {
            selectedContacts.removeAtIndex(index)
        }
        updateSelectedUI()
    }
    
    func containsUser(user:User) -> Bool {
        for _user in selectedUsers {
            if _user.objectId! == user.objectId!  {
                return true
            }
        }
        return false
    }
    
    func removeUser(user:User) {
        var index:Int = -1
        for (k,v) in selectedUsers.enumerate() {
            if v === user {
                index = k
            }
        }
        if index != -1 {
            selectedUsers.removeAtIndex(index)
        }
        updateSelectedUI()
    }
    
    func updateSelectedUI() {
        if selectedUsers.count > 0 || selectedContacts.count > 0 {
            listTopConstraint.constant = SelectedVisibleHeight
            UIView.animateWithDuration(DurationForUI, animations: { 
                self.layoutIfNeeded()
            })
        }
        else {
            listTopConstraint.constant = 0
            UIView.animateWithDuration(DurationForUI, animations: {
                self.layoutIfNeeded()
            })
        }
        self.selectedList.reloadData()
    }
    
    func populateRecommended() {
        let query = User.query()
        query?.limit = 20
        query?.findObjectsInBackgroundWithBlock({ (users, error) in
            if error == nil && users != nil {
            }
        })
    }
    
    func searchUsers() {
        let userQuery = User.query()
        userQuery?.limit = 20
        userQuery?.whereKey("full_name", containsString: searchField.text!)
        userQuery?.findObjectsInBackgroundWithBlock({ (results, error) in
            if error == nil && results != nil {
                self.users = results as! [User]
                mainQueue({
                    self.list.reloadData()
                })
            }
        })
    }
    
    func searchContacts() {
        self.contacts = []
        for contact in deviceContacts {
            if (self.searchField.text! == "" || contact.name.lowercaseString.rangeOfString(self.searchField.text!.lowercaseString) != nil) {
                self.contacts.append(contact)
            }
        }
        self.list.reloadData()
    }
    
    func populateContacts() {
        addressBook.sortDescriptors = [
            NSSortDescriptor(key: "name.firstName", ascending: true)
        ]
        addressBook.loadContacts({ (contacts, error) in
            if error == nil {
                
                self.contacts = []
                self.deviceContacts = []
            
                for contact in contacts! as [APContact] {
                    var name:String = ""
                    if contact.name?.firstName?.characters.count > 0 {
                        name = contact.name!.firstName!
                    }
                    if contact.name?.lastName?.characters.count > 0 {
                        name += (name != "" ? " " : "") + contact.name!.lastName!
                    }
                    var phones:[String] = []
                    if let numbers = contact.phones {
                        for number in numbers {
                            if number.number != nil {
                                phones.append(number.number!)
                            }
                        }
                    }
                    
                    if phones.count > 0 && name != "" && (self.searchField.text! == "" || name.lowercaseString.rangeOfString(self.searchField.text!.lowercaseString) != nil) {
                        let contact = Contact()
                        contact.id = generateID()
                        contact.name = name
                        contact.phones = phones
                        self.deviceContacts.append(contact)
                        self.contacts.append(contact)
                    }
                    else {
                        let contact = Contact()
                        contact.id = generateID()
                        contact.name = name
                        contact.phones = phones
                        self.deviceContacts.append(contact)
                    }
                }
                
                mainQueue({
                    self.list.reloadData()
                })
            }
        })
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row < selectedUsers.count {
            let thumnailURL:String = DefaultUserIcon //"\(selectedUsers[indexPath.row].valueForKey("image") as! String)"
            let cell:FriendsRecommendedCell = collectionView.dequeueReusableCellWithReuseIdentifier(CellCondensedName, forIndexPath: indexPath) as! FriendsRecommendedCell
            mainQueue({
                cell.overlay.hidden = false
                cell.overlay.layer.masksToBounds = true
                cell.overlay.layer.cornerRadius = cell.friendImageView.frame.height/2
                cell.friendImageView.layer.masksToBounds = true
                cell.friendImageView.layer.cornerRadius = cell.friendImageView.frame.height/2
                cell.name.text = "\(self.selectedUsers[indexPath.row].valueForKey("full_name") as! String)"
                cell.friendImageView.nk_setImageWith(ImageRequest(URL: NSURL(string: thumnailURL)!))
            })
            return cell
        }
        else {
            let cell:FriendsRecommendedCell = collectionView.dequeueReusableCellWithReuseIdentifier(CellCondensedName, forIndexPath: indexPath) as! FriendsRecommendedCell
            mainQueue({
                cell.overlay.hidden = false
                cell.overlay.layer.masksToBounds = true
                cell.overlay.layer.cornerRadius = cell.friendImageView.frame.height/2
                cell.friendImageView.layer.masksToBounds = true
                cell.friendImageView.layer.cornerRadius = cell.friendImageView.frame.height/2
                cell.name.text = "\(self.selectedContacts[indexPath.row-self.selectedUsers.count].name)"
                cell.friendImageView.nk_displayImage(UIImage(named: "friends-sms"))
            })
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedUsers.count+selectedContacts.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: CellCondensedWidth, height: CellCondensedHeight)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        hideKeyboard()
        if indexPath.row < selectedUsers.count {
            self.removeUser(selectedUsers[indexPath.row])
        }
        else {
            self.removeContact(selectedContacts[indexPath.row-selectedUsers.count])
        }
        self.updateSelectedUI()
        self.list.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.backgroundColor = HeaderBackgroundColor
        label.textColor = HeaderLabelColor
        label.font = UIFont.systemFontOfSize(16)
        
        if section == 0 {
            label.text = "    All Contacts"
        }
        else if section == 1 {
            label.text = "    \(AppName) Users"
        }
        
        return label
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? contacts.count : users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:FriendsListCell = tableView.dequeueReusableCellWithIdentifier(CellListName) as! FriendsListCell
        mainQueue({
            cell.selectionStyle = .None
            cell.friendImageView.layer.masksToBounds = true
            cell.friendImageView.layer.cornerRadius = cell.friendImageView.frame.height/2
            cell.friendActionBtn.layer.masksToBounds = true
            cell.friendActionBtn.layer.cornerRadius = cell.friendActionBtn.frame.height/2
            cell.friendImageView.nk_setImageWith(ImageRequest(URL: NSURL(string: DefaultUserIcon)!))
            if indexPath.section == 0 {
                let contact = self.contacts[indexPath.row]
                cell.friendNameLabel.text = contact.name
                cell.friendActionBtn.image = self.containsContact(contact) ? UIImage(named: "friends-search-check") : nil
                cell.contactIndicator.hidden = false
            }
            else if indexPath.section == 1 {
                let user = self.users[indexPath.row]
                cell.friendNameLabel.text = user.valueForKey("full_name") as? String
                cell.friendActionBtn.image = self.containsUser(user) ? UIImage(named: "friends-search-check") : nil
                cell.contactIndicator.hidden = true
            }
        })
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CellListHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchField.text = ""
        hideKeyboard()
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FriendsListCell
        mainQueue({
            if indexPath.section == 0 {
                let contact = self.contacts[indexPath.row]
                if !self.containsContact(contact) {
                    cell.friendActionBtn.image = UIImage(named: "friends-search-check")
                    self.selectedContacts.append(contact)
                    self.updateSelectedUI()
                }
                else {
                    cell.friendActionBtn.image = nil
                    self.removeContact(contact)
                }
            }
            else {
                let user = self.users[indexPath.row]
                if !self.containsUser(user) {
                    cell.friendActionBtn.image = UIImage(named: "friends-search-check")
                    self.selectedUsers.append(user)
                    self.updateSelectedUI()
                }
                else {
                    cell.friendActionBtn.image = nil
                    self.removeUser(user)
                }
            }
        })
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        searchUsers()
        searchContacts()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        hideKeyboard()
        searchUsers()
        searchContacts()
        return false
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
    }
    
    func show(event:EventDetail) {
        self.event = event
        self.contacts = []
        self.users = []
        self.selectedContacts = []
        self.selectedUsers = []
        self.list.reloadData()
        
        if self.permissionView.permission.status == .Authorized {
            populateContacts()
        }
        
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = 0
        }
    }
    
    func hide() {
        searchField.text = ""
        hideKeyboard()
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = self.frame.height
        }
    }
    
    func hideKeyboard() {
        searchField.endEditing(true)
    }
    
    func configureUI() {
        
        frame.origin.y = frame.height
        
        searchField.delegate = self
        
        selectedList.registerNib(UINib(nibName: CellCondensedName, bundle: nil), forCellWithReuseIdentifier: CellCondensedName)
        selectedList.delegate = self
        selectedList.dataSource = self
        
        list.separatorStyle = .None
        list.separatorInset = UIEdgeInsetsZero
        list.registerNib(UINib(nibName: CellListName, bundle: nil), forCellReuseIdentifier: CellListName)
        list.delegate = self
        list.dataSource = self
        
        permissionView = PermissionContactsView.loadFromXib()
        permissionView.onNext = { status in
            mainQueue({
                if status == .Authorized {
                    self.populateContacts()
                    self.permissionView.hide()
                }
                else {
                    self.hide()
                }
            })
        }
        addSubview(permissionView)
        
        if !permissionView.shouldShow() {
            self.populateContacts()
            permissionView.hide()
        }
    }
    
    static func loadFromXib() -> FriendsView {
        let instance = NSBundle.mainBundle().loadNibNamed("FriendsView", owner: self, options: nil)!.first as! FriendsView
        instance.frame = UIScreen.mainScreen().bounds
        instance.configureUI()
        return instance
    }
}











