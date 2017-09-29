//
//  CreateBundleView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/26/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class CreateBundleView: UIView {

    @IBOutlet weak var banner: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var priority: UITextField!
    @IBOutlet weak var holderView: UIScrollView!
    
    var chooseBannerView:ChooseBannerView!

    @IBAction func onClose(sender: AnyObject) {
        hide()
    }

    @IBAction func onSave(sender: AnyObject) {
        
        let bundle = EventBundle()
        bundle.setValue(banner.text, forKey: "banner")
        bundle.setValue(name.text, forKey: "heading")
        bundle.setValue(priority.text != "" ? Int(priority.text!) : 0, forKey: "priority")
        bundle.setValue([], forKey: "events")
        bundle.saveInBackground()
        
        hideKeyboard()
        AttentionView.displayBanner("Bundle created!")
        MainView.instance?.bundlesView.pullToRefresh()
        clear()
    }
    
    @IBAction func onBannerSearch(sender: AnyObject) {
        hideKeyboard()
        chooseBannerView.show()
    }
    
    func clear() {
        banner.text = ""
        name.text = ""
        priority.text = ""
    }
    
    func show() {
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = 0
        }
    }
    
    func hide() {
        hideKeyboard()
        clear()
        UIView.animateWithDuration(DurationForUI) {
            self.frame.origin.y = self.frame.height
        }
    }
    
    func hideKeyboard() {
        endEditing(true)
    }
    
    func configureUI() {
        frame.origin.y = frame.height
        chooseBannerView = ChooseBannerView.loadFromXib()
        chooseBannerView.onBanner = { url in
            self.banner.text = url
        }
        addSubview(chooseBannerView)
        holderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    static func loadFromXib() -> CreateBundleView {
        let instance = NSBundle.mainBundle().loadNibNamed("CreateBundleView", owner: self, options: nil)!.first as! CreateBundleView
        instance.frame = UIScreen.mainScreen().bounds
        instance.configureUI()
        return instance
    }
}



