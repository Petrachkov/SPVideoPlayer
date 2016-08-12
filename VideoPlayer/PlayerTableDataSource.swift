//
//  PlayerTableDataSource.swift
//  VideoPlayer
//
//  Created by sergey petrachkov on 01/04/16.
//  Copyright © 2016 sergey petrachkov. All rights reserved.
//

import Foundation
import UIKit

class PlayerTableDataSource : NSObject, UITableViewDataSource{
	var items : [PlayerItemModel] = [PlayerItemModel]();
	var forMenu : Bool = false;
	
	var currentIndex : Int = 0;
	
	override init(){
		super.init();
	}
	
	convenience init(items : [PlayerItemModel], _forMenu: Bool){
		self.init();
		self.items = items;
		self.forMenu = _forMenu;
	}
	
	func setCurInd(_cur: Int)
	{
		self.currentIndex = _cur;
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("PlayerItemCell", forIndexPath: indexPath) as! PlayerItemCell;
		cell.setupWithTitle(items[indexPath.row].title);
		if (indexPath.row == currentIndex)
		{
			cell.setCellActive(self.forMenu);
		}
		
		cell.preservesSuperviewLayoutMargins = false
		cell.separatorInset = UIEdgeInsetsZero
		cell.layoutMargins = UIEdgeInsetsZero
		cell.selectionStyle = UITableViewCellSelectionStyle.None
		
		if (!self.forMenu)
		{
			cell.selectionStyle = UITableViewCellSelectionStyle.Gray
		}
		
		return cell;
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count;
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 38
	}
}
