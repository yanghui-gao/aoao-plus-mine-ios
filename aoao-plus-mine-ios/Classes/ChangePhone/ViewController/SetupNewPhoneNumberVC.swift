//
//  SetupNewPhoneNumberVC.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/4/6.
//

import UIKit
import aoao_plus_common_ios
import RxSwift

class SetupNewPhoneNumberVC: AAViewController {

	// 手机号
	@IBOutlet weak var phoneTextField: PhoneNumberTextField!
	
	// 下一步
	@IBOutlet weak var nextSetupButton: UIButton!
	
	let disposeBag = DisposeBag()
	
	/// 获取新手机号验证码
	let getNewPhoneCodeObservable = PublishSubject<(phone: String, event: InputCodeType)>()
	
	/// 修改手机号
	var changePhoneViewModel:ChangePhoneViewModel?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
		bindViewModel()

    }
	func setUI() {
		self.phoneTextField.becomeFirstResponder()
	}
	func setAlert() {
		/// 弹窗发送验证码
		guard let textFieldText = self.phoneTextField.text else {
			return
		}
		let textFieldPhone = textFieldText.replacingOccurrences(of: " ", with: "")
		
		let alertVC = UIAlertController(title: "确认信息", message: "我们将发送短信验证码至：\n\(textFieldText)", preferredStyle: .alert)
		let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
		let confim = UIAlertAction(title: "好", style: .default) { _ in
			/// 发送新手机号验证码
			self.getNewPhoneCodeObservable.onNext((phone: textFieldPhone, event: .changePhone_getNewCode))
		}
		cancel.setValue(UIColor(named: "boss_000000-60_FFFFFF-60", in: AAMineModule.share.bundle, compatibleWith: nil), forKey: "titleTextColor")
		confim.setValue(UIColor(named: "Color_1FB1FF", in: AAMineModule.share.bundle, compatibleWith: nil), forKey: "titleTextColor")
		alertVC.addAction(cancel)
		alertVC.addAction(confim)
		self.navigationController?.present(alertVC, animated: true, completion: nil)
	}
	func bindViewModel() {
		/// 输入框序列
		let phoneTextFieldObservable = self.phoneTextField.rx.text.map { text -> Bool in
			guard let text = text else {
				return false
			}
			return text.isEmpty
		}
		/// 如果未输入手机号 则为 0.4透明度 否则为1
		phoneTextFieldObservable.map{$0 ? 0.4 : 1}.bind(to: self.nextSetupButton.rx.alpha).disposed(by: disposeBag)
		/// 需要对序列元素取反 如果是空则不可点击 isEnabled = false 反之亦然
		
		phoneTextFieldObservable.map{!$0}.bind(to: self.nextSetupButton.rx.isEnabled).disposed(by: disposeBag)
		
		/// 下一步点击事件
		nextSetupButton.rx.tap.subscribe(onNext: { _ in
			self.view.endEditing(true)
			// 与本地手机号判断是否一致
			guard let phone = UserModelManager.manager.userInfoModel?.phone else {
				self.view.aoaoMakeToast("原手机号获取失败, 请重试")
				return
			}
			/// 输入手机号
			guard let textFieldText = self.phoneTextField.text else {
				self.view.aoaoMakeToast("请输入新手机号!")
				return
			}
			/// 手机号是否与原手机号一致
			let textFieldPhone = textFieldText.replacingOccurrences(of: " ", with: "")
			
			/// 判断输入手机号是否与本手机号一致
			if textFieldPhone == phone {
				self.view.makeToast("新手机号不能与原手机号一致!")
				return
			}
			// 验证通过弹窗
			self.setAlert()
			
		}).disposed(by: disposeBag)
		
		let input = ChangePhoneViewModel.Input.init(getCodeObservable: self.getNewPhoneCodeObservable)
		
		self.changePhoneViewModel = ChangePhoneViewModel.init(input: input)
		
		/// 添加加载框
		self.getNewPhoneCodeObservable.subscribe(onNext: { _ in
			self.navigationController?.view.showLoadingMessage()
		}).disposed(by: disposeBag)
		
		
		/// 获取新手机号验证码回调
		self.changePhoneViewModel?.outPutResultObservable.subscribe(onNext: { _ in
			self.navigationController?.view.dissmissLoadingView()
			/// 输入手机号
			guard let textFieldText = self.phoneTextField.text else {
				return
			}
			let textFieldPhone = textFieldText.replacingOccurrences(of: " ", with: "")
			// 跳转新手机号验证页
			"newPhoneInputCode".openURL(para: ["phone": textFieldPhone])
		}).disposed(by: disposeBag)
		
		/// 错误回调
		self.changePhoneViewModel?.outPutErrorObservable.subscribe(onNext: { errorModel in
			self.navigationController?.view.dissmissLoadingView()
			self.view.makeToast(errorModel.zhMessage)
			self.view.endEditing(true)
		}).disposed(by: disposeBag)
	}
}
