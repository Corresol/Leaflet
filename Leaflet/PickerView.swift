//
//  PickerView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/27/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class PickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var holder: UIView!
    @IBOutlet weak var picker: UIPickerView!
    
    var data:[String] = []
    var onDone:((value:String)->Void)?
    
    @IBAction func onClose(sender: AnyObject) {
        hide()
        onDone?(value: data[picker.selectedRowInComponent(0)])
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func useData(data:[String]) {
        self.data = data
        self.picker?.reloadComponent(0)
    }
    
    func show() {
        hidden = false
        UIView.animateWithDuration(DurationForUI, animations: {
            self.alpha = 1
        }) { (finished) in
            UIView.animateWithDuration(DurationForUI, animations: {
                self.holder.frame.origin.y = self.frame.height-self.holder.frame.height
                }, completion: { (finished) in
            })
        }
    }
    
    func hide() {
        UIView.animateWithDuration(DurationForUI, animations: {
            self.alpha = 0
            self.holder.frame.origin.y = self.frame.height
        }) { (finished) in
            self.hidden = true
        }
    }
    
    func configureUI() {
        self.hidden = true
        self.alpha = 0
        self.holder.frame.origin.y = self.frame.height
        self.picker.delegate = self
        self.picker.dataSource = self
    }
    
    static func loadFromXib() -> PickerView {
        let instance = NSBundle.mainBundle().loadNibNamed("PickerView", owner: self, options: nil)!.first as! PickerView
        instance.frame = UIScreen.mainScreen().bounds
        instance.layoutIfNeeded()
        instance.configureUI()
        return instance
    }
}
