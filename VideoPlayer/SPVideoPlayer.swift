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

class SPVideoPlayer : UIView, MediaToolBarDelegate {
	//MARK: - UI Members -
	/// ui members
	var player : AVPlayer? = nil
	var playerLayer : AVPlayerLayer? = nil
	var asset : AVAsset? = nil
	var playerItem: AVPlayerItem? = nil
	var toolbar : MediaToolBar!
	
	
	//MARK: - Constructors -
	///
	required override init(frame: CGRect) {
		super.init(frame: frame);
		self.backgroundColor = UIColor(red: 200.0/255, green: 200.0/255, blue: 200.0/255, alpha: 1);
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
		if (height <= 60){
			height = 260
		}
		playerLayer!.frame = CGRectMake(0, 0, frame.width, height - 60);
		player?.actionAtItemEnd = .None
		self.layer.addSublayer(self.playerLayer!)
		
		toolbar = MediaToolBar(frame: CGRectMake(0, playerLayer!.frame.maxY, frame.width, 60));
		toolbar.delegate = self;
		toolbar.setupLayout(true);
		self.addSubview(toolbar);
		
		player?.addPeriodicTimeObserverForInterval(CMTimeMake(1,1), queue: nil, usingBlock: {time in
			self.toolbar.fromStartLabel.text = self.stringFromTimeInterval((self.player?.currentTime().seconds)!) as String
			self.toolbar.tilEndLabel.text = "-\(self.stringFromTimeInterval((self.player?.currentItem?.duration.seconds)! - (self.player?.currentTime().seconds)!) as String)"
			self.toolbar.slider.maximumValue = Float((self.player?.currentItem?.duration.seconds)!);
			self.toolbar.slider.setValue(Float(self.player!.currentTime().seconds) /*/ Float(self.toolbar.slider.frame.width)*/, animated: true);
		});
	}
	
	//MARK: - Functional members -
	///
	var toolBarDelegate : MediaToolBarDelegate!
	
	func playTapped(toolBar: MediaToolBar) {
		if(!toolBar.playing){
			player!.play()
		}
		else{
			player!.pause();
		}
	}
	
	func dragDidEnd(slider: UISlider) {
		player?.pause();
		let seconds : Int64 = Int64(slider.value);
		let preferredTimeScale : Int32 = 1;
		let seekTime : CMTime = CMTimeMake(seconds, preferredTimeScale);
		player?.seekToTime(seekTime);
		player?.play();
	}
	
	func stringFromTimeInterval(interval:NSTimeInterval) -> NSString {
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
}