//
//  ChooseTagView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/6/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit
import Foundation
import Parse

class ChooseTagView: UIView, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var headerSubtitle: UILabel!
    
    @IBOutlet weak var tagList: UICollectionView!
    
    @IBOutlet weak var selectedTagList: UICollectionView!
    @IBOutlet weak var tagListTopConstraint: NSLayoutConstraint!
    
    let TagMinWidth:CGFloat = 80
    let TagHeight:CGFloat = 40
    let TagFontSize:CGFloat = 17
    let TagHorizontalOffsets:CGFloat = 16
    let TagVerticalOffsets:CGFloat = 16
    let TagBreathingRoom:CGFloat = 10
    let TagSelectedHeight:CGFloat = 70
    
    var ignoreTagLimit:Bool = false
    var TagLimit:Int = 10
    
    var tagsSize:[CGSize] = []
    var selectedTagsSize:[CGSize] = []
    
    var tags:[String] = []
    var tagsSelected:[String] = []
    var tagsData:[PFObject] = []
    var onNext:(()->Void)?
    var filteredTags:[String] = []
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var selectedField: UITextField!
    
    @IBAction func onNextHandler(sender: AnyObject) {
        if tagsSelected.count >= TagLimit || ignoreTagLimit {
            onNext?()
            hideKeyboard()
            tagsSelected = []
            tagList.reloadData()
        }
        else {
            AttentionView.displayBanner("Must choose at least 10 tags")
        }
    }
    
    func hideKeyboard() {
        searchField.endEditing(true)
        selectedField.endEditing(true)
    }
    
    func clear() {
        searchField.text = ""
        tagsSelected = []
        filteredTags = tags
        tagsSize = []
        tagList.reloadData()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {
            let text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            if text == "" {
                filteredTags = tags
            }
            else {
                var matchedTags:[String] = []
                for tag in tags {
                    if tag.lowercaseString.containsString(text.lowercaseString) {
                        matchedTags.append(tag)
                    }
                }
                filteredTags = matchedTags
            }
            
            mainQueue({
                self.tagsSize = []
                self.tagList.reloadData()
            })
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchField.endEditing(true)
        selectedField.endEditing(true)
        
        if textField.tag == 1 {
            tagsSelected = selectedField.text!.componentsSeparatedByString(",")
            tagsSelected = tagsSelected.count > 0 && tagsSelected[tagsSelected.count-1] != "" ? tagsSelected : []
            
            self.selectedTagList.reloadData()
            self.tagList.reloadData()
            
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
        
        return false
    }
    
    func addTag(tag:String) {
        if !tagsSelected.contains(tag) {
            tagsSelected.append(tag)
            filteredTags.append(tag)
        }
        
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
        
        selectedField.text = tagsSelected.reverse().joinWithSeparator(",")
        
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
        
        selectedField.text = tagsSelected.reverse().joinWithSeparator(",")
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView.tag == 0 ? filteredTags.count : 0 //tagsSelected.count
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
        currentCell.tagLabel.text = collectionView.tag == 0 ? filteredTags[indexPath.row] : tagsSelected[indexPath.row]
        
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
        if collectionView.tag == 0 {
            if tagsSize.count <= indexPath.row && filteredTags.count > indexPath.row {
                let computeLabel = UILabel()
                computeLabel.font = UIFont(name: FontNameRegular, size: TagFontSize)
                computeLabel.text = filteredTags[indexPath.row]
                
                var computedWidth = computeLabel.intrinsicContentSize().width
                computedWidth = computedWidth < TagMinWidth ? TagMinWidth : computedWidth
                
                let size = CGSize(width: computedWidth + TagBreathingRoom + TagHorizontalOffsets, height: TagHeight + TagVerticalOffsets)
                tagsSize.append(size)
                return size
            }
            else if filteredTags.count > indexPath.row  {
                return tagsSize[indexPath.row]
            }
        }
        else {
            let computeLabel = UILabel()
            computeLabel.font = UIFont(name: FontNameRegular, size: TagFontSize)
            computeLabel.text = tagsSelected[indexPath.row]
            
            var computedWidth = computeLabel.intrinsicContentSize().width
            computedWidth = computedWidth < TagMinWidth ? TagMinWidth : computedWidth
            
            let size = CGSize(width: computedWidth + TagBreathingRoom + TagHorizontalOffsets, height: TagHeight + TagVerticalOffsets)
            return size
        }
        
        return CGSize(width: TagBreathingRoom + TagHorizontalOffsets, height: TagHeight + TagVerticalOffsets)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        hideKeyboard()
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        hideKeyboard()
        selectedField.text = tagsSelected.reverse().joinWithSeparator(",")
    }
    
    func configureUI() {
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
        
        searchField.tag = 0
        searchField.delegate  = self
        
        selectedField.tag = 1
        selectedField.delegate = self
    }
    
    func populateUI() {
        let query = PFQuery(className: "EventTags")
        query.limit = 500
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
            self.tags = []
            self.filteredTags = []
            self.tagList.reloadData()
        
            
            if error == nil {
                if objects != nil {
                    for object: PFObject in objects! {
                        self.tags.append(object.valueForKey("tag") as! String)
                        self.filteredTags.append(object.valueForKey("tag") as! String)
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
        
        selectedField.text = tagsSelected.reverse().joinWithSeparator(",")
        selectedTagList.reloadData()
        tagList.reloadData()
        
        if tagsSelected.count > 0 {
            tagListTopConstraint.constant = TagSelectedHeight
        }
        else {
            tagListTopConstraint.constant = 0
        }
        
        UIView.animateWithDuration(DurationForUI) {
            self.layoutIfNeeded()
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
    
    
    static func loadFromXib() -> ChooseTagView {
        let instance = NSBundle.mainBundle().loadNibNamed("ChooseTagView", owner: self, options: nil)!.first as! ChooseTagView
        instance.frame = UIScreen.mainScreen().bounds
        instance.layoutIfNeeded()
        instance.configureUI()
        instance.populateUI()
        return instance
    }
}





