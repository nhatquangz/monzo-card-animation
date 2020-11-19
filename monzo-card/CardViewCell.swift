//
//  CardViewCell.swift
//  monzo-card
//
//  Created by nhatquangz on 7/17/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import UIKit

class CardViewCell: UICollectionViewCell {
	
	let label = UILabel()
	var colors = (0...10).map { _ -> UIColor in
		let redValue = CGFloat.random(in: 0...1)
		let greenValue = CGFloat.random(in: 0...1)
		let blueValue = CGFloat.random(in: 0...1)
		return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}
	
	private func setup() {
		self.layer.cornerRadius = 10
		self.clipsToBounds = true
		label.font = UIFont.systemFont(ofSize: 50)
		label.textColor = .white
		self.addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
		])
	}
	
	private func generateRandomColor() -> UIColor {
		let redValue = CGFloat(drand48())
		let greenValue = CGFloat(drand48())
		let blueValue = CGFloat(drand48())
		let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
		return randomColor
	}
	
	func setup(index: Int) {
		self.label.text = String(index + 1)
		if index == 0 {
			self.backgroundColor = .red
		} else {
			self.backgroundColor = colors[index % 10]
		}
	}
	
}
