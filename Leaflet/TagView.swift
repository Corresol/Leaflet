//
//  TagView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/27/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit
import Parse

class TagView:  UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var tagList: UICollectionView!
    @IBOutlet weak var selectedTagList: UICollectionView!
    @IBOutlet weak var tagListTopConstraint: NSLayoutConstraint!
    
    let HeaderHeight:CGFloat = 80
    let TagMinWidth:CGFloat = 80
    let TagHeight:CGFloat = 40
    let TagFontSize:CGFloat = 17
    let TagHorizontalOffsets:CGFloat = 16
    let TagVerticalOffsets:CGFloat = 16
    let TagBreathingRoom:CGFloat = 10
    let TagSelectedHeight:CGFloat = 100
    
    var tagsSize:[CGSize] = []
    var tags:[String] = []
    var tagsSelected:[String] = []
    var tagsData:[PFObject] = []
    
    var onTagSelectionComplete:((tags:[String])->Void)?
    
    @IBAction func onClose(sender: AnyObject) {
        hide()
        onTagSelectionComplete?(tags: tagsSelected)
    }
    
    func addTag(tag:String) {
        if !tagsSelected.contains(tag) {
            tagsSelected.append(tag)
        }
        tagList.reloadData()
        selectedTagList.reloadData()
        
        if tagsSelected.count > 0 {
            tagListTopConstraint.constant = TagSelectedHeight
        }
        else {
            tagListTopConstraint.constant = 0
        }
        
        UIView.animateWithDuration(DurationForUI) { 
            self.layoutIfNeeded()
        }
        
    }
    
    func removeTag(tag:String) {
        var indexToRemove:Int = -1
        for (index,t) in tagsSelected.enumerate() {
            if t == tag {
                indexToRemove = index
            }
        }
        
        if indexToRemove != -1 {
            tagsSelected.removeAtIndex(indexToRemove)
        }
        tagList.reloadData()
        selectedTagList.reloadData()
        
        if tagsSelected.count > 0 {
            tagListTopConstraint.constant = TagSelectedHeight
        }
        else {
            tagListTopConstraint.constant = 0
        }
        
        UIView.animateWithDuration(DurationForUI) {
            self.layoutIfNeeded()
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return tags.count
        }
        else {
            return tagsSelected.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TagCollectionCell", forIndexPath: indexPath) as! TagCollectionCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let currentCell = cell as! TagCollectionCell
        currentCell.tagLabel.layer.masksToBounds = true
        currentCell.tagLabel.layer.cornerRadius = TagHeight/2
        currentCell.tagLabel.layer.borderWidth = 2
        currentCell.tagLabel.layer.borderColor = TagColor.CGColor
        currentCell.tagLabel.text = collectionView.tag == 0 ? tags[indexPath.row] : tagsSelected[indexPath.row]
        
        if !tagsSelected.contains(currentCell.tagLabel.text!) {
            currentCell.tagLabel.backgroundColor = UIColor.clearColor()
            currentCell.tagLabel.textColor = TagColor
        }
        else {
            currentCell.tagLabel.backgroundColor = TagColor
            currentCell.tagLabel.textColor = UIColor.whiteColor()
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if tagsSize.count <= indexPath.row {
            let computeLabel = UILabel()
            computeLabel.font = UIFont(name: FontNameRegular, size: TagFontSize)
            computeLabel.text = tags[indexPath.row]
            
            var computedWidth = computeLabel.intrinsicContentSize().width
            computedWidth = computedWidth < TagMinWidth ? TagMinWidth : computedWidth
            
            let size = CGSize(width: computedWidth + TagBreathingRoom + TagHorizontalOffsets, height: TagHeight + TagVerticalOffsets)
            tagsSize.append(size)
            return size
        }
        else {
            return tagsSize[indexPath.row]
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! TagCollectionCell
        if cell.tagLabel.backgroundColor == TagColor {
            cell.tagLabel.backgroundColor = UIColor.clearColor()
            cell.tagLabel.textColor = TagColor
            removeTag(cell.tagLabel.text!)
        }
        else {
            cell.tagLabel.backgroundColor = TagColor
            cell.tagLabel.textColor = UIColor.whiteColor()
            addTag(cell.tagLabel.text!)
        }
    }
    
    func configureUI() {
        frame.origin.y = frame.height
        tagList.tag = 0
        tagList.delegate = self
        tagList.dataSource = self
        tagList.registerNib(UINib(nibName: "TagCollectionCell", bundle: nil), forCellWithReuseIdentifier: "TagCollectionCell")
        tagList.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        selectedTagList.tag = 1
        selectedTagList.delegate = self
        selectedTagList.dataSource = self
        selectedTagList.registerNib(UINib(nibName: "TagCollectionCell", bundle: nil), forCellWithReuseIdentifier: "TagCollectionCell")
        selectedTagList.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    func populateUI() {
        tags = []
        tagList.reloadData()
        
        let query = PFQuery(className: "EventTags")
        query.limit = 500
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                if objects != nil {
                    for object: PFObject in objects! {
                        self.tags.append(object.valueForKey("tag") as! String)
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tagList.reloadData()
                    })
                }
            }
            else {
                print(error)
            }
        }
    }
    
    func show() {
        tagList.reloadData()
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = 0
        }
    }
    
    func hide() {
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = self.frame.height
        }
    }
    
    static func loadFromXib() -> TagView {
        let instance = NSBundle.mainBundle().loadNibNamed("TagView", owner: self, options: nil)!.first as! TagView
        instance.frame = UIScreen.mainScreen().bounds
        instance.layoutIfNeeded()
        instance.configureUI()
        return instance
    }
}


