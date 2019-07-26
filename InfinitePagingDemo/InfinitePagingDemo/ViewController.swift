//
//  ViewController.swift
//  InfinitePagingDemo
//
//  Created by captainteemo on 2019/7/26.
//  Copyright © 2019 captainteemo. All rights reserved.
//

import InfinitePaging

class ViewController: UIViewController {
	let imageNames = ["banner1", "banner2", "banner3", "banner4"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let infinitePaging = InfinitePaging(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width * (640 / 1024)))
		view.addSubview(infinitePaging)
		
		infinitePaging.items = imageNames.map({ (imageName) -> UIImageView in
			let imageView = UIImageView()
			imageView.contentMode = .scaleAspectFill
			imageView.image = UIImage(named: imageName)
			return imageView
		})
	}
}

