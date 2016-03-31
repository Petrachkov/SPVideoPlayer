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

class ViewController: UIViewController {
	var playerView : SPVideoPlayer!;
	override func viewDidLoad() {
		super.viewDidLoad();
		let videoURLWithPath =  "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"
		let videoURL = NSURL(string: videoURLWithPath)
		self.playerView = SPVideoPlayer(frame: CGRectMake(0, 20, UIScreen.mainScreen().applicationFrame.width, 240), url: videoURL!);
		self.view.addSubview(playerView);
		self.view.setNeedsLayout()
	}


	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
		override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
			self.view.layoutSubviews()
			self.playerView.layoutSubviews()
			super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration);
		}
		
}

