//
//  FBConnectView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 8/14/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import AVFoundation

class FBConnectView: UIView, PlayerViewDelegate {
    
    @IBOutlet weak var connectBtn: UIView!
    @IBOutlet weak var legalLabel: UILabel!
    @IBOutlet weak var videoOverlay: UIView!
    @IBOutlet weak var videoView: UIView!
    
    var FB:Facebook = Facebook()
    var onSkip:(()->Void)?
    var termsView:TermsView!
    
    var player:AVPlayer!
    private var playerLayer:AVPlayerLayer!
    
    @IBAction func onSkipHandler(sender: AnyObject) {
        onSkip?()
    }
    
    @IBAction func onTerms(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: TermsURL)!)
    }
    
    @IBAction func onPrivacy(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: PrivacyURL)!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showTerms() {
        UIApplication.sharedApplication().openURL(NSURL(string: TermsURL)!)
    }
    
    func playerVideo(playerFinished player: PlayerView) {
        player.player?.currentItem?.seekToTime(kCMTimeZero)
        player.play()
    }
    
    func configureStyle() {
        backgroundColor = TutorialBackgroundColor
        legalLabel.textColor = LegalTextColor
        connectBtn.addSubview({ () -> UIView in
            let button = FB.getButton()
            button.frame = connectBtn.bounds
            return button
        }())
    }
    
    func configureUI() {
        FB.onLogin = { (result) -> Void in
            self.FB.retrieveUser { (fbUser) in
            }
        }
        
        termsView = TermsView.loadFromXib()
        addSubview(termsView)
        
        let legalA:NSMutableAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: "By connecting, I agree to \(AppName)'s ", attributes: [
            NSFontAttributeName: UIFont(name: FontNameRegular, size:13)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]))
        
        let legalB:NSMutableAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: "Terms of Service", attributes: [
            NSFontAttributeName: UIFont(name: FontNameBold, size:13)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]))
        
        let legalC:NSMutableAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: " and ", attributes: [
            NSFontAttributeName: UIFont(name: FontNameRegular, size:13)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]))

        let legalD:NSMutableAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: "Privacy Policy", attributes: [
            NSFontAttributeName: UIFont(name: FontNameBold, size:13)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]))
        
        let legalText:NSMutableAttributedString = NSMutableAttributedString()
        legalText.appendAttributedString(legalA)
        legalText.appendAttributedString(legalB)
        legalText.appendAttributedString(legalC)
        legalText.appendAttributedString(legalD)
        
        legalLabel.attributedText = legalText
    }

    func configureVideo() {
        player = AVPlayer(URL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("splash", ofType: "mp4")!))
        player.muted = true
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = bounds
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer.insertSublayer(playerLayer, atIndex: 0)
        
        loopVideo(player)
        player.play()
    }
    
    func loopVideo(videoPlayer: AVPlayer) {
        NSNotificationCenter.defaultCenter().addObserverForName(AVPlayerItemDidPlayToEndTimeNotification, object: nil, queue: nil) { notification in
            videoPlayer.seekToTime(kCMTimeZero)
            videoPlayer.play()
        }
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidBecomeActiveNotification, object: nil, queue: nil) { notification in
            videoPlayer.play()
        }
    }
    
    static func loadFromXib() -> FBConnectView {
        let instance = NSBundle.mainBundle().loadNibNamed("FBConnectView", owner: self, options: nil)!.first as! FBConnectView
        instance.frame = UIScreen.mainScreen().bounds
        instance.layoutIfNeeded()
        instance.configureStyle()
        instance.configureUI()
        instance.configureVideo()
        return instance
    }
}


