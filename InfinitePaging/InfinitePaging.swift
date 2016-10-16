//
//  InfinitePaging.swift
//  InfinitePaging
//
//  Created by CaptainTeemo on 10/16/16.
//  Copyright © 2016 CaptainTeemo. All rights reserved.
//

import UIKit

public protocol InfinitePagingDataSource {
    func numberOfPages() -> Int
    func image(at index: Int, closure: (UIImage?) -> Void)
}

public protocol InfinitePagingDelegate {
    func didTapImage(at index: Int)
    func didScroll(at index: Int)
}

public class InfinitePaging: UIScrollView {
    public var dataSource: InfinitePagingDataSource? {
        didSet {
            guard let ds = self.dataSource else { return }
            let pages = ds.numberOfPages()
            
            imageViews.forEach{ $0.removeFromSuperview() }
            imageViews.removeAll()
            
            for i in 0..<pages {
                let imageView = UIImageView()
                imageView.tag = i
                imageView.contentMode = .scaleAspectFill
                imageViews.append(imageView)
                self.addSubview(imageView)
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
                imageView.addGestureRecognizer(tap)
            }
            
            self.reloadData()
        }
    }
    
    public var infinitePagingDelegate: InfinitePagingDelegate?
    
    fileprivate var imageViews = [UIImageView]()
    fileprivate var currentIndex = 0
    fileprivate var pages: Int {
        guard let ds = self.dataSource else { return 0 }
        return ds.numberOfPages()
    }
    
    fileprivate var timer: Timer?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    fileprivate func commonInit() {
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        
        delegate = self
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        for (index, imageView) in imageViews.enumerated() {
            imageView.frame = CGRect(x: CGFloat(index) * frame.width, y: 0, width: frame.width, height: frame.height)
        }
        
        contentSize = CGSize(width: frame.width * CGFloat(imageViews.count), height: frame.height)
    }
    
    public func reloadData() {
        for (index, imageView) in imageViews.enumerated() {
            var i = index
            if i >= pages {
                i %= pages
            }
            self.dataSource?.image(at: i, closure: { (image) in
                imageView.image = image
            })
        }
    }
    
    @objc fileprivate func handleTap(sender: UITapGestureRecognizer) {
        guard let imageView = sender.view else { return }
        infinitePagingDelegate?.didTapImage(at: imageView.tag)
    }
    
    fileprivate func fillHead() {
        if let tail = imageViews.popLast() {
            imageViews.insert(tail, at: 0)
            setNeedsLayout()
        }
    }
    
    fileprivate func fillTail() {
        let head = imageViews.removeFirst()
        imageViews.append(head)
        setNeedsLayout()
    }
}

extension InfinitePaging: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard pages > 1 else { return }
        
        let offsetX = scrollView.contentOffset.x
        if offsetX < 0 {
            fillHead()
            scrollView.contentOffset = CGPoint(x: frame.width, y: 0)
        } else if offsetX > contentSize.width - frame.width {
            fillTail()
            scrollView.contentOffset = CGPoint(x: contentSize.width - frame.width * 2, y: 0)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let index = Int(offsetX / scrollView.frame.width)
        guard index < imageViews.count else { fatalError() }
        currentIndex = imageViews[index].tag
        
        infinitePagingDelegate?.didScroll(at: currentIndex)
    }
}
