//
//  StatisticsFooterCollectionReusableView.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/4/13.
//

import UIKit

class StatisticsFooterCollectionReusableView: UICollectionReusableView {
        
	@IBOutlet weak var updateLabel: UILabel!
	
	var model: StatisticsDetailModel?{
		didSet{
			if let model = self.model, !model.updateAtStr.isEmpty {
				self.updateLabel.text = "最近更新时间: \(model.updateAtStr)"
			} else {
				self.updateLabel.text = ""
			}
		}
	}
}
