//
//  MediaToolBar.swift
//  VideoPlayer
//
//  Created by sergey petrachkov on 29/03/16.
//  Copyright © 2016 sergey petrachkov. All rights reserved.
//

import Foundation
import UIKit

protocol MediaToolBarDelegate{
	func playTapped(toolBar: MediaToolBar);
}
class MediaToolBar : UIView{
	var backColor : UIColor? = UIColor(red: 126.0/255.0, green: 126.0/255, blue: 126.0/255, alpha: 1);
	
	var playButton : UIButton!;
	var expandButton : UIButton!;
	var menuButton : UIButton!;
	var slider : UISlider!;
	
	var delegate : MediaToolBarDelegate!;
	var playing : Bool = false;
	
	override init(frame: CGRect) {
		playButton = UIButton(type: .Custom);
		playButton.setImage(UIImage(named: "play"), forState: .Normal);
		
		
		expandButton = UIButton(type: .Custom);
		expandButton.setImage(UIImage(named:"expand"), forState: .Normal);
		
		menuButton = UIButton(type: .Custom);
		menuButton.setImage(UIImage(named: "menu"), forState: .Normal);
		
		slider = UISlider();
		slider.setMaximumTrackImage(UIImage(named: "slider-max")?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 4, 0, 4)), forState: .Normal);
		slider.setMinimumTrackImage(UIImage(named: "slider-min")?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 4, 0, 4)), forState: .Normal);
		slider.setThumbImage(UIImage(named: "slider-thumb"), forState: .Normal);
		slider.maximumValue = 10;
		slider.minimumValue = 0;
		slider.tintColor = UIColor.whiteColor();
		
		
		super.init(frame: frame);
		self.backgroundColor = self.backColor;
		self.addSubview(playButton);
		self.addSubview(slider);
		self.addSubview(expandButton);
		self.addSubview(menuButton);
		playButton.addTarget(self, action: "playTapped:", forControlEvents: .TouchUpInside);
	}
	
	func setupLayout(portrait : Bool)->Void{
		if (portrait){
			setupPortraitLayout();
		}
		else{
			setupLandscapeLayout();
		}
	}
	
	private func setupPortraitLayout() -> Void{
		self.playButton.frame = CGRectMake(10, 10, 40, 40);
		self.slider.frame = CGRectMake(60, 10, self.frame.width - 60 - 60, 40);
		self.expandButton.frame = CGRectMake(self.slider.frame.maxX + 10, 10, 40, 40);
	}
	
	private func setupLandscapeLayout() -> Void{
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func playTapped(button : UIButton){
		delegate.playTapped(self);
		playing = !playing;
		let img = playing ? UIImage(named:"pause") : UIImage(named: "play");
		button.setImage(img, forState: .Normal);
	}
	
	
//	
//	[self setMaximumTrackImage:[[UIImage imageNamed:@"VKScrubber_max"]
//	resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)]
//	forState:UIControlStateNormal];
//	[self setMinimumTrackImage:[[UIImage imageNamed:@"VKScrubber_min"]
//	resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)]
//	forState:UIControlStateNormal];
//	[self setThumbImage:[UIImage imageNamed:@"VKScrubber_thumb"]
//	forState:UIControlStateNormal];
//	
//	[self addTarget:self action:@selector(scrubbingBegin) forControlEvents:UIControlEventTouchDown];
//	[self addTarget:self action:@selector(scrubbingEnd) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
//	[self addTarget:self action:@selector(scrubberValueChanged) forControlEvents:UIControlEventValueChanged];
//	
//	self.exclusiveTouch = YES;
//}
//
//- (void)scrubbingBegin {
//	DDLogVerbose(@"SCRUBBER: Begin %f", self.value);
//	[self.delegate scrubbingBegin];
//	}
//	
//	- (void)scrubbingEnd {
//  DDLogVerbose(@"SCRUBBER: End %f", self.value);
//  [self.delegate scrubbingEnd];
//		}
//		
//		- (void)scrubberValueChanged {
//			DDLogVerbose(@"SCRUBBER: Change %f", self.value);
//}


}
