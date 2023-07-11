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
	
	// 注销说明View
	@IBOutlet weak var cancellationView: UIView!
	// 注销按钮
	@IBOutlet weak var cancellationButton: UIButton!
	
	var accountCancellationViewModel:AccountCancellationViewModel?
	
	let commitAccountCancellationObservable =  PublishSubject<Void>()
	
	let disposeBag = DisposeBag()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
        bindViewModel()
    }
	func setUI() {
		self.title = "注销帐号"
		self.cancellationButton.layer.cornerRadius = 4
	}


	func bindViewModel() {
		let input = AccountCancellationViewModel.Input(commitAccountCancellationObservable: self.commitAccountCancellationObservable)
		
		self.accountCancellationViewModel = AccountCancellationViewModel(input: input)
		
		self.commitAccountCancellationObservable.subscribe(onNext: {
			self.view.showLoadingMessage()
		}).disposed(by: disposeBag)
		
		self.accountCancellationViewModel?.outPutCommitAccountCancellationObservable.subscribe(onNext: { json in
			self.view.dissmissLoadingView()
			let id = json["_id"].stringValue
			// 如果不为空 获取
			if (!id.isEmpty) {
				self.view.aoaoMakeToast("注销成功", completion: { _ in
					"login".openURL()
				})
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
	}
}
