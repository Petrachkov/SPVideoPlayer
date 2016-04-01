//
//  PlayerItemCell.swift
//  VideoPlayer
//
//  Created by sergey petrachkov on 01/04/16.
//  Copyright © 2016 sergey petrachkov. All rights reserved.
//

import Foundation
import UIKit

class PlayerItemCell : UITableViewCell{
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier);
		self.backgroundColor = UIColor.clearColor();
		self.imageView?.image = UIImage(named: "play-blue");
	}
	
	func setupWithTitle(title : String){
		self.textLabel?.text = title;
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}