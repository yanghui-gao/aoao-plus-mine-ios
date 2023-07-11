//
//  StatisticsCollectionViewCell.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/4/13.
//

import UIKit

class StatisticsCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet weak var unitLabel: UILabel!
	@IBOutlet weak var valueLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	
	@IBOutlet weak var itemView: UIView!
	override func awakeFromNib() {
		super.awakeFromNib()
		self.itemView.layer.cornerRadius = 6
		self.itemView.layer.masksToBounds = true
	}
}
