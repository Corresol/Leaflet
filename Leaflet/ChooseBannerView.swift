//
//  ChooseBannerView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/27/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class ChooseBannerView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var list: UICollectionView!
    
    var page:NSNumber = 0
    var banners:[NSDictionary] = []
    var bannerPreview:ChooseBannerPreview!
    var previewBannerURL:String = ""
    
    var onBanner:((url:String)->Void)?
    
    @IBAction func onClose(sender: AnyObject) {
        hide()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        endEditing(true)
        if search.text != "" {
            page = 0
            banners = []
            list.reloadData()
            searchForBanners()
        }
        return false
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        endEditing(true)
        previewBannerURL = (banners[indexPath.row]["media"] as! JSON).asString!
        bannerPreview.preview.image = nil
        bannerPreview.preview.loadImageFromURL(NSURL(string:previewBannerURL)!)
        bannerPreview.show()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ChooseBannerCell", forIndexPath: indexPath) as! ChooseBannerCell
        cell.thumbnail.loadImageFromURL(NSURL(string: (banners[indexPath.row]["thumbnail"] as! JSON).asString!)!)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }
    
    func searchForBanners() {
        let params = ["q": "\(search.text)", "page": page, "per_page": 50]
        do {
            let request = try HTTP.POST("http://tackapi.com:8083/api/v1/media/image/search/bing", parameters: params)
            request.onFinish = { response in
                let results = JSON(string:response.text!)
                let images = results["services"]["bing"]["images"].asArray
                
                // Replace any existing images
                if self.page == 0 {
                    self.banners = []
                }
                
                for image in images! {
                    self.banners.append(image.asDictionary!)
                }
                
                dispatch_async(dispatch_get_main_queue(), { 
                    self.list.reloadData()
                })
            }
            request.start()
        }
        catch let error {
            print(error)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.tag == 0 {
            let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
            if (bottomEdge == scrollView.contentSize.height) {
                page = page.integerValue + 1
                searchForBanners()
            }
        }
    }
    
    func clear() {
        page = 0
        search.text = ""
        banners = []
        list.reloadData()
    }
    
    func show() {
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = 0
        }
    }
    
    func hide() {
        endEditing(true)
        clear()
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = self.frame.height
        }
    }
    
    func configureUI() {
        frame.origin.y = frame.height
        
        list.delegate = self
        list.dataSource = self
        list.registerNib(UINib(nibName: "ChooseBannerCell", bundle: nil), forCellWithReuseIdentifier: "ChooseBannerCell")
        
        search.delegate = self
        
        bannerPreview = ChooseBannerPreview.loadFromXib()
        bannerPreview.onSelected = { () in
            self.onBanner?(url:self.previewBannerURL)
            self.hide()
        }
        addSubview(bannerPreview)
    }
    
    static func loadFromXib() -> ChooseBannerView {
        let instance = NSBundle.mainBundle().loadNibNamed("ChooseBannerView", owner: self, options: nil)!.first as! ChooseBannerView
        instance.frame = UIScreen.mainScreen().bounds
        instance.configureUI()
        return instance
    }
}

