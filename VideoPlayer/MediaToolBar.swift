//
//  MediaToolBar.swift
//  VideoPlayer
//
//  Created by sergey petrachkov on 29/03/16.
//  Copyright © 2016 sergey petrachkov. All rights reserved.
//

import Foundation
import UIKit

class CustomUISlider : UISlider
{
	override func trackRectForBounds(bounds: CGRect) -> CGRect {
		let rect:CGRect = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.width, 3)
		//set your bounds here
		return rect
		
	}
}
class MediaToolBar : UIView, UIGestureRecognizerDelegate{
	var backColor : UIColor? = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)
	
	var playButton : UIButton!;
	var emptySpace: UIView!;
	
	
	var expandButton : UIButton!;
	var menuButton : UIButton!;
	var slider : CustomUISlider!;
	
	var delegate : MediaToolBarDelegate!;
	var playing : Bool = false;
	var fullScreen : Bool = false;
	
	var fromStartLabel : UILabel!;
	var tilEndLabel : UILabel!;
	
	//var blur : UIVisualEffectView!
	override init(frame: CGRect) {
		
		playButton = UIButton(type: .Custom);
		playButton.setImage(UIImage(named: "play-white"), forState: .Normal);
		
		emptySpace = UIView();
		
		expandButton = UIButton(type: .Custom);
		expandButton.setImage(UIImage(named:"resize"), forState: .Normal);
		
		menuButton = UIButton(type: .Custom);
		menuButton.setImage(UIImage(named: "film-light"), forState: .Normal);
		
		slider = CustomUISlider();
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
		
		
		self.backgroundColor = self.backColor;
		
		self.addSubview(emptySpace);
		self.addSubview(playButton);
		
		self.addSubview(slider);
		self.addSubview(expandButton);
		self.addSubview(menuButton);
		self.addSubview(fromStartLabel);
		self.addSubview(tilEndLabel);
		playButton.addTarget(self, action: #selector(MediaToolBar.playTapped(_:)), forControlEvents: .TouchUpInside);
		slider.addTarget(self, action: #selector(MediaToolBar.didDragged(_:)), forControlEvents: .TouchDragInside);
		expandButton.addTarget(self, action: #selector(MediaToolBar.rotate(_:)), forControlEvents: .TouchUpInside);
		menuButton.addTarget(self, action: #selector(MediaToolBar.menuTapped(_:)), forControlEvents: .TouchUpInside);
		
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MediaToolBar.emptyTapped(_:)));
		tapRecognizer.delegate = self;
		self.emptySpace.addGestureRecognizer(tapRecognizer);
	}
	func switchSize(){
		self.fullScreen = !self.fullScreen;
		if(!self.fullScreen){
			self.expandButton.setImage(UIImage(named:"resize"), forState: .Normal);
		}
		else{
			self.expandButton.setImage(UIImage(named:"collapse"), forState: .Normal);
		}
	}
	func emptyTapped(recognizer : UIGestureRecognizer){
		self.delegate.emptySpaceTapped();
	}
	
	func hideMe(delay : Double = 0.5)
	{
		UIView.animateWithDuration(0.5, delay: delay, options: UIViewAnimationOptions.CurveLinear, animations: {
			self.alpha = 0
			}, completion: {c in self.hidden = true});
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func playTapped(button : UIButton){
		delegate.playTapped(self);
		self.switchPlayingState();
	}
	
	func switchPlayingState(){
		playing = !playing;
		let img = playing ? UIImage(named:"icon-pause") : UIImage(named: "play-white");
		self.playButton.setImage(img, forState: .Normal);
	}
	
	func setPortraitSizeState(portrait : Bool){
		self.fullScreen = !portrait;
		if(!self.fullScreen){
			self.expandButton.setImage(UIImage(named:"resize"), forState: .Normal);
		}
		else{
			self.expandButton.setImage(UIImage(named:"collapse"), forState: .Normal);
		}
	}
	
	func setPlaying (){
		playing = true;
		let img = UIImage(named:"icon-pause");
		self.playButton.setImage(img, forState: .Normal);
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
	
	func hideMenuButton()
	{
		self.menuButton.hidden = true;
	}
	
	func showMenuButton()
	{
		self.menuButton.hidden = false;
	}
	
	override func layoutSubviews() {
		var barHeight: CGFloat = 40;
		if (UIDevice.currentDevice().orientation.isLandscape)
		{
			barHeight = 60;
		}
		
		
		
		self.playButton.frame = CGRectMake((self.frame.size.width/2) - 20, ((self.frame.size.height)/2)-20, 40, 40);
		self.emptySpace.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-40);
		
		
		self.fromStartLabel.frame = CGRectMake(15, (self.frame.size.height - barHeight)+(barHeight-40)/2, 40, 40);
		self.tilEndLabel.frame = CGRectMake(self.slider.frame.maxX + 10, (self.frame.size.height - barHeight)+(barHeight-40)/2,
		                                    50,
		                                    40);
		
		
		if(UIDevice.currentDevice().orientation.isLandscape){
			
			self.fromStartLabel.frame = CGRectMake(30, (self.frame.size.height - barHeight)+(barHeight-40)/2, 40, 40);
			self.tilEndLabel.frame = CGRectMake(self.slider.frame.maxX + 25, (self.frame.size.height - barHeight)+(barHeight-40)/2,
			                                    50,
			                                    40);
			
			self.expandButton.frame = CGRectMake(UIScreen.mainScreen().applicationFrame.width - 50, (self.frame.size.height - barHeight)+(barHeight-40)/2, 40, 40);
			self.menuButton.frame = CGRectMake(UIScreen.mainScreen().applicationFrame.width - 50, 8, 40, 40);
			self.slider.frame = CGRectMake(self.fromStartLabel.frame.maxX + 30,
			                               self.fromStartLabel.frame.center.y,
			                               self.frame.width - self.fromStartLabel.frame.width - 195,
			                               40);
		}
		else{
			self.slider.frame = CGRectMake(self.fromStartLabel.frame.maxX + 15,
			                               self.fromStartLabel.frame.center.y,
			                               self.frame.width - self.fromStartLabel.frame.width - 140,
			                               40);
			self.expandButton.frame = CGRectMake(UIScreen.mainScreen().applicationFrame.width - 45, (self.frame.size.height - barHeight)+(barHeight-40)/2, 40, 40);
		}
		super.layoutSubviews();
	}
	
}
