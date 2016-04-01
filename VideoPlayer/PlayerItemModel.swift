//
//  PlayerItemModel.swift
//  VideoPlayer
//
//  Created by sergey petrachkov on 01/04/16.
//  Copyright © 2016 sergey petrachkov. All rights reserved.
//

import Foundation

class PlayerItemModel{
	var title : String = ""
	var url : NSURL
	
	init(){
		title = "video item"
		url = NSURL()
	}
	
	convenience init (title: String, url : NSURL){
		self.init();
		self.title = title;
		self.url = url;
	}
}