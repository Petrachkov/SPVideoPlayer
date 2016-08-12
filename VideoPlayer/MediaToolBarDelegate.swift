//
//  MediaToolBarDelegate.swift
//  VideoPlayer
//
//  Created by sergey petrachkov on 29/03/16.
//  Copyright © 2016 sergey petrachkov. All rights reserved.
//

import UIKit
import Foundation

protocol MediaToolBarDelegate{
	func playTapped(toolBar: MediaToolBar);
	func dragDidEnd(slider: UISlider);
	func menuTapped();
	func emptySpaceTapped();
	func willRotateToOrientation(orientation : UIInterfaceOrientation);
}