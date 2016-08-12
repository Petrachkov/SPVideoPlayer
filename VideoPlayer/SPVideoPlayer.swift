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

class SPVideoPlayer : UIView, MediaToolBarDelegate, UIGestureRecognizerDelegate, UITableViewDelegate {
	//MARK: - UI Members -
	/// ui members
	var player : AVQueuePlayer? = nil
	var playerLayer : AVPlayerLayer? = nil
	var asset : AVAsset? = nil
	var playerItem: AVPlayerItem? = nil
	var toolbar : MediaToolBar!
	var observerInitialized : Bool = false;
	var menuView : MenuView!
	
	var plItems = [AVPlayerItem]();
	var loading : UIActivityIndicatorView!;
	var timeObserver : AnyObject!;
	var loadingInProgress: Bool = false;
	
	//MARK: - Constructors -
	///
	required override init(frame: CGRect) {
		super.init(frame: frame);
		self.backgroundColor = UIColor.clearColor()//UIColor(red: 200.0/255, green: 200.0/255, blue: 200.0/255, alpha: 1);
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	convenience init(frame: CGRect, videoItems: [PlayerItemModel]) {
		self.init(frame: frame);
		for pim: PlayerItemModel in videoItems {
			asset = AVAsset(URL: pim.url)
			playerItem = AVPlayerItem(asset: asset!)
			NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SPVideoPlayer.playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)
			plItems.append(playerItem!);
		}
		
		player = AVQueuePlayer(items: plItems);
		
		playerLayer = AVPlayerLayer(player: self.player)
		var height = frame.height;
		if (height <= 40){
			height = 240
		}
		playerLayer!.frame = CGRectMake(0, 0, frame.width, height);
		player?.actionAtItemEnd = .Advance;
		
		playerLayer?.videoGravity = "AVLayerVideoGravityResizeAspect";
		
		self.layer.addSublayer(self.playerLayer!)
		toolbar = MediaToolBar(frame: CGRectMake(0, playerLayer!.frame.maxY - 40, frame.width, 40));
		playerLayer?.setNeedsLayout();
		
		playerLayer?.backgroundColor = UIColor.blackColor().CGColor;
		
		
		toolbar.setNeedsLayout();
		toolbar.delegate = self;
		self.addSubview(toolbar);
		self.portraitFrame = self.frame;
		
		self.menuView = MenuView();
		self.addSubview(menuView);
		
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SPVideoPlayer.playerTapped(_:)));
		tapRecognizer.delegate = self;
		self.addGestureRecognizer(tapRecognizer);
		
		self.playerItems = videoItems;
		
		self.dataSource = PlayerTableDataSource(items: playerItems, _forMenu: true);
		self.menuView.dataSource = dataSource;
		let headerView = UIView(frame: CGRectMake(0,0, self.menuView.bounds.width, 40));
		let headerIcon = UIImageView();
		headerIcon.frame = CGRectMake(10,15, 20, 20);
		headerIcon.image = UIImage(named: "film-dark")
		
		headerView.addSubview(headerIcon);
		self.menuView.tableHeaderView = headerView;
		self.menuView.delegate = self;
		
		self.player?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil);
		
		
		
		self.loading = UIActivityIndicatorView();
		self.loading.frame = CGRectMake((self.frame.size.width/2) - self.loading.frame.size.width/2,
		                                (self.frame.size.height/2) - self.loading.frame.size.height/2,
		                                self.loading.frame.size.width,
		                                self.loading.frame.size.height);
		self.loading.startAnimating();
		self.addSubview(self.loading);
		
	}
	
	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if (object is AVQueuePlayer && keyPath == "status") {
			if(self.player == nil)
			{
				return;
			}
			if (self.player!.status == .ReadyToPlay) {
				self.loading.stopAnimating();
				self.toolbar.hidden = false;
				print("Ready to play!")
				
				if(!self.observerInitialized){
					self.timeObserver = player?.addPeriodicTimeObserverForInterval(CMTimeMake(1,1), queue: nil, usingBlock: {time in
						self.syncScrubber();
					});
					observerInitialized = true;
				}
				player!.play();
				self.toolbar.setPlaying();
				self.hideToolBar(1.5);
				
				
			} else if (self.player!.status == .Failed) {
				// something went wrong. player.error should contain some information
			}
		}
	}
	
	deinit{
		//		 NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidFinishPlaying:", name: AVPlayerItemDidPlayToEndTimeNotification, object: item)
		NSNotificationCenter.defaultCenter().removeObserver(self);
	}
	
	//MARK: - Functional members -
	///
	var toolBarDelegate : MediaToolBarDelegate!
	var dataSource : PlayerTableDataSource!
	var playerItems : [PlayerItemModel] = [PlayerItemModel]()
	
	
	func playerDidFinishPlaying(note: NSNotification) {
		
		//print("Player items count: \(self.player?.items().count)");
		if (self.player?.items().count == 1)
		{
			print("Last item played");
			if(self.toolbar.hidden){
				self.showToolBar();
			}
			self.toolbar.switchPlayingState();
			self.player?.pause();
			
			
			self.player?.removeAllItems();
			for item in self.plItems {
				item.seekToTime(kCMTimeZero);
				self.player?.insertItem(item, afterItem: self.player?.items().last);
			}
			self.playerLayer?.player = self.player;
			
			var userInfo = [NSObject:AnyObject]();
			userInfo[0] = 0;
			NSNotificationCenter.defaultCenter().postNotificationName("didFinishPlay",
			                                                          object: self,
			                                                          userInfo: userInfo);
			self.dataSource.setCurInd(0);
			self.menuView.reloadData();
			return;
		}
		
		
		var i=1;
		let fpim = note.object as! AVPlayerItem;
		for pim: AVPlayerItem in self.plItems {
			if (pim === fpim)
			{
				var userInfo = [NSObject:AnyObject]();
				userInfo[0] = i;
				NSNotificationCenter.defaultCenter().postNotificationName("didFinishPlay",
				                                                          object: self,
				                                                          userInfo: userInfo);
				self.dataSource.setCurInd(i);
				self.menuView.reloadData();
				break;
			}
			i += 1;
		}
	}
	
	internal func playTapped(toolBar: MediaToolBar) {
		if (menuView.isShown && UIDevice.currentDevice().orientation.isLandscape)
		{
			self.toolbar.showMenuButton();
		}
		
		menuView.hideView();
		if(!toolBar.playing){
			if(!self.observerInitialized){
				self.timeObserver = player?.addPeriodicTimeObserverForInterval(CMTimeMake(1,1), queue: nil, usingBlock: {time in
					self.syncScrubber();
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
		if (!menuView.isShown)
		{
			self.toolbar.hideMenuButton();
		}
		else
		{
			self.toolbar.showMenuButton();
		}
		menuView.switchState();
	}
	
	internal func emptySpaceTapped() {
		menuView.hideView();
		self.toolbar.showMenuButton();
		self.toolbar.hideMe();
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
	//
	var portraitFrame : CGRect!
	override func layoutSubviews() {
		
		self.loading.frame = CGRectMake((self.frame.size.width/2) - self.loading.frame.size.width/2,
		                                (self.frame.size.height/2) - self.loading.frame.size.height/2,
		                                self.loading.frame.size.width,
		                                self.loading.frame.size.height);
		
		
		if(UIDevice.currentDevice().orientation.isLandscape){
			self.frame = UIScreen.mainScreen().applicationFrame;
			var height = self.frame.height;
			if (height <= 40) {
				height = 240
			}
			toolbar.frame = CGRectMake(0, 0, self.frame.width, height)
			playerLayer!.frame = CGRectMake(0, 0, frame.width, height);
		}
		else{
			self.frame = self.portraitFrame;
			var height = self.frame.height;
			if (height <= 60){
				height = 260
			}
			playerLayer!.frame = CGRectMake(0, 0, frame.width, height);
			toolbar.frame = CGRectMake(0, 0, frame.width, height)
		}
		super.layoutSubviews();
	}
	
	func playerTapped(recognizer : UIGestureRecognizer){
		if (!loadingInProgress)
		{
			self.switchToolBarVisibility();
			self.menuView.hideView();
		}
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
		self.toolbar.hideMe();
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
		UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
			self.toolbar.hidden = false;
			self.toolbar.alpha = 1
			self.menuView.hideView()
			}, completion: {c in
				//				self.delay(3.0){
				//					self.hideToolBar();
				//				}
		});
		
	}
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		return (touch.view is SPVideoPlayer);
	}
	
	func syncScrubber(){
		
		
		let seconds = Float((self.player?.currentItem?.duration.seconds)!);
		
		
		
		if(!seconds.isNaN){
			self.toolbar.slider.maximumValue = seconds;
		}
		else{
			self.toolbar.fromStartLabel.text = ""
			self.toolbar.tilEndLabel.text = ""
			self.toolbar.slider.setValue(0, animated: true);
			return;
		}
		
		let duration = CGFloat(CMTimeGetSeconds((self.player?.currentItem?.duration)!)) ?? 0;
		if(duration.isFinite){
			let	time = CGFloat((self.player?.currentTime().seconds)!)
			self.toolbar.slider.setValue(Float(time), animated: true);
			self.toolbar.fromStartLabel.text = self.stringFromTimeInterval((self.player?.currentTime().seconds)!) as String
			self.toolbar.tilEndLabel.text = "-\(self.stringFromTimeInterval((self.player?.currentItem?.duration.seconds)! - (self.player?.currentTime().seconds)!) as String)"
		}
		if (self.loadingInProgress)
		{
			//usleep(1)
			self.loading.stopAnimating();
			self.loadingInProgress = false;
		}
	}
	
	
	//MARK: -TableViewDelegate-
	//
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		playVideo(self.playerItems[indexPath.row].url);
		self.menuView.switchState();
		
		var userInfo = [NSObject:AnyObject]();
		userInfo[0] = indexPath.row;
		NSNotificationCenter.defaultCenter().postNotificationName("didFinishPlay",
		                                                          object: self,
		                                                          userInfo: userInfo);
		
		self.dataSource.setCurInd(indexPath.row);
		self.menuView.reloadData();
	}
	
	func playVideo(videoUrl: NSURL)
	{
		self.playerLayer?.player = nil;
		self.loading.startAnimating();
		self.player?.pause();
		
		self.toolbar.hidden = true;
		
		self.toolbar.showMenuButton();
		
		loadingInProgress = true;
		if (observerInitialized)
		{
			player?.removeTimeObserver(self.timeObserver);
			observerInitialized = false;
		}
		
		self.player?.removeAllItems();
		self.asset = AVAsset(URL: videoUrl)
		self.playerItem = AVPlayerItem(asset: asset!)
		self.playerItem?.seekToTime(kCMTimeZero)
		self.player?.replaceCurrentItemWithPlayerItem(self.playerItem);
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SPVideoPlayer.playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.playerItem)
		self.playerLayer?.player = self.player;
		
		if(!self.observerInitialized){
			self.timeObserver = player?.addPeriodicTimeObserverForInterval(CMTimeMake(1,1), queue: nil, usingBlock: {time in
				self.syncScrubber();
			});
			observerInitialized = true;
		}
		player!.play()
		self.toolbar.setPlaying();
		let seconds = Float((self.playerItem?.duration.seconds)!);
		if(!seconds.isNaN){
			self.toolbar.slider.maximumValue = seconds;
		}
		self.toolbar.slider.setValue(0, animated: true);
		self.hideToolBar(1.5);
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 42
	}
	
	func freeAndNil(){
		self.player?.pause();
		self.plItems.removeAll();
		if(timeObserver != nil){
			self.player?.removeTimeObserver(timeObserver);
			timeObserver = nil;
		}
		self.dataSource = nil;
		NSNotificationCenter.defaultCenter().removeObserver(self);
		self.playerLayer?.delegate = nil;
		self.playerLayer?.removeFromSuperlayer();
		self.playerItem = nil;
		self.player = nil;
	}
}