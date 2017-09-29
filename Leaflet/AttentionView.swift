//
//  AttentionView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 11/9/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit
import Foundation

struct AttentionView {
    
    static func displayBanner(message: String) {
        let screenSize = UIScreen.mainScreen().bounds;
        
        let label = UILabel(frame: CGRectMake(0, 0, screenSize.width, 50))
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: FontNameLight, size: 16);
        label.textColor = UIColor.whiteColor()
        label.text = message;
        label.numberOfLines = 0
        
        let view = UIView(frame: label.frame);
        view.addSubview(label)
        view.backgroundColor = BannerColor
        
        let labelView = label.sizeThatFits(CGSizeMake(screenSize.width-60, CGFloat.max))
        label.frame = CGRectMake(30, 25, screenSize.width-60, labelView.height)
        
        view.frame  = label.frame
        view.frame.size.height += 50
        view.frame.size.width += 60
        view.frame.origin.x -= 30
        view.frame.origin.y = screenSize.height
        
        MainView.instance?.addSubview(view)
        
        UIView.animateWithDuration(0.8,
                                   delay: 0.0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 1.0,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    view.frame.origin.y = screenSize.height-view.frame.size.height
            },
                                   completion: { (finished: Bool) in
                                    UIView.animateWithDuration(0.2,
                                                               delay: 1.0,
                                                               options: .CurveEaseOut,
                                                               animations: {
                                                                view.frame.origin.y = screenSize.height
                                        },
                                                               completion: { (finished: Bool) in
                                                                view.removeFromSuperview()
                                        }
                                    );
            }
        );
    }
}
