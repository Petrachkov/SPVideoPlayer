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
	
	
	
	
	var button : UIButton = UIButton(type: .Custom);
	override func viewDidLoad() {
		super.viewDidLoad();
//		button.frame = CGRectMake(0, 70, 120, 80);
//		button.setTitle("play", forState: .Normal);
//		button.setTitleColor(UIColor.blueColor(), forState: .Normal);
//		button.addTarget(self, action: #selector(ViewController.tapHandler(_:)), forControlEvents: UIControlEvents.TouchUpInside);
//		self.view.addSubview(button);
		let videoURLWithPath = "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"
		let videoURL = NSURL(string: videoURLWithPath)
		let container = UIView(frame: CGRectMake(0, 20, UIScreen.mainScreen().applicationFrame.width, 200));
		container.backgroundColor = UIColor(red: 200.0/255, green: 200.0/255, blue: 200.0/255, alpha: 1);
		asset = AVAsset(URL: videoURL!)
		playerItem = AVPlayerItem(asset: asset!)
		
		player = AVPlayer(playerItem: self.playerItem!)
		//playerLayer?.backgroundColor = UIColor.blackColor().CGColor;
		
		
		playerLayer = AVPlayerLayer(player: self.player)
		playerLayer!.frame = CGRectMake(0, 0, UIScreen.mainScreen().applicationFrame.width, 200);
		player?.actionAtItemEnd = .None
		container.layer.addSublayer(self.playerLayer!)
		
		let toolbar = MediaToolBar(frame: CGRectMake(0,220,UIScreen.mainScreen().applicationFrame.width,60));
		toolbar.delegate = self;
		toolbar.setupLayout(true);
		self.view.addSubview(toolbar);
		self.view.addSubview(container);
	}

	func tapHandler(button : UIButton){
		let seconds : Int64 = 0
		let preferredTimeScale : Int32 = 1
		let seekTime : CMTime = CMTimeMake(seconds, preferredTimeScale)
		player!.seekToTime(seekTime)
		player!.play()
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func playTapped(toolBar: MediaToolBar) {
//		let seconds : Int64 = 0
//		let preferredTimeScale : Int32 = 1
//		let seekTime : CMTime = CMTimeMake(seconds, preferredTimeScale)
//		player!.seekToTime(seekTime)
		if(!toolBar.playing){
			let seconds : Int64 = 0
					let preferredTimeScale : Int32 = 1
					let seekTime : CMTime = CMTimeMake(seconds, preferredTimeScale)
			player!.play()
		}
		else{
			player!.pause();
		}
	}

}

