//
//  ViewController.swift
//  monzo-card
//
//  Created by nhatquangz on 7/17/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	var colors: [UIColor] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let layout = MonzoCollectionViewLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 25
		collectionView.setCollectionViewLayout(layout, animated: false)
		collectionView.decelerationRate = .fast
		let offset = UIScreen.main.bounds.width * 0.35 / 2
		collectionView.contentInset = UIEdgeInsets(top: 40, left: offset, bottom: 0, right: offset)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(CardViewCell.self, forCellWithReuseIdentifier: "CardViewCell")
	}
}


// MARK: - Data Source
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 10
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardViewCell", for: indexPath) as! CardViewCell
		cell.setup(index: indexPath.row)
		return cell
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let itemWidth = collectionView.frame.width * 0.65
		let itemHeight = collectionView.frame.height - 40
		return CGSize(width: itemWidth, height: itemHeight)
	}
	
}



class MonzoCollectionViewLayout: UICollectionViewFlowLayout {
	
	private var allAttributes: [Int: UICollectionViewLayoutAttributes] = [:]

	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}

	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		guard let attributes = super.layoutAttributesForElements(in: rect) else {
			return nil
		}
		for att in attributes {
			let a = att.copy() as! UICollectionViewLayoutAttributes
			a.zIndex = att.indexPath.row == 0 ? 0 : 1
			allAttributes[att.indexPath.row] = a
		}
		stickMainCard()
		return allAttributes.values.filter { rect.intersects($0.frame) }
	}

	func stickMainCard() {
		if let att = allAttributes[0], let collectionView = collectionView {
			let itemWidth: CGFloat = UIScreen.main.bounds.width * 0.65
			let inset = collectionView.contentInset.left
			let contenOffsetX = collectionView.contentOffset.x + inset

			let dY: CGFloat = -25 // move up max distance
			let dX: CGFloat = -10 // move left max distance

			/// newX, newY: new item position when scrolling
			var newY = contenOffsetX / itemWidth * dY
			if newY < dY { newY = dY }

			var newX = contenOffsetX / itemWidth * dX
			if newX < dX { newX = dX }

			/// Dont change originY when collectionview is bounding (contenoffset < 0)
			att.frame.origin.y = contenOffsetX > 0 ? newY : 0

			let numberOfItem = collectionView.numberOfItems(inSection: 0)

			/// Set originX
			if let max = allAttributes[numberOfItem - 2]?.frame.origin.x {
				let x = min(contenOffsetX + newX, max - 10)
				att.frame.origin.x = contenOffsetX > 0 ? x : 0
			} else {
				att.frame.origin.x = contenOffsetX > 0 ? contenOffsetX + newX : 0
			}
		}
	}
//
//
	override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
		guard let collectionView = collectionView else {
			return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
		}
		var offsetAdjusment = CGFloat.greatestFiniteMagnitude
		let horizontalCenter = proposedContentOffset.x + (collectionView.bounds.width / 2)

		let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
		let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)

		layoutAttributesArray?.forEach({ (layoutAttributes) in
			let itemHorizontalCenter = layoutAttributes.center.x
			if abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjusment) {
				offsetAdjusment = itemHorizontalCenter - horizontalCenter
			}
		})

		return CGPoint(x: proposedContentOffset.x + offsetAdjusment, y: proposedContentOffset.y)
	}
}
