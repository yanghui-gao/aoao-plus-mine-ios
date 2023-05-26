//
//  AddKnightChooseShopTableViewCell.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/6/8.
//

import UIKit
import aoao_common_ios

class AddKnightChooseShopTableViewCell: UITableViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	
	@IBOutlet weak var chooseImageView: UIImageView!
	// 全职按钮
	@IBOutlet weak var workStatus_fullTimeButton: UIButton!
	
	// 兼职按钮
	@IBOutlet weak var workStatus_concurrentJobButton: UIButton!
	
	// 骑手角色
	@IBOutlet weak var role_knightButton: UIButton!
	// 组长角色
	@IBOutlet weak var role_leaderButton: UIButton!
	
	// 工作状态View
	// 选中展示 不选中 隐藏
	@IBOutlet weak var workStatusView: UIView!
	/// 工作类型点击回调 0 全职 1 兼职
	var workStatusHandle: ((Int) -> Void)?
	/// 角色点击回调 0 骑手 1组长
	var roleHandle: ((Int) -> Void)?
	
	@IBOutlet weak var sContentView: UIStackView!
	var model: ShopsContentModel?{
		didSet{
			if let model = self.model {
				self.nameLabel.text = model.storeInfo.name
				
				let imageName = model.isSelect ? "choose_selected" : "choose_unSelect"
				
				self.chooseImageView.image = UIImage(named: imageName, in: AAMineModule.share.bundle, compatibleWith: nil)
				
				self.workStatusView.isHidden = !model.isSelect
				
				// 已经加入 不可更改选中状态
				self.chooseImageView.alpha = model.isJoin ? 0.4 : 1
				
				// 已经加入不可编辑工作类型 以及 角色
				self.role_knightButton.isEnabled = !model.isJoin
				self.role_leaderButton.isEnabled = !model.isJoin
				self.workStatus_fullTimeButton.isEnabled = !model.isJoin
				self.workStatus_concurrentJobButton.isEnabled = !model.isJoin
				
				/// 不可点击状态
				self.role_knightButton.alpha = model.isJoin ? 0.4 : 1
				self.role_leaderButton.alpha = model.isJoin ? 0.4 : 1
				self.workStatus_fullTimeButton.alpha = model.isJoin ? 0.4 : 1
				self.workStatus_concurrentJobButton.alpha = model.isJoin ? 0.4 : 1
				
				if model.knightWorkType == .fullTimeJob {
					self.workStatus_fullTimeButton.setSelect()
					self.workStatus_concurrentJobButton.setUnSelect()
					
				} else if model.knightWorkType == .pluralJobs{
					self.workStatus_concurrentJobButton.setSelect()
					self.workStatus_fullTimeButton.setUnSelect()
				} else {
					self.workStatus_concurrentJobButton.setUnSelect()
					self.workStatus_fullTimeButton.setUnSelect()
				}
				
				if model.knightRoleType == .knight {
					self.role_knightButton.setSelect()
					self.role_leaderButton.setUnSelect()
					
				} else if model.knightRoleType == .knightLeader{
					self.role_knightButton.setUnSelect()
					
					self.role_leaderButton.setSelect()
				} else {
					self.role_knightButton.setUnSelect()
					self.role_leaderButton.setUnSelect()
				}
			}
		}
	}
	override func awakeFromNib() {
        super.awakeFromNib()
		self.workStatus_concurrentJobButton.layer.cornerRadius = 4
		self.workStatus_fullTimeButton.layer.cornerRadius = 4
		self.role_knightButton.layer.cornerRadius = 4
		self.role_leaderButton.layer.cornerRadius = 4
		
		self.sContentView.layer.cornerRadius = 4
//		self.sContentView.layer.shadowColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.07).cgColor
//		self.sContentView.layer.shadowOffset = CGSize(width: 1, height: 1)
//		self.sContentView.layer.shadowOpacity = 1
//		self.sContentView.layer.shadowRadius = 7
		self.sContentView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

	// 工作状态
	@IBAction func workStatusClicked(_ sender: Any) {
		guard let button = sender as? UIButton else {
			return
		}
		guard let handle = self.workStatusHandle else {
			return
		}
		handle(button.tag)
	}
	
	// 角色点击
	@IBAction func roleButtonClicked(_ sender: Any) {
		guard let button = sender as? UIButton else {
			return
		}
		guard let handle = self.roleHandle else {
			return
		}
		handle(button.tag)
	}
}
extension UIButton {
	func setUnSelect(){
		self.layer.borderWidth = 0.5
		self.layer.borderColor = UIColor(named: "boss_000000-30_FFFFFF-30", in: AAMineModule.share.bundle, compatibleWith: nil)?.cgColor
		self.backgroundColor = .white
		self.setTitleColor(UIColor(named: "boss_000000-30_FFFFFF-30", in: AAMineModule.share.bundle, compatibleWith: nil), for: .normal)
	}
	func setSelect(){
		self.layer.borderWidth = 0.5
		self.layer.borderColor = UIColor(named: "Color_00AD66", in: AAMineModule.share.bundle, compatibleWith: nil)?.cgColor
		self.backgroundColor = UIColor(named: "Color_00AD66-10", in: AAMineModule.share.bundle, compatibleWith: nil)
		self.setTitleColor(UIColor(named: "Color_00AD66", in: AAMineModule.share.bundle, compatibleWith: nil), for: .normal)
	}
}
