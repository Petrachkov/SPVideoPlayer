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
	var items : [PlayerItemModel] = [PlayerItemModel]()
	
	override init(){
		super.init();
	}
	
	convenience init(items : [PlayerItemModel]){
		self.init();
		self.items = items;
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell") as! PlayerItemCell;
		cell.setupWithTitle(items[indexPath.row].title);
		return cell;
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count;
	}
}
