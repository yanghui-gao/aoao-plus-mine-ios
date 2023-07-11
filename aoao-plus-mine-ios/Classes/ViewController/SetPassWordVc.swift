//
//  SetPassWordVc.swift
//  aoao-plus-order-ios
//
//  Created by 高炀辉 on 2023/6/2.
//	设置新密码 修改密码

import UIKit
import aoao_plus_common_ios
import RxSwift

class SetPassWordVc: AAViewController {
	
	@IBOutlet weak var completeButton: UIButton!
	
	@IBOutlet weak var oldPasswordView: UIView!
	@IBOutlet weak var oldPasswordTextField: UITextField!
	
	@IBOutlet weak var newPasswordView: UIView!
	@IBOutlet weak var newPasswordField: UITextField!
	
	@IBOutlet weak var confimNewPasswordView: UIView!
	@IBOutlet weak var confimPasswordField: UITextField!
	// 设置密码
	var setPassWordViewModel:SetPassWordViewModel?
	
	let setPassWordObservable = PublishSubject<(oldpassword: String?, newpassword: String)>()
	
	let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
		bindViewModel()
    }

	func setUI() {
		self.completeButton.layer.cornerRadius = 4
		if let model = UserModelManager.manager.userInfoModel, model.isSetPassword {
			oldPasswordView.isHidden = false
		} else {
			self.oldPasswordTextField.text = "--"
			oldPasswordView.isHidden = true
		}
	}
	
	func bindViewModel() {
		
		self.completeButton
			.rx.tap
			.subscribe(onNext: {
				self.view.endEditing(true)
				guard let new = self.newPasswordField.text else {
					return
				}
				guard let confimNew = self.confimPasswordField.text else {
					return
				}
				if !new.matchStringFormat(WithRegex: PASSWORDREGULAR) {
					self.view.aoaoMakeToast("新密码不符合规则, 请重新输入")
					return
				}
				if confimNew != new {
					self.view.aoaoMakeToast("两次输入密码不一致, 请重新输入")
					return
				}
				
				// 密码加密
				guard let newPassword = new.passWordEncrypt(key: pwkey) else {
					self.view.aoaoMakeToast("密码加密失败, 请重新输入")
					return
				}
				
				if let model =  UserModelManager.manager.userInfoModel, model.isSetPassword {
					guard let old = self.oldPasswordTextField.text else {
						self.view.aoaoMakeToast("请输入旧密码")
						return
					}
					guard let oldPassword = old.passWordEncrypt(key: pwkey) else {
						self.view.aoaoMakeToast("密码加密失败, 请重新输入")
						return
					}
					self.setPassWordObservable.onNext((oldpassword: oldPassword, newpassword: newPassword))
					return
				}
				self.setPassWordObservable.onNext((oldpassword: nil, newpassword: newPassword))
		}).disposed(by: disposeBag)
		
		let oldPasswordTextFieldObservable = self.oldPasswordTextField.rx.text.asObservable().map{$0 ?? ""}
		
		let newPasswordFieldObservable = self.newPasswordField.rx.text.asObservable().map{$0 ?? ""}
		
		let confimPassWordObservable = self.confimPasswordField.rx.text.asObservable().map{$0 ?? ""}
		
		let input = SetPassWordViewModel.Input(oldPassWordObservable: oldPasswordTextFieldObservable, newPassWordObservable: newPasswordFieldObservable, confimPassWordObservable: confimPassWordObservable, setPassWordObservable: setPassWordObservable)
		
		self.setPassWordViewModel = SetPassWordViewModel(input: input)
		
		self.setPassWordViewModel?.outPutButtonIsEnableObservable.bind(to: self.completeButton.rx.isEnabled).disposed(by: disposeBag)
		
		self.setPassWordViewModel?.outPutButtonIsEnableObservable.map{$0 ? 1 : 0.4}.bind(to: self.completeButton.rx.alpha).disposed(by: disposeBag)
		
		self.setPassWordViewModel?.outPutResultObservable.subscribe(onNext: { [unowned self] _ in
			self.view.showSuccessMessage(message: "修改成功", handle: {
				"login".openURL()
			})
		}).disposed(by: disposeBag)
		
		self.setPassWordViewModel?.outPutErrorObservable.subscribe(onNext: { [unowned self] error in
			self.view.aoaoMakeToast(error.zhMessage)
			self.view.endEditing(true)
		}).disposed(by: disposeBag)
	}
}
