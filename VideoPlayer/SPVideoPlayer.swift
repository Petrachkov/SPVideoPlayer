//
//  SPVideoPlayer.swift
//  VideoPlayer
//
//  Created by sergey petrachkov on 29/03/16.
//  Copyright © 2016 sergey petrachkov. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class SPVideoPlayer : UIView, MediaToolBarDelegate, UIGestureRecognizerDelegate {
	//MARK: - UI Members -
	/// ui members
	var player : AVPlayer? = nil
	var playerLayer : AVPlayerLayer? = nil
	var asset : AVAsset? = nil
	var playerItem: AVPlayerItem? = nil
	var toolbar : MediaToolBar!
	var observerInitialized : Bool = false;
	var menuView : MenuView!
	
	//MARK: - Constructors -
	///
	required override init(frame: CGRect) {
		super.init(frame: frame);
		self.backgroundColor = UIColor.clearColor()//UIColor(red: 200.0/255, green: 200.0/255, blue: 200.0/255, alpha: 1);
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	convenience init(frame: CGRect, url : NSURL) {
		self.init(frame: frame);
		asset = AVAsset(URL: url)
		playerItem = AVPlayerItem(asset: asset!)
		player = AVPlayer(playerItem: playerItem!);
		
		
		playerLayer = AVPlayerLayer(player: self.player)
		var height = frame.height;
		if (height <= 40){
			height = 240
		}
		playerLayer!.frame = CGRectMake(0, 0, frame.width, height);
		player?.actionAtItemEnd = .None
		self.layer.addSublayer(self.playerLayer!)
		
		toolbar = MediaToolBar(frame: CGRectMake(0, playerLayer!.frame.maxY - 40, frame.width, 40));
		playerLayer?.setNeedsLayout();
		toolbar.setNeedsLayout();
		toolbar.delegate = self;
		self.addSubview(toolbar);
		self.portraitFrame = self.frame;
		
		self.menuView = MenuView();
		self.addSubview(menuView);
		
		var tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("playerTapped:"));
		tapRecognizer.delegate = self;
		self.addGestureRecognizer(tapRecognizer);
	}
	
	//MARK: - Functional members -
	///
	var toolBarDelegate : MediaToolBarDelegate!
	
	internal func playTapped(toolBar: MediaToolBar) {
		if(!toolBar.playing){
			if(!self.observerInitialized){
				player?.addPeriodicTimeObserverForInterval(CMTimeMake(1,1), queue: nil, usingBlock: {time in
					
					// HERE IS WHAT YOU NEED TO ADJUST FOR VIDEOS. TODO: FIGURE OUT COMMON WAY
//					if((self.player?.currentItem?.duration.seconds.isNaN) != nil){
//						return;
//					}
					self.toolbar.fromStartLabel.text = self.stringFromTimeInterval((self.player?.currentTime().seconds)!) as String
					self.toolbar.tilEndLabel.text = "-\(self.stringFromTimeInterval((self.player?.currentItem?.duration.seconds)! - (self.player?.currentTime().seconds)!) as String)"
					self.toolbar.slider.maximumValue = Float((self.player?.currentItem?.duration.seconds)!);
					self.toolbar.slider.setValue(Float(self.player!.currentTime().seconds), animated: true);
				});
				observerInitialized = true;
			}
			player!.play()
			self.hideToolBar(1.5);
		}
		else{
			player!.pause();
		}
	}
	
	internal func dragDidEnd(slider: UISlider) {
		player?.pause();
		let seconds : Int64 = Int64(slider.value);
		let preferredTimeScale : Int32 = 1;
		let seekTime : CMTime = CMTimeMake(seconds, preferredTimeScale);
		player?.seekToTime(seekTime);
		if(self.toolbar.playing){
			player?.play();
		}
	}
	
	internal func menuTapped() {
		menuView.switchState();
	}
	
	func willRotateToOrientation(orientation : UIInterfaceOrientation){
		if (orientation == UIInterfaceOrientation.Portrait){
			menuView.hideView();
		}
	}
	
	func stringFromTimeInterval(interval:NSTimeInterval) -> NSString {
		if(interval.isNaN || interval.isInfinite){
			return NSString(string: "");
		}
		
		let ti = NSInteger(interval)
		let seconds = ti % 60
		let minutes = (ti / 60) % 60
		let hours = (ti / 3600)
		
		if (hours > 0){
			return NSString(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
		}
		else{
			return NSString(format: "%0.2d:%0.2d",minutes,seconds)
		}
	}
	
	func pause(){
		self.player?.pause();
	}

	
	//MARK: - UI logic-
	var portraitFrame : CGRect!
	override func layoutSubviews() {
		if(UIDevice.currentDevice().orientation != .Portrait){
			self.frame = UIScreen.mainScreen().applicationFrame;
			
			var height = self.frame.height;
			if (height <= 40) {
				height = 240
			}
			toolbar.frame = CGRectMake(0, 0, self.frame.width, 40)
			playerLayer!.frame = CGRectMake(0, toolbar.frame.maxY - 40, frame.width, height - 40);
		}
		else{
			self.frame = self.portraitFrame;
			
			var height = self.frame.height;
			if (height <= 60){
				height = 260
			}
			playerLayer!.frame = CGRectMake(0, 0, frame.width, height - 40);
			toolbar.frame = CGRectMake(0, playerLayer!.frame.maxY - 40, frame.width, 40)
		}
		
		super.layoutSubviews();
	}
	
	func playerTapped(recognizer : UIGestureRecognizer){
		self.switchToolBarVisibility();
		self.menuView.hideView();
	}
	
	func switchToolBarVisibility(){
		if(self.toolbar.hidden){
			showToolBar()
		}
		else{
			hideToolBar()
		}
	}
	
	func hideToolBar(delay : Double = 1){
		UIView.animateWithDuration(1, delay: delay, options: UIViewAnimationOptions.CurveLinear, animations: {
			self.toolbar.alpha = 0
			}, completion: {c in self.toolbar.hidden = true});
	}
	
	func delay(delay:Double, closure:()->()) {
		dispatch_after(
			dispatch_time(
				DISPATCH_TIME_NOW,
				Int64(delay * Double(NSEC_PER_SEC))
			),
			dispatch_get_main_queue(), closure)
	}
	
	func showToolBar(){
		UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
			self.toolbar.hidden = false;
			self.toolbar.alpha = 1
			}, completion: {c in
//				self.delay(3.0){
//					self.hideToolBar();
//				}
				});

	}
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		return (touch.view is SPVideoPlayer);
	}
}