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
	var backColor : UIColor? = UIColor(red: 126.0/255.0, green: 126.0/255, blue: 126.0/255, alpha: 1);
	
	var playButton : UIButton!;
	var expandButton : UIButton!;
	var menuButton : UIButton!;
	var slider : UISlider!;
	
	var delegate : MediaToolBarDelegate!;
	var playing : Bool = false;
	
	var fromStartLabel : UILabel!;
	var tilEndLabel : UILabel!;
	
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
		slider.continuous = true;
		
		fromStartLabel = UILabel();
		tilEndLabel = UILabel();
		
		fromStartLabel.textColor = UIColor.whiteColor();
		tilEndLabel.textColor = UIColor.whiteColor();
		
		fromStartLabel.font = UIFont.systemFontOfSize(14);
		tilEndLabel.font = UIFont.systemFontOfSize(14);
		super.init(frame: frame);
		self.backgroundColor = self.backColor;
		self.addSubview(playButton);
		self.addSubview(slider);
		self.addSubview(expandButton);
		self.addSubview(menuButton);
		self.addSubview(fromStartLabel);
		self.addSubview(tilEndLabel);
		playButton.addTarget(self, action: "playTapped:", forControlEvents: .TouchUpInside);
		slider.addTarget(self, action: "didDragged:", forControlEvents: .TouchDragInside);
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
		self.playButton.frame = CGRectMake(5, 10, 40, 40);
		self.fromStartLabel.frame = CGRectMake(self.playButton.frame.maxX + 5, 10, 40, 40);
		self.slider.frame = CGRectMake(self.fromStartLabel.frame.maxX + 5,
		                               10,
		                               self.frame.width - self.playButton.frame.width - self.fromStartLabel.frame.width - 120,
		                               40);
		self.tilEndLabel.frame = CGRectMake(self.slider.frame.maxX + 2, 10,
		                                    50,
		                                    40);
		self.expandButton.frame = CGRectMake(UIScreen.mainScreen().applicationFrame.width - 45, 10, 40, 40);
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
	
	func didDragged(slider : UISlider) -> Void {
		delegate.dragDidEnd(slider);
	}
	
}
