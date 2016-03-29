//
//  ViewController.swift
//  VideoPlayer
//
//  Created by sergey petrachkov on 17/03/16.
//  Copyright © 2016 sergey petrachkov. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class ViewController: UIViewController, MediaToolBarDelegate {

	var player : AVPlayer? = nil
	var playerLayer : AVPlayerLayer? = nil
	var asset : AVAsset? = nil
	var playerItem: AVPlayerItem? = nil
	var toolbar : MediaToolBar!;
	
	
	
	var button : UIButton = UIButton(type: .Custom);
	override func viewDidLoad() {
		super.viewDidLoad();
		let videoURLWithPath = "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"
		let videoURL = NSURL(string: videoURLWithPath)
		
		let playerView = SPVideoPlayer(frame: CGRectMake(0, 20, UIScreen.mainScreen().applicationFrame.width, 260), url: videoURL!);
		self.view.addSubview(playerView);
	}


	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
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

