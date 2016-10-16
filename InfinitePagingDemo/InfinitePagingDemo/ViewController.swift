//
//  ViewController.swift
//  InfinitePagingDemo
//
//  Created by CaptainTeemo on 10/16/16.
//  Copyright © 2016 CaptainTeemo. All rights reserved.
//

import UIKit
import InfinitePaging

class ViewController: UIViewController {
    let imageNames = ["banner1.jpg", "banner2.jpg", "banner3.jpg", "banner4.jpg"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let infinitePaging = InfinitePaging(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width * (640 / 1024)))
        infinitePaging.dataSource = self
        infinitePaging.infinitePagingDelegate = self
        view.addSubview(infinitePaging)
    }
}

extension ViewController: InfinitePagingDataSource {
    func numberOfPages() -> Int {
        return imageNames.count
    }
    
    func image(at index: Int, closure: (UIImage?) -> Void) {
        let image = UIImage(named: imageNames[index])
        closure(image)
    }
}

extension ViewController: InfinitePagingDelegate {
    public func didScroll(at index: Int) {
        
    }

    func didTapImage(at index: Int) {
        
    }
}

