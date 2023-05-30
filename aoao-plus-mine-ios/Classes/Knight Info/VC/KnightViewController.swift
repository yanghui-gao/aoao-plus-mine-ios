//
//  KnightViewController.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/3/9.
//

import UIKit
import aoao_plus_common_ios
import RxSwift

enum KnightInfoPushType: Int {
	case mine = 1				// 我的
	case knightManager = 2		// 骑手管理
}

/// 骑士信息
class KnightViewController: AAViewController {

	/// 身份证信息状态
	@IBOutlet weak var idCardStatusLabel: UILabel!
	/// 健康证信息状态
	@IBOutlet weak var healthCardLabel: UILabel!
	/// 合同信息状态
	@IBOutlet weak var otherContentLabel: UILabel!
	/// 身份证信息点击
	@IBOutlet var idCardStatusTap: UITapGestureRecognizer!
	/// 健康证点击
	@IBOutlet var healthCardTap: UITapGestureRecognizer!
	/// 合同信息点击
	@IBOutlet var otherTap: UITapGestureRecognizer!
	/// 业绩查看
	@IBOutlet var achievementViewTap: UITapGestureRecognizer!
	/// 业绩查看
	@IBOutlet weak var achievementView: UIView!
	
	let getUserObservable = PublishSubject<String>()
	
	var getUserInfoViewModel:GetUserInfoViewModel?
	// 骑手详情信息
	var userInfoModel: KnightDetailInfoModel?
	/// 身份证是否完善
	var idCardisComplete: Bool? {
		didSet{
			guard let idCardisComplete = self.idCardisComplete else {
				return
			}
			idCardStatusLabel.text = idCardisComplete ? "已完善" : "未完善"
			let color_E84335 = UIColor(named: "Color_E84335-80", in: AAMineModule.share.bundle, compatibleWith: nil)
			let complete = UIColor(named: "boss_000000-60_FFFFFF-60", in: AAMineModule.share.bundle, compatibleWith: nil)
			idCardStatusLabel.textColor = idCardisComplete ? complete : color_E84335
		}
	}
	/// 健康证是否完善
	var healthisComplete: Bool? {
		didSet{
			guard let healthisComplete = self.healthisComplete else {
				return
			}
			healthCardLabel.text = healthisComplete ? "已完善" : "未完善"
			let color_E84335 = UIColor(named: "Color_E84335-80", in: AAMineModule.share.bundle, compatibleWith: nil)
			let complete = UIColor(named: "boss_000000-60_FFFFFF-60", in: AAMineModule.share.bundle, compatibleWith: nil)
			healthCardLabel.textColor = healthisComplete ? complete : color_E84335
		}
	}
	/// 合同信息是否完善
	var pactisComplete: Bool? {
		didSet{
			guard let pactisComplete = self.pactisComplete else {
				return
			}
			otherContentLabel.text = userInfoModel?.userSignState.toStr()

			let color_E84335 = UIColor(named: "Color_E84335-80", in: AAMineModule.share.bundle, compatibleWith: nil)
			let complete = UIColor(named: "boss_000000-60_FFFFFF-60", in: AAMineModule.share.bundle, compatibleWith: nil)
			otherContentLabel.textColor = pactisComplete ? complete : color_E84335
		}
	}
	// 骑手ID
	var accountID:String?
	
	// 是否显示数据统计
	var isShowWorkDetail = false
	
	// 门店ID 用于查询数据统计信息
	var shopID: String?
	
	let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
		bindViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		if let accountID = self.accountID {
			self.getUserObservable.onNext(accountID)
		}
    }
	func setUI() {
		self.title = "骑手信息"
		///
		self.view.backgroundColor = UIColor(named: "bgcolor_F5F5F5_000000", in: AAMineModule.share.bundle, compatibleWith: nil)
		if let _ = self.shopID {
			self.isShowWorkDetail = true
		} else {
			self.isShowWorkDetail = false
		}
		/// 业绩查看
		self.achievementView.isHidden = !(self.isShowWorkDetail)
	}
	func bindViewModel() {
		/// 身份证点击
		idCardStatusTap.rx.event.subscribe(onNext: { [unowned self] _ in
			if let idCardisComplete = self.idCardisComplete, idCardisComplete {
				/// 跳转查看身份信息
				"userinfomation".openURL(para: ["userInfoModel": self.userInfoModel])
			} else {
				/// 如果是从骑手管理页跳转 && 未完善 不跳转身份信息
				if self.isShowWorkDetail {
					return
				}
				/// 跳转完善身份信息
				"IDCardAIVc".openURL(para: ["pushSource": PushSource.upload])
			}
			
		}).disposed(by: disposeBag)
		
		/// 健康证点击
		healthCardTap.rx.event.subscribe(onNext: { _ in
			/// 如果是从骑手管理页跳转 && 未完善 则健康证信息不可点击
			if let healthisComplete = self.healthisComplete {
				if self.isShowWorkDetail && !healthisComplete {
					return
				}
			}
			"health".openURL(para: ["healthCardInfo": self.userInfoModel])
		}).disposed(by: disposeBag)
		
		/// 其他信息点击
		otherTap.rx.event.subscribe(onNext: { [unowned self] _ in
			/// 合同信息已完善
			guard let pactisComplete = self.pactisComplete else {
				return
			}
			if pactisComplete {
				guard let url = self.userInfoModel?.pactInfo.pactUrl else {
					self.view.aoaoMakeToast("获取合同信息失败, 请稍后再试")
					return
				}
				// 查看合同
				"contract".openURL(para: ["url": url])
			} else {
				/// 合同信息未完善
				/// 签约
				"sign".openURL()
			}
			
		}).disposed(by: disposeBag)
		
		// 业绩查看点击
		achievementViewTap.rx.event.subscribe(onNext: { _ in
			guard let shopID = self.shopID else {
				return
			}
			guard let model = self.userInfoModel else {
				return
			}
			"statistics".openURL(para: ["shopID": shopID, "userInfoID": model.id])
		}).disposed(by: disposeBag)
		
		let input = GetUserInfoViewModel.Input(getUserInfoContent: self.getUserObservable)
		
		self.getUserInfoViewModel = GetUserInfoViewModel(input: input)
		
		self.getUserInfoViewModel?
			.outPutResultObservable
			.subscribe(onNext: { model in
				self.userInfoModel = model
				self.pactisComplete = model.userSignState == .signed
				self.healthisComplete = model.userHealthCardState == .complete
				self.idCardisComplete = model.userIdCardState == .complete
			}).disposed(by: disposeBag)
		
		/// 错误信息
		self.getUserInfoViewModel?
			.outPutErrorObservable
			.subscribe(onNext: { error in
			self.view.makeToast(error.zhMessage)
		}).disposed(by: disposeBag)
		
	}
}
