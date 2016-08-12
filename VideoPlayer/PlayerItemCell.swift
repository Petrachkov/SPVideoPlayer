//
//  MainTableViewCell.swift
//  JuiceFit
//
//  Created by Ilgar on 21/04/16.
//  Copyright © 2016 actonica team. All rights reserved.
//

import UIKit

class PlayerItemCell: UITableViewCell {
	private var _imgView: UIImageView?;
	private var imgView: UIImageView {
		return self._imgView!;
	}
	
	private var _title: UILabel?;
	private var title: UILabel {
		return self._title!;
	}
	
	
	
	//MARK: - Initializers
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder);
		self.initialize();
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier);
		self.initialize();
	}
	
	func initialize() {
		self.backgroundColor = UIColor.clearColor();
		self.layoutMargins = UIEdgeInsetsZero;
		self.preservesSuperviewLayoutMargins = false;
		self.selectionStyle = .None;
		self.separatorInset = UIEdgeInsetsZero;
		
		//init imgView
		self._imgView = UIImageView();
		self.imgView.backgroundColor = UIColor.clearColor();
		self.imgView.setNeedsLayout();
		self.addSubview(self.imgView);
		
		self.imgView.image = UIImage(named: "film-gray");
		self.imgView.frame = CGRectMake(12, 11, 20, 20);
		
		//init title
		self._title = UILabel();
		self.title.backgroundColor = UIColor.clearColor();
		self.title.font = UIFont.systemFontOfSize(15);
		self.title.textColor = UIColor.UIColorFromRGB(0x404040);
		self.title.frame = CGRect(
			x: self.imgView.frame.origin.x + self.imgView.frame.size.width + 10,
			y: 10,
			width: 180,
			height: 22);
		self.imgView.setNeedsLayout();
		self.addSubview(self.title);
		
	}
	
	
	func setupWithTitle(title: String, forMenu: Bool = true) {
		self.title.text = title;
		self.title.textColor = UIColor.UIColorFromRGB(0x404040);
		
		
		self.title.font = UIFont.systemFontOfSize(15);
		
		self.imgView.image = UIImage(named: "film-gray");
		if (forMenu)
		{
			self.imgView.hidden = true;
			self.title.frame = CGRect(
				x: 10,
				y: 10,
				width: 180,
				height: 22);
			
		}
		else
		{
			self.imgView.hidden = false;
			self.title.frame = CGRect(
				x: self.imgView.frame.origin.x + self.imgView.frame.size.width + 10,
				y: 10,
				width: 180,
				height: 22);
			self.title.font = UIFont.systemFontOfSize(15);
			
		}
	}
	
	func setCellActive(forMenu: Bool)
	{
		self.imgView.image = UIImage(named: "film");
		if (forMenu)
		{
			self.title.font = UIFont.systemFontOfSize(14);
		}
	}
}