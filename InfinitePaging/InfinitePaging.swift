//
//  InfinitePaging.swift
//  InfinitePaging
//
//  Created by CaptainTeemo on 10/16/16.
//  Copyright © 2016 CaptainTeemo. All rights reserved.
//

import UIKit

public protocol InfinitePagingDelegate {
    func didSelect(at index: Int)
    func didScroll(at index: Int)
}

public class InfinitePaging: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
	public var items: [UIView] = [] {
		didSet {
			reloadData()
		}
	}
	
	public var loop: Bool = true
	
	public var infinitePagingDelegate: InfinitePagingDelegate?
	
	let layout = UICollectionViewFlowLayout()
	public init(frame: CGRect) {
		super.init(frame: frame, collectionViewLayout: layout)
		
		register(InfinitePagingCell.self, forCellWithReuseIdentifier: "\(InfinitePagingCell.self)")
		dataSource = self
		delegate = self
		
		showsHorizontalScrollIndicator = false
		showsVerticalScrollIndicator = false
		
		isPagingEnabled = true
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		layout.scrollDirection = .horizontal
		layout.itemSize = frame.size
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		
	}
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if items.isEmpty {
			return 0
		}
		if loop {
			return Int(Int16.max)
		}
		return items.count
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let index = indexPath.item
		let mod = index % (items.count - 1)
		let item = items[mod]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(InfinitePagingCell.self)", for: indexPath) as! InfinitePagingCell
		cell.content = item
		return cell
	}
	
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		infinitePagingDelegate?.didSelect(at: indexPath.item)
	}
}

class InfinitePagingCell: UICollectionViewCell {
	var content: UIView? {
		didSet {
			oldValue?.removeFromSuperview()
			if let view = content {
				view.clipsToBounds = true
				contentView.addSubview(view)
			}
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		content?.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
	}
}

// original thoughts
struct CircularLinkedList<T> {
	var head: LinkedListNode<T>?
	
	let count: Int
	let collection: [T]
	init(collection: [T]) {
		self.collection = collection
		self.count = collection.count
		
		var data = collection
		var currentNode: LinkedListNode<T>?
		while !data.isEmpty {
			let currentElement = data.removeFirst()
			let newNode = LinkedListNode<T>(value: currentElement)
			if head == nil {
				head = newNode
				currentNode = head
			} else {
				currentNode?.next = newNode
				currentNode = currentNode?.next
				currentNode?.previous = newNode
			}
		}
		
		currentNode?.next = head
		head?.previous = currentNode
	}
}

class LinkedListNode<T> {
	var value: T?
	var previous: LinkedListNode<T>?
	var next: LinkedListNode<T>?
	
	init(value: T?) {
		self.value = value
	}
}
