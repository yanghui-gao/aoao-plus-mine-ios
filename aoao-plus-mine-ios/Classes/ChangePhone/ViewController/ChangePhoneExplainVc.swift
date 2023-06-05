//
//  ChangePhoneExplainVc.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/4/6.
//

import UIKit
import aoao_plus_common_ios
import RxSwift

/// 修改手机号
enum ChangePhoneType {
	/// 修改手机号
	case changePhone
	/// 手机号无效
	case invalidPhone
	
	func setTitle() -> String {
		switch self {
		case .changePhone:
			return "变更手机号"
		case .invalidPhone:
			return ""
		}
	}
	
	func setContentText() -> String {
		switch self {
		case .changePhone:
			guard let phone = UserModelManager.manager.userInfoModel?.phone else {
				return ""
			}
			return "您当前的手机号为 \(phone) \n如果您的手机号已不用，请及时更换。\n\n变更后的手机号将与您的身份证号绑定，该绑定关系将同步更新到您在APP内部所使用的应用以及功能中。\n请点击以下按钮进行变更手机号操作。"
		case .invalidPhone:
			return ""
		}
	}
}

class ChangePhoneExplainVc: AAViewController {
	/// 标题
	@IBOutlet weak var titleLabel: UILabel!
	/// 内容
	@IBOutlet weak var contentLabel: UILabel!
	/// 变更手机号
	@IBOutlet weak var changePhoneButton: UIButton!
	/// 修改手机号类型 (默认是修改手机号)
	var changePhoneType: ChangePhoneType = .changePhone
	
	var changePhoneViewModel:ChangePhoneViewModel?
	
	let disposebag = DisposeBag()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
		bindViewModel()
    }

	func setUI() {

		self.titleLabel.text = self.changePhoneType.setTitle()
		self.contentLabel.text = self.changePhoneType.setContentText()
		changePhoneButton.layer.cornerRadius = 4
	}
	/// 绑定
	func bindViewModel() {
		guard let userInfo = UserModelManager.manager.userInfoModel, let phone = userInfo.phone else {
			return
		}
		let tap = self.changePhoneButton.rx.tap
		
		let input = ChangePhoneViewModel.Input.init(getOldPhoneCode: tap.map{(phone: phone, if_voice: false, event: "vendor-reset-password")}, checkPhoneObservable: nil, getNewPhoneCode: nil)
		
		//添加点击加载框
		tap.subscribe(onNext: { _ in
			self.navigationController?.view.showLoadingMessage()
		}).disposed(by: disposebag)
		
		
		self.changePhoneViewModel = ChangePhoneViewModel.init(input: input)
		// 获取验证码回调
		self.changePhoneViewModel?.outPutGetOldPhoneCodeObservable.subscribe(onNext: { json in
			self.navigationController?.view.dissmissLoadingView()
			guard let _ = json["_id"].string else{
				self.view.makeToast("获取验证码失败, 请稍后再试")
				return
			}
			"changePhoneInputCode".openURL(para: ["phone": phone])
		}).disposed(by: disposebag)
		
		self.changePhoneViewModel?.outPutErrorObservable.subscribe(onNext: { error in
			self.navigationController?.view.dissmissLoadingView()
			self.view.makeToast(error.zhMessage)
		}).disposed(by: disposebag)
	}
}
