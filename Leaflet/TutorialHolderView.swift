//
//  TutorialHolderView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 9/11/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import Foundation
import UIKit

class TutorialHolderView: UIView {
    
    var onSkip:(()->Void)?
    var swipeView:UIView!
    var onTourBeforeAfter:((position:TutorialHolderViewPosition)->Void)?
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var dotOne: UIView!
    @IBOutlet weak var dotTwo: UIView!
    @IBOutlet weak var dotThree: UIView!
    
    var SelectedColor:UIColor = Color.fromHex("#667F66", alpha:1)
    var DefaultColor:UIColor = Color.fromHex("#CFD6DC", alpha:1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func handleSwipe(gesture:UISwipeGestureRecognizer) {
        if gesture.direction == UISwipeGestureRecognizerDirection.Right {
            if swipeView.frame.origin.x != 0 {
                UIView.animateWithDuration(DurationForUI, animations: {
                    self.swipeView.frame.origin.x += self.holderView.frame.width
                }) { (finished) in
                    self.updateDots()
                }
            }
            else {
                onTourBeforeAfter?(position: TutorialHolderViewPosition.BeforeFirst)
            }
        }
        
        else if gesture.direction == UISwipeGestureRecognizerDirection.Left {
            if swipeView.frame.origin.x != -swipeView.frame.width+holderView.frame.width {
               UIView.animateWithDuration(DurationForUI, animations: {
                    self.swipeView.frame.origin.x -= self.holderView.frame.width
                }) { (finished) in
                    self.updateDots()
                }
            }
            else {
                onTourBeforeAfter?(position: TutorialHolderViewPosition.AfterLast)
            }
        }
    }
    
    func handleSkip() {
        self.onSkip?()
    }
    
    func handleNext() {
        if swipeView.frame.origin.x != -swipeView.frame.width+holderView.frame.width {
            UIView.animateWithDuration(DurationForUI, animations: {
                 self.swipeView.frame.origin.x -= self.holderView.frame.width
            }) { (finished) in
                self.updateDots()
            }
        }
        else {
            onTourBeforeAfter?(position: TutorialHolderViewPosition.AfterLast)
        }
    }
    
    func reset() {
        displayViewAt(0)
    }
    
    func updateDots() {
        switch (abs(self.swipeView.frame.origin.x)/self.frame.width) {
            case 0:
                dotOne.backgroundColor = SelectedColor
                dotTwo.backgroundColor = DefaultColor
                dotThree.backgroundColor = DefaultColor
                break;
                
            case 1:
                dotOne.backgroundColor = DefaultColor
                dotTwo.backgroundColor = SelectedColor
                dotThree.backgroundColor = DefaultColor
                break;
                
            case 2:
                dotOne.backgroundColor = DefaultColor
                dotTwo.backgroundColor = DefaultColor
                dotThree.backgroundColor = SelectedColor
                break;
                
            default:
                dotOne.backgroundColor = DefaultColor
                dotTwo.backgroundColor = DefaultColor
                dotThree.backgroundColor = DefaultColor
                break;
        }
    }
    
    func displayViewAt(index:Int) {
        UIView.animateWithDuration(DurationForUI, animations: {
                self.swipeView.frame.origin.x = -CGFloat(index) * self.holderView.frame.width
            }) { (finished) in
                self.updateDots()
        }
    }
    
    func configureUI() {
        
        holderView.clipsToBounds = true
        
        nextBtn.addTarget(self, action: #selector(handleSkip), forControlEvents: UIControlEvents.TouchUpInside)
        
        swipeView = UIView()
        swipeView.frame = CGRectMake(0,0,holderView.frame.width * 3, holderView.frame.height)
        holderView.addSubview(swipeView)
        
        swipeView.addSubview({ () -> UIView in
            let tutorial:TutorialView = TutorialView.loadFromXib()
            tutorial.frame.origin.x = 0
            tutorial.configureUI(UIImage(named: "onboard-image-tutorial-1")!, heading: "Personalized\nRecommendations", text: "Discover curated itineraries for any day, any time. Itineraries are based on your preferences.")
            tutorial.tutorialHeadingLabelHeightConstraint.constant = 66
            return tutorial
        }())
        
        swipeView.addSubview({ () -> UIView in
            let tutorial:TutorialView = TutorialView.loadFromXib()
            tutorial.frame.origin.x = frame.width
            tutorial.configureUI(UIImage(named: "onboard-image-tutorial-2")!, heading: "Find out who’s coming", text: "Share your chosen itinerary with your friends or \(AppName) will find a small group nearby to join you.")
            return tutorial
        }())
        
        swipeView.addSubview({ () -> UIView in
            let tutorial:TutorialView = TutorialView.loadFromXib()
            tutorial.frame.origin.x = frame.width * 2
            tutorial.configureUI(UIImage(named: "onboard-image-tutorial-3")!, heading: "Less Planning, More Doing", text: "Once all attendees have confirmed, a group chat opens. Since the plans have already been made, you can chat about anything other than when and where.")
            return tutorial
        }())
        
        swipeView.userInteractionEnabled = true
        swipeView.addGestureRecognizer({ () -> UISwipeGestureRecognizer in
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            gesture.direction = UISwipeGestureRecognizerDirection.Right
            return gesture
        }())
        swipeView.addGestureRecognizer({ () -> UISwipeGestureRecognizer in
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            gesture.direction = UISwipeGestureRecognizerDirection.Left
            return gesture
        }())
    }
    
    static func loadFromXib() -> TutorialHolderView {
        let instance = NSBundle.mainBundle().loadNibNamed("TutorialHolderView", owner: self, options: nil)!.first as! TutorialHolderView
        instance.frame = UIScreen.mainScreen().bounds
        instance.layoutIfNeeded()
        instance.configureUI()
        return instance
    }
}

enum TutorialHolderViewPosition {
    case BeforeFirst
    case AfterLast
}

