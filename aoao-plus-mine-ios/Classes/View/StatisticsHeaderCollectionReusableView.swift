//
//  StatisticsHeaderCollectionReusableView.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/4/13.
//

import UIKit
import SwiftDate

class StatisticsHeaderCollectionReusableView: UICollectionReusableView {
	/// 时间间隔
	@IBOutlet weak var timeIntervalLabel: UILabel!
	/// 订单数量
	@IBOutlet weak var orderCountLabel: UILabel!
	/// 折线图
	@IBOutlet weak var lineChartView: OrderLineChartView!
	/// 订单单位
	@IBOutlet weak var orderUnitLabel: UILabel!
	var lineList: [LineModel]? {
		didSet{
			if let list = self.lineList {
				self.lineChartView.lineModelList = list
				self.lineChartView.reloadData()
			}
		}
	}
	var model: StatisticsDetailModel?{
		didSet{
			if let model = self.model, let orderTc = model.orderTc, orderTc != 0 {
				self.orderCountLabel.text = "\(orderTc)"
				self.orderUnitLabel.text = "单"
			} else {
				self.orderCountLabel.text = "--"
				self.orderUnitLabel.text = ""
			}
		}
	}
	override func awakeFromNib() {
		super.awakeFromNib()
		let date = Date() - 1.days
		let formatter = DateFormatter()
		formatter.locale = Locale.init(identifier: "zh_CN")
		formatter.dateFormat = "MM.dd"
		let dateStr = formatter.string(from: date)
		
		let endDate = Date()
		let endFormatter = DateFormatter()
		endFormatter.locale = Locale.init(identifier: "zh_CN")
		endFormatter.dateFormat = "MM.01"
		let endDateStr = endFormatter.string(from: endDate)
		self.timeIntervalLabel.text = "指标统计时间: \(endDateStr) - \(dateStr)"
	}
	override func encode(with coder: NSCoder) {
		super.encode(with: coder)
		print("1234")
	}
	
}
