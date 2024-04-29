//
//  GalleryLayout.swift
//  Infinite Gallery
//
//  Created by Arthur Avagyan on 29.04.24.
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewFlowLayout {
	
	private var cache: [UICollectionViewLayoutAttributes] = []
	private var contentHeight: CGFloat = 0
	
	override init() {
		super.init()
		scrollDirection = .vertical
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		scrollDirection = .vertical
	}
	
	override var collectionViewContentSize: CGSize {
		return CGSize(width: UIScreen.main.bounds.size.width, height: contentHeight)
	}
	
	override func prepare() {
		guard let collectionView else { return }
		let columnWidth = UIScreen.main.bounds.size.width
		
		var yOffset = CGFloat(0)
		
		for item in 0..<collectionView.numberOfItems(inSection: 0) {
			let indexPath = IndexPath(item: item, section: 0)
			let height = UIScreen.main.bounds.size.height / 4
			let frame = CGRect(x: 0, y: yOffset, width: columnWidth, height: height)
			let insetFrame = frame.insetBy(dx: 0, dy: 0)
			
			let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
			attributes.frame = insetFrame
			cache.append(attributes)
			contentHeight = max(contentHeight, frame.maxY)
			yOffset += height
		}
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
		
		for attributes in cache {
			if attributes.frame.intersects(rect) {
				visibleLayoutAttributes.append(attributes)
			}
		}
		return visibleLayoutAttributes
	}
	
	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		cache[indexPath.item]
	}
}
