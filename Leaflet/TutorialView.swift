//
//  TutorialView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 8/14/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit

class TutorialView: UIView {
    
    @IBOutlet weak var tutorialImageView: UIImageView!
    @IBOutlet weak var tutorialHeadingLabel: UILabel!
    @IBOutlet weak var tutorialHeadingLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tutorialTextLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureStyle() {
        backgroundColor = TutorialBackgroundColor
        tutorialHeadingLabel.textColor = TutorialTextColor
        tutorialTextLabel.textColor = TutorialTextColor
    }
    
    func configureUI(image:UIImage, heading:String, text:String) {
        tutorialImageView.image = image
        tutorialHeadingLabel.text = heading
        tutorialTextLabel.text = text
    }
    
    static func loadFromXib() -> TutorialView {
        let instance = NSBundle.mainBundle().loadNibNamed("TutorialView", owner: self, options: nil)!.first as! TutorialView
        instance.frame = UIScreen.mainScreen().bounds
        instance.layoutIfNeeded()
        instance.configureStyle()
        return instance
    }
}

