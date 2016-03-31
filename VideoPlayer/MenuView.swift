//
//  RecommendationsView.swift
//  VideoPlayer
//
//  Created by sergey petrachkov on 30/03/16.
//  Copyright © 2016 sergey petrachkov. All rights reserved.
//

import Foundation
import UIKit;

class MenuView: UITableView {
	var isShown : Bool = false;
	var blur : UIVisualEffectView!
	var shownFrame: CGRect = CGRectMake(UIScreen.mainScreen().applicationFrame.maxY - 200, 0, 200 , UIScreen.mainScreen().applicationFrame.maxX);
	
	override init(frame: CGRect, style: UITableViewStyle) {
		super.init(frame: frame, style: style);
		
		let blureffect:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
		self.blur = UIVisualEffectView (effect: blureffect)
		self.blur.frame = self.bounds;
		addSubview(self.blur)
		self.backgroundColor = UIColor(red: 126.0/255.0, green: 126.0/255, blue: 126.0/255, alpha: 0.8);
	}
	
	
	convenience init(){
		self.init(frame: CGRectMake(UIScreen.mainScreen().applicationFrame.maxY + 10, 40, 200 , UIScreen.mainScreen().applicationFrame.maxX), style: UITableViewStyle.Plain);
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func showView(){
		UIView.animateWithDuration(0.5, animations: {
			self.frame.origin.x = UIScreen.mainScreen().applicationFrame.maxX - self.bounds.width;
		})
		isShown = true;
	}
	
	func hideView(){
		UIView.animateWithDuration(0.5, animations: {
			self.frame.origin.x = UIScreen.mainScreen().applicationFrame.maxX + 10;
		})
		isShown = false
	}
	
	func switchState(){
		if (self.isShown){
			self.hideView();
		}
		else{
			self.showView();
		}
	}
}