//
//  MineRouter.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/3/9.
//

import UIKit
import aoao_plus_common_ios
import SwiftyJSON

public struct MineRouter {
	
	public static func initialize() {
		/// 我的页面
		navigator.register("mine".routerUrl) { url, values, context in
			return AAMineModule.share.mineStoryboard.instantiateViewController(withIdentifier: "MineViewController")
		}
		/// 骑手信息
		navigator.register("knight".routerUrl) { url, values, context in
			let vc = AAMineModule.share.mineStoryboard.instantiateViewController(withIdentifier: "KnightViewController") as? KnightViewController
			guard let para = context as? [String: Any?] else {
				return vc
			}
			if let accountID = para["accountID"] as? String {
				vc?.accountID = accountID
			}
			if let shopID = para["shopID"] as? String {
				vc?.shopID = shopID
			}
			return vc
		}
		/// 骑手信息 - 个人信息
		navigator.register("userinfomation".routerUrl) { url, values, context in
			let vc = AAMineModule.share.mineStoryboard.instantiateViewController(withIdentifier: "UserInfomationVc") as! UserInfomationVc
			guard let para = context as? [String: Any?] else {
				return vc
			}
			/// 用户信息
			if let model = para["userInfoModel"] as? UserInfoModel {
				vc.userInfoModel = model
			}
			return vc
		}
		/// 骑手信息 - 健康证信息
		navigator.register("health".routerUrl) { url, values, context in
			let vc = AAMineModule.share.mineStoryboard.instantiateViewController(withIdentifier: "HealthCardVc") as! HealthCardVc
			guard let para = context as? [String: Any?] else {
				return vc
			}
			/// 用户信息
			if let model = para["userInfoModel"] as? UserInfoModel {
				vc.userInfoModel = model
			}
			return vc
		}
		/// 骑手信息 - 附加信息
		navigator.register("vaccine".routerUrl) { url, values, context in
			let vc = AAMineModule.share.mineStoryboard.instantiateViewController(withIdentifier: "UpLoadVaccineContentViewController") as! UpLoadVaccineContentViewController
			guard let para = context as? [String: Any?] else {
				return vc
			}
			/// 用户信息
			if let model = para["userInfoModel"] as? UserInfoModel {
				vc.userInfoModel = model
			}
			return vc
		}
		/// 帮助
		navigator.register("help".routerUrl) { url, values, context in
			let vc = AAMineModule.share.mineStoryboard.instantiateViewController(withIdentifier: "HelpViewController")
			return vc
		}
		
		/// 帮助
		navigator.register("setup".routerUrl) { url, values, context in
			let vc = AAMineModule.share.mineStoryboard.instantiateViewController(withIdentifier: "SetupViewController")
			return vc
		}
		/// 意见反馈
		navigator.register("feedback".routerUrl) { url, values, context in
			let vc = AAMineModule.share.mineStoryboard.instantiateViewController(withIdentifier: "FeedBackViewController")
			return vc
		}
		/// 统计
		navigator.register("statistics".routerUrl) { url, values, context in
			let vc = AAMineModule.share.mineStoryboard.instantiateViewController(withIdentifier: "StatisticsViewController") as! StatisticsViewController
			guard let para = context as? [String: Any?] else {
				return vc
			}
			if let shopID = para["shopID"] as? String {
				vc.shopID = shopID
			}
			if let userInfoID = para["userInfoID"] as? String {
				vc.userInfoID = userInfoID
			}
			return vc
		}
		/// 关于
		navigator.register("about".routerUrl) { url, values, context in
			let vc = AAMineModule.share.mineStoryboard.instantiateViewController(withIdentifier: "AboutVc")
			return vc
		}
		/// 修改手机号
		navigator.register("changePhone".routerUrl) { url, values, context in
			let vc = AAMineModule.share.mineStoryboard.instantiateViewController(withIdentifier: "ChangePhoneExplainVc") as! ChangePhoneExplainVc
			vc.changePhoneType = .changePhone
			return vc
		}
		/// 修改手机号 -> 输入新手机号页面
		navigator.register("setupNewPhoneNumber".routerUrl) { url, values, context in
			let vc = AAMineModule.share.mineStoryboard.instantiateViewController(withIdentifier: "SetupNewPhoneNumberVC") as! SetupNewPhoneNumberVC
			return vc
		}
		/// 我的 -> 骑手管理
		navigator.register("knightManager".routerUrl) { url, values, context in
			let vc = AAMineModule.share.mineStoryboard.instantiateViewController(withIdentifier: "KnightManagerViewController") as! KnightManagerViewController
			return vc
		}
		
		/// 我的 -> 骑手管理 -> 添加骑手
		navigator.register("addKnight".routerUrl) { url, values, context in
			let vc = AAMineModule.share.mineStoryboard.instantiateViewController(withIdentifier: "AddKnightStepOneViewController") as! AddKnightStepOneViewController
			return vc
		}
		
		/// 我的 -> 骑手管理 -> 添加骑手 -> 选择门店
		navigator.register("chooseShop".routerUrl) { url, values, context in
			let vc = AAMineModule.share.mineStoryboard.instantiateViewController(withIdentifier: "AddKnightStepTwoViewController") as! AddKnightStepTwoViewController
			guard let para = context as? [String: Any?] else {
				return vc
			}
			if let type = para["editType"] as? KnightContentEditType {
				vc.knightContentEditType = type
			}
			if let knightaccountID = para["accountID"] as? String {
				vc.knightaccountID = knightaccountID
			}
			if let name = para["name"] as? String {
				vc.name = name
			}
			if let mobile = para["mobile"] as? String {
				vc.mobile = mobile
			}
			if let idCardNum = para["idCardNum"] as? String {
				vc.idCardNum = idCardNum
			}
			return vc
		}
	}
}
