//
//  AddKnightStepFirstViewController.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/6/8.
//

import UIKit
import aoao_common_ios
import RxSwift
/** 添加骑手-第一步
- 输入骑手姓名
	- 只能中文
- 输入骑手身份号
	- 15 or 18位 (数字+X x)
- 输入手机号
	- 仅支持国内手机号
	- 数字&符合手机号规则
*/
class AddKnightStepOneViewController: AAViewController {
	
	/// 姓名
	@IBOutlet weak var nameTextField: UITextField!
	/// 身份证号
	@IBOutlet weak var idCardNumberTextField: UITextField!
	/// 手机号
	@IBOutlet weak var phoneNumberTextField: UITextField!
	/// 下一步按钮
	@IBOutlet weak var nextStepButton: UIButton!
	
	let disposeBag = DisposeBag()
	
	var addKnightStepOneViewModel:AddKnightStepOneViewModel?
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
		bindViewModel()
    }
	func setUI(){
		self.title = "添加骑手"
		let bgColor = UIColor(named: "bgcolor_F5F5F5_000000", in: AAMineModule.share.bundle, compatibleWith: nil)
		
		self.view.backgroundColor = bgColor
	}
	func bindViewModel() {
		
		// 姓名输入序列
		let nameTextFieldObservable = self.nameTextField.rx.text.orEmpty.asObservable()
		// 姓名输入是否合法序列
		let nameTextisLegalObservable = nameTextFieldObservable.map{$0.matchStringFormat(WithRegex: CHINESEREGULAR)}
		
		/// 身份证号码输入序列
		let idNumberTextFieldObservable = self.idCardNumberTextField.rx.text.orEmpty.asObservable()
		
		/// 身份证号码是否合法序列
		let idNumberTextisLegalObservable = idNumberTextFieldObservable.map{ $0.matchStringFormat(WithRegex: IDCARDREGULAR)}
		
		/// 手机号码输入序列
		let phoneNumberTextFieldObservable = self.phoneNumberTextField.rx.text.orEmpty.asObservable()
		
		/// 手机号码是否合法序列
		let phoneNumberTextisLegalObservable = phoneNumberTextFieldObservable.map{ $0.matchStringFormat(WithRegex: PHONEREGULAR)}
		
		/// 所有输入是否合法
		let everythingisLegalObservable = Observable.combineLatest(nameTextisLegalObservable,
													   idNumberTextisLegalObservable,
													   phoneNumberTextisLegalObservable){$0 && $1 && $2}
		/// 如果合法 = true 则 可以点击 & 透明度 = 1
		everythingisLegalObservable.bind(to: self.nextStepButton.rx.isEnabled).disposed(by: disposeBag)
		
		everythingisLegalObservable.map{$0 ? 1 : 0.4}.bind(to: self.nextStepButton.rx.alpha).disposed(by: disposeBag)
		
		
		let nextStepObservable = nextStepButton.rx.tap.map{(
			name: self.nameTextField.text ?? "",
			idCardNumber: self.idCardNumberTextField.text ?? "",
			phoneNumber: self.phoneNumberTextField.text ?? "")}
		
		nextStepObservable.subscribe(onNext: { [unowned self] _ in
			self.navigationController?.view.showLoadingMessage()
		}).disposed(by: disposeBag)
		
		let input = AddKnightStepOneViewModel.Input.init(textFieldObservabel: nextStepObservable)
		
		self.addKnightStepOneViewModel = AddKnightStepOneViewModel.init(input: input)
		
		self.addKnightStepOneViewModel?.addKnightResultObservable.subscribe(onNext: {[unowned self] model in
			self.navigationController?.view.dissmissLoadingView()
			/// 手机号 与 身份证号 某一项重复
			/// 代表输入不合法
			if (!model.isJump && !model.ok) {
				self.view.makeToast(model.message)
				return
			}
			/// 骑手信息编辑状态
			var knightContentEditType = KnightContentEditType.create
			// ok = true 代表可以新骑手
			// 需要执行创建
			if model.ok {
				// 创建
				knightContentEditType = .create
			}
			// isJump = true 代表骑手是否存在(手机号+身份证可以匹配到骑手)
			// 需要执行编辑
			if model.isJump {
				knightContentEditType = .update
			}
			// 跳转下一页
			"chooseShop".openURL(para: ["editType": knightContentEditType, "accountID": model.id, "name": self.nameTextField.text, "mobile": self.phoneNumberTextField.text, "idCardNum": self.idCardNumberTextField.text])
		}).disposed(by: disposeBag)
		
		/// 错误处理
		self.addKnightStepOneViewModel?.errorObservable.subscribe(onNext: { error in
			self.navigationController?.view.dissmissLoadingView()
			self.view.makeToast(error.zhMessage)
		}).disposed(by: disposeBag)
		
		
	}

}
