//
//  MediaToolBar.swift
//  VideoPlayer
//
//  Created by sergey petrachkov on 29/03/16.
//  Copyright © 2016 sergey petrachkov. All rights reserved.
//

import Foundation
import UIKit


class MediaToolBar : UIView{
	var backColor : UIColor? = UIColor(red: 126.0/255.0, green: 126.0/255, blue: 126.0/255, alpha: 0.8);
	
	var playButton : UIButton!;
	var expandButton : UIButton!;
	var menuButton : UIButton!;
	var slider : UISlider!;
	
	var delegate : MediaToolBarDelegate!;
	var playing : Bool = false;
	
	var fromStartLabel : UILabel!;
	var tilEndLabel : UILabel!;
	
	var blur : UIVisualEffectView!
	override init(frame: CGRect) {
		playButton = UIButton(type: .Custom);
		playButton.setImage(UIImage(named: "play"), forState: .Normal);
		
		
		expandButton = UIButton(type: .Custom);
		expandButton.setImage(UIImage(named:"resize"), forState: .Normal);
		
		menuButton = UIButton(type: .Custom);
		menuButton.setImage(UIImage(named: "menu"), forState: .Normal);
		
		slider = UISlider();
		slider.setMaximumTrackImage(UIImage(named: "slider-max")?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 4, 0, 4)), forState: .Normal);
		slider.setMinimumTrackImage(UIImage(named: "slider-min")?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 4, 0, 4)), forState: .Normal);
		slider.setThumbImage(UIImage(named: "slider-thumb"), forState: .Normal);
		slider.maximumValue = 10;
		slider.minimumValue = 0;
		slider.tintColor = UIColor.whiteColor();
		slider.continuous = true;
		
		fromStartLabel = UILabel();
		tilEndLabel = UILabel();
		
		fromStartLabel.textColor = UIColor.whiteColor();
		tilEndLabel.textColor = UIColor.whiteColor();
		
		fromStartLabel.font = UIFont.systemFontOfSize(14);
		tilEndLabel.font = UIFont.systemFontOfSize(14);
		
		super.init(frame: frame);
		
		let blureffect:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
		blur = UIVisualEffectView (effect: blureffect)
		blur.frame = frame
		addSubview(blur)
		
		self.backgroundColor = self.backColor;
		self.addSubview(playButton);
		self.addSubview(slider);
		self.addSubview(expandButton);
		self.addSubview(menuButton);
		self.addSubview(fromStartLabel);
		self.addSubview(tilEndLabel);
		self.addSubview(self.menuButton);
		playButton.addTarget(self, action: #selector(MediaToolBar.playTapped(_:)), forControlEvents: .TouchUpInside);
		slider.addTarget(self, action: #selector(MediaToolBar.didDragged(_:)), forControlEvents: .TouchDragInside);
		expandButton.addTarget(self, action: #selector(MediaToolBar.rotate(_:)), forControlEvents: .TouchUpInside);
		menuButton.addTarget(self, action: #selector(MediaToolBar.menuTapped(_:)), forControlEvents: .TouchUpInside);
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
	
	func didDragged(slider : UISlider) -> Void {
		delegate.dragDidEnd(slider);
	}
	
	func rotate(button : UIButton){
		if(UIDevice.currentDevice().orientation != .Portrait){
			self.delegate.willRotateToOrientation(UIInterfaceOrientation.Portrait);
			let value = UIInterfaceOrientation.Portrait.rawValue
			UIDevice.currentDevice().setValue(value, forKey: "orientation")

		}
		else{
			let value = UIInterfaceOrientation.LandscapeLeft.rawValue
			UIDevice.currentDevice().setValue(value, forKey: "orientation")
		}
	}
	
	func menuTapped(button : UIButton){
		self.delegate.menuTapped();
	}
	
	override func layoutSubviews() {
		blur.frame = self.bounds
		self.playButton.frame = CGRectMake(5, 0, 40, 40);
		self.fromStartLabel.frame = CGRectMake(self.playButton.frame.maxX + 5, 0, 40, 40);
		
		self.tilEndLabel.frame = CGRectMake(self.slider.frame.maxX + 2, 0,
			                                    50,
			                                    40);
		
		
		if(UIDevice.currentDevice().orientation != .Portrait){
			self.expandButton.frame = CGRectMake(UIScreen.mainScreen().applicationFrame.width - 80, 0, 40, 40);
			self.menuButton.frame = CGRectMake(UIScreen.mainScreen().applicationFrame.width - 45, 0, 40, 40);
			self.slider.frame = CGRectMake(self.fromStartLabel.frame.maxX + 5,
			                               0,
			                               self.frame.width - self.playButton.frame.width - self.fromStartLabel.frame.width - 140,
			                               40);
		}
		else{
			self.slider.frame = CGRectMake(self.fromStartLabel.frame.maxX + 5,
			                               0,
			                               self.frame.width - self.playButton.frame.width - self.fromStartLabel.frame.width - 120,
			                               40);
			self.expandButton.frame = CGRectMake(UIScreen.mainScreen().applicationFrame.width - 45, 0, 40, 40);
		}
		//self.expandButton.frame = CGRectMake(UIScreen.mainScreen().applicationFrame.width - 45, 0, 40, 40);
		super.layoutSubviews();
	}
	
}
