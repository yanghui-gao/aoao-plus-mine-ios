//
//  AccountCancellationViewController.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2023/3/29.
//

import UIKit
import aoao_plus_common_ios
import RxSwift

class AccountCancellationViewController: AAViewController {
	
	enum AccountCancellation:Int {
		case none = 1
		case cancelling = 10
		case cancelled = 100
	}
	// 注销说明View
	@IBOutlet weak var cancellationView: UIView!
	// 注销说明标题
	@IBOutlet weak var cancellationTitleLabel: UILabel!
	// 注销中
	@IBOutlet weak var cancellingView: UIView!
	// 注销按钮
	@IBOutlet weak var cancellationButton: UIButton!
	// 注销中说明
	@IBOutlet weak var cancellingLabel: UILabel!
	
	var accountCancellationViewModel:AccountCancellationViewModel?
	
	let commitAccountCancellationObservable =  PublishSubject<Void>()
	
	let accountCancellationInfoObservable =  PublishSubject<Void>()
	
	let disposeBag = DisposeBag()
	
	var accountCancellation:AccountCancellation? {
		didSet {
			guard let accountCancellation = self.accountCancellation else{
				return
			}
			self.cancellationButton.isHidden = false
			switch accountCancellation{
			case .none:
				self.cancellationView.isHidden = false
				self.cancellingView.isHidden = true
				self.cancellationButton.setTitle("我已了解风险，继续注销", for: .normal)
			case .cancelling:
				self.cancellationView.isHidden = true
				self.cancellingView.isHidden = false
				self.cancellationButton.setTitle("知道了", for: .normal)
			case .cancelled:
				self.cancellationView.isHidden = true
				self.cancellingView.isHidden = true
				self.cancellationButton.setTitle("知道了", for: .normal)
			}
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.accountCancellationInfoObservable.onNext(())
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
        bindViewModel()
    }
	func setUI() {
		self.title = "注销帐号"
		self.cancellationButton.layer.cornerRadius = 4
		if let usermodel = UserModelManager.manager.userInfoModel {
			cancellationTitleLabel.text = "申请注销\(usermodel.phoneStr)绑定的帐号"
			cancellingLabel.text = "您已申请注销\(usermodel.phoneStr)绑定的帐号\n平台将在7个工作日内处理完毕"
		}
	}


	func bindViewModel() {
		let input = AccountCancellationViewModel.Input(commitAccountCancellationObservable: self.commitAccountCancellationObservable, accountCancellationInfoObservable: self.accountCancellationInfoObservable)
		
		self.accountCancellationViewModel = AccountCancellationViewModel(input: input)
		
		self.accountCancellationViewModel?.outPutAccountCancellationInfoObservable.subscribe(onNext: { json in
			let state_int = json["state"].intValue
			self.accountCancellation = AccountCancellation.init(rawValue: state_int)
		}).disposed(by: disposeBag)
		
		self.commitAccountCancellationObservable.subscribe(onNext: {
			self.view.showLoadingMessage()
		}).disposed(by: disposeBag)
		
		self.accountCancellationViewModel?.outPutCommitAccountCancellationObservable.subscribe(onNext: { json in
			self.view.dissmissLoadingView()
			let id = json["_id"].stringValue
			// 如果不为空 获取
			if (!id.isEmpty) {
				// 重新获取消息
				self.accountCancellationInfoObservable.onNext(())
			} else {
				self.view.makeToast("申请失败, 请稍后再试")
			}
			
		}).disposed(by: disposeBag)

		
		self.accountCancellationViewModel?.outPutErrorObservable.subscribe(onNext: { error in
			self.view.dissmissLoadingView()
			self.view.makeToast(error.zhMessage)
		}).disposed(by: disposeBag)
		
	}
	@IBAction func cancellationAction(_ sender: UIButton) {
		guard let accountCancellation = self.accountCancellation else {
			return
		}
		switch accountCancellation {
		case .none:
			// 执行注销
			// 判断类型
			let alert = UIAlertController(title: nil, message: "您确定继续注销帐号吗？", preferredStyle: .alert)
			let confim = UIAlertAction(title: "确认", style: .default, handler: { action in
				self.commitAccountCancellationObservable.onNext(())
			})
			let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
			cancel.setValue(UIColor(named: "boss_000000-60_FFFFFF-60", in: AAMineModule.share.bundle, compatibleWith: nil), forKey:"titleTextColor")
			confim.setValue(UIColor(named: "color_19B675", in: AAMineModule.share.bundle, compatibleWith: nil), forKey:"titleTextColor")
			alert.addAction(confim)
			alert.addAction(cancel)
			self.navigationController?.present(alert, animated: true)
		case .cancelling, .cancelled:
			self.navigationController?.popViewController(animated: true)
			
		}
		
	}
}
