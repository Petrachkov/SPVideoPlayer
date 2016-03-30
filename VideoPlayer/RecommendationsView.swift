//
//  RecommendationsView.swift
//  VideoPlayer
//
//  Created by sergey petrachkov on 30/03/16.
//  Copyright © 2016 sergey petrachkov. All rights reserved.
//

import Foundation
import UIKit;

class RecommendationsView: UIView {
	var isShown : Bool = false;
	override init(frame: CGRect) {
		super.init(frame: frame);
		self.backgroundColor = UIColor(red: 200.0/255, green: 200.0/255, blue: 200.0/255, alpha: 0.8);
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func showView(){
		UIView.animateWithDuration(0.5, animations: {
			self.frame.origin.y = 60;
		})
		isShown = true;
	}
	
	func hideView(){
		UIView.animateWithDuration(0.5, animations: {
			self.frame.origin.y = -1000;
		})
		isShown = false
	}
}