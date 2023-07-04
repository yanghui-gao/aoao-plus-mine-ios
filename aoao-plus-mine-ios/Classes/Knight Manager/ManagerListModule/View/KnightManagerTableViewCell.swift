//
//  KnightManagerTableViewCell.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/6/7.
//

import UIKit

class KnightManagerTableViewCell: UITableViewCell {
	
	// 骑手名称
	@IBOutlet weak var nameLabel: UILabel!
	// 组长
	@IBOutlet weak var leaderView: UIView!
	// 配送View
	@IBOutlet weak var distributionView: UIView!
	// 无单
	@IBOutlet weak var noneOrderView: UIView!
	// 骑手电话
	@IBOutlet weak var phoneLabel: UILabel!
	// 离岗
	@IBOutlet weak var dimissionButton: UIButton!
	// 骑手信息View
	@IBOutlet weak var knightContentView: UIView!
	// 组长leadingView 非组长隐藏
	@IBOutlet weak var leadingView: UIView!
	
	@IBOutlet weak var residentView: UIView!
	
	@IBOutlet weak var nonResidentView: UIView!
	// 离岗点击回调
	var dismissionButtonHandle: (() -> Void)?
	
	var model:KnightManagerModel?{
		didSet {
			if let model = self.model {
				self.nameLabel.text = model.name
				self.leaderView.isHidden = model.knightRoleType == .normalKnight
//				self.leadingView.isHidden = model.knightRoleType == .normalKnight
				self.distributionView.isHidden = !model.isDelivery
				self.phoneLabel.text = model.phoneStr
				self.dimissionButton.isHidden = model.isHideDismissButton
				self.noneOrderView.isHidden = model.isDelivery
				// 是否展示驻店
				self.residentView.isHidden = model.storeids.isEmpty
				self.nonResidentView.isHidden = !model.storeids.isEmpty
			}
		}
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
		self.dimissionButton.layer.cornerRadius = 15
		self.leaderView.layer.borderWidth = 0.5
		self.leaderView.layer.cornerRadius = 4
		self.leaderView.layer.borderColor = UIColor(named: "color_FDAD04", in: AAMineModule.share.bundle, compatibleWith: nil)?.cgColor
		
		self.distributionView.layer.borderWidth = 0.5
		self.distributionView.layer.cornerRadius = 4
		self.distributionView.layer.borderColor = UIColor(named: "Color_00AD66", in: AAMineModule.share.bundle, compatibleWith: nil)?.cgColor
		
		
		self.residentView.layer.cornerRadius = 4
		self.nonResidentView.layer.cornerRadius = 4
		
		self.noneOrderView.layer.borderWidth = 0.5
		self.noneOrderView.layer.cornerRadius = 4
		self.noneOrderView.layer.borderColor = UIColor(named: "boss_000000-40_FFFFFF-40", in: AAMineModule.share.bundle, compatibleWith: nil)?.cgColor
		
    }

	@IBAction func dismissionButtonClicked(_ sender: Any) {
		guard let handle = self.dismissionButtonHandle else {
			return
		}
		handle()
	}
	override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
