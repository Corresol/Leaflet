//
//  HeaderView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/6/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    @IBOutlet weak var holderView: UIView!
    
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var leftBtnText: UIButton!
    @IBOutlet weak var leftTapArea: UIView!
    
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var rightBtnText: UIButton!
    @IBOutlet weak var rightTapArea: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    var onLeftNav:(()->Void)?
    var onRightNav:(()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func leftBtnHandler() {
        onLeftNav?()
    }
    
    func rightBtnHandler() {
        onRightNav?()
    }
    
    func configureStyle() {
        leftBtn.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        rightBtn.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        holderView.layer.masksToBounds = false
        holderView.layer.shadowOffset = CGSizeMake(0, 2);
        holderView.layer.shadowRadius = 5
        holderView.layer.shadowOpacity = 0.2;
        holderView.layer.addSublayer({ () -> CALayer in
            let border = CALayer()
            border.frame = CGRectMake(0, 0, frame.width, 1)
            border.frame.origin.y = holderView.frame.height - border.frame.height
            border.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor
            return border
        }())
        
        leftBtn.addTarget(self, action: #selector(leftBtnHandler), forControlEvents: UIControlEvents.TouchUpInside)
        rightBtn.addTarget(self, action: #selector(rightBtnHandler), forControlEvents: UIControlEvents.TouchUpInside)
        
        leftBtnText.addTarget(self, action: #selector(leftBtnHandler), forControlEvents: UIControlEvents.TouchUpInside)
        rightBtnText.addTarget(self, action: #selector(rightBtnHandler), forControlEvents: UIControlEvents.TouchUpInside)
        
        leftTapArea.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leftBtnHandler)))
        rightTapArea.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightBtnHandler)))
    }
    
    static func loadFromXib() -> HeaderView {
        let instance = NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil)!.first as! HeaderView
        instance.frame = UIScreen.mainScreen().bounds
        instance.frame.size.height = HeaderHeight
        instance.configureStyle()
        return instance
    }
}
