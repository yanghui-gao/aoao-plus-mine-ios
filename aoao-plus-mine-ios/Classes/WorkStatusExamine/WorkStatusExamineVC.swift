//
//  WorkStatusExamineVC.swift
//  aoao-plus-Mine-ios
//
//  Created by 高炀辉 on 2023/6/7.
// 	接单检测


import UIKit
import RxSwift
import aoao_plus_common_ios

class WorkStatusExamineVC: AAViewController {
	// 未实名时 显示
	@IBOutlet weak var unAttestationLabel: UILabel!
	// 实名成功 View
	@IBOutlet weak var attestationView: UIView!
	// 实名成功 显示
	@IBOutlet weak var attestationSuccessLabel: UILabel!
	// 实名成功时 显示
	@IBOutlet weak var attestationSuccessIcon: UIImageView!
	
	// 签约View
	@IBOutlet weak var contractView: UIView!
	// 签约成功
	@IBOutlet weak var signSuccessIcon: UIImageView!
	// 签约成功
	@IBOutlet weak var signedLabel: UILabel!
	// 未签约
	@IBOutlet weak var unSignLabel: UILabel!
	
	// 健康证
	@IBOutlet weak var healthView: UIView!
	// 健康证未填写
	@IBOutlet weak var healthNotFilledLabel: UILabel!
	// 健康证填写
	@IBOutlet weak var healthFilledLabel: UILabel!
	// 健康证填写 icon
	@IBOutlet weak var healthFilledIcon: UIImageView!
	
	// 未开启 语音 震动 显示
	@IBOutlet weak var voice_vibrationLabel: UILabel!
	// 开启 语音 震动 成功 显示
	@IBOutlet weak var voice_vibrationSuccessLabel: UILabel!
	// 开启 语音 震动 成功时 显示
	@IBOutlet weak var voice_vibrationSuccessIcon: UIImageView!
	
	// 未开启通知显示
	@IBOutlet weak var notificationErrorLabel: UILabel!
	// 开启通知成功 显示
	@IBOutlet weak var notificationSuccessLabel: UILabel!
	// 开启通知成功时 显示
	@IBOutlet weak var notificationSuccessIcon: UIImageView!
	
	// 未开启位置权限 显示
	@IBOutlet weak var locationErrorLabel: UILabel!
	// 开启位置权限成功 显示
	@IBOutlet weak var locationSuccessLabel: UILabel!
	// 开启位置权限成功时 显示
	@IBOutlet weak var locationSuccessIcon: UIImageView!
	
	// 未开启相机 显示
	@IBOutlet weak var cameraErrorLabel: UILabel!
	// 开启相机成功 显示
	@IBOutlet weak var cameraSuccessLabel: UILabel!
	// 开启相机成功时 显示
	@IBOutlet weak var cameraSuccessIcon: UIImageView!

	@IBOutlet weak var contentView: UIView!
	
	let notificationName = Notification.Name(rawValue: "getOrderListNotification")
	
	// 骑手工作状态
	var knightWorkViewModel:WorkStatusExamineVM?
	/// 获取骑手信息
	let getKnightObservable = PublishSubject<String>()

	let disposeBag = DisposeBag()
	
	var rightBarButtonItem: UIBarButtonItem{
		get{
			let qhRightButton = UIBarButtonItem(title: "重新检测", style: .done, target: self, action: #selector(recheck))
			qhRightButton.tintColor = UIColor(named: "Color_00AD66", in: AACommonMoudle.share.bundle, compatibleWith: nil)
			return qhRightButton
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setUI()
		bindViewModel()
		workStateViewModel()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.setNavigationBarHidden(false, animated: animated)
		guard let id = UserModelManager.manager.userInfoModel?.id else {
			return
		}
		self.getKnightObservable.onNext(id)
	}
	// chonx
	override func applicationDidBecomeActive() {
		super.applicationDidBecomeActive()
		bindViewModel()
		workStateViewModel()
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
	}
	func setUI() {
		self.title = "接单检测"
		self.navigationController?.navigationItem.rightBarButtonItem = self.rightBarButtonItem
	}
	func bindViewModel() {
		/// 通知权限是否打开
		AAPermissionsManager.manager.isNotificationServiceOpen.subscribe(onNext: { [unowned self] isOk in
			DispatchQueue.main.async {
				self.notificationErrorLabel.isHidden = isOk
				self.notificationSuccessLabel.isHidden = !isOk
				self.notificationSuccessIcon.isHidden = !isOk
			}
			
		}).disposed(by: disposeBag)
		
		/// 语音 震动是否打开
		AAPermissionsManager.manager.voice_vibration.subscribe(onNext: { [unowned self] isOk in
			DispatchQueue.main.async {
				self.voice_vibrationLabel.isHidden = isOk
				self.voice_vibrationSuccessLabel.isHidden = !isOk
				self.voice_vibrationSuccessIcon.isHidden = !isOk
			}
		}).disposed(by: disposeBag)
		
		/// 定位
		AAPermissionsManager.manager.isAuthorizationServiceOpen.subscribe(onNext: { [unowned self] isOk in
			DispatchQueue.main.async {
				self.locationErrorLabel.isHidden = isOk
				self.locationSuccessLabel.isHidden = !isOk
				self.locationSuccessIcon.isHidden = !isOk
			}
			
		}).disposed(by: disposeBag)
		
		/// 相机
		AAPermissionsManager.manager.iscameraPermissions.subscribe(onNext: { [unowned self] isOk in
			DispatchQueue.main.async {
				self.cameraErrorLabel.isHidden = isOk
				self.cameraSuccessLabel.isHidden = !isOk
				self.cameraSuccessIcon.isHidden = !isOk
			}
		}).disposed(by: disposeBag)
		
		AAPermissionsManager.manager.isSignPermissions.subscribe(onNext: { [unowned self] isOk in
			DispatchQueue.main.async {
				self.unSignLabel.isHidden = isOk
				self.signedLabel.isHidden = !isOk
				self.signSuccessIcon.isHidden = !isOk
			}
		}).disposed(by: disposeBag)
		
		
		AAPermissionsManager.manager.healthPermissions.subscribe(onNext: { [unowned self] isOk in
			DispatchQueue.main.async {
				// 是否展示错误提示
				self.healthNotFilledLabel.isHidden = isOk
				// 是否显示已完成
				self.healthFilledLabel.isHidden = !isOk
				self.healthFilledIcon.isHidden = !isOk
			}
		}).disposed(by: disposeBag)
		
		if let list = UserModelManager.manager.userInfoModel?.allowWorkScope {
			// 是否包含健康证权限验证
			self.healthView.isHidden = !list.contains("health_card")
			// 是否包含签约权限验证
			self.contractView.isHidden = !list.contains("pact")
			// 是否包含实名认证验证
			self.attestationView.isHidden = !list.contains("authentication")
		}
	}
	func workStateViewModel() {
		let input = WorkStatusExamineVM.Input(
			getKnightWorkInfoObservable: self.getKnightObservable)
		
		self.knightWorkViewModel = WorkStatusExamineVM(input: input)
		
		// 骑手信息
		self.knightWorkViewModel?
			.outPutKnightUserInfoModelResultObservable
			.subscribe(onNext: {[unowned self] _ in
				// 权限编辑
				self.bindViewModel()
			}).disposed(by: disposeBag)
		
		self.knightWorkViewModel?.outPutErrorObservable.subscribe(onNext: { [unowned self] error in
			self.navigationController?.view.dissmissLoadingView()
			self.navigationController?.view.makeToast(error.zhMessage)
		}).disposed(by: disposeBag)
	}
	
	// MARK: 点击事件
	@objc func recheck() {
		guard let id = UserModelManager.manager.userInfoModel?.id else {
			self.view.aoaoMakeToast("获取用户信息失败, 请重试")
			return
		}
		self.getKnightObservable.onNext(id)
	}
	
	@IBAction func voice_vibrationTap(_ sender: UITapGestureRecognizer) {
		/// 跳转设置页
		AAPermissionsManager.manager.voice_vibration.subscribe(onNext: { isOk in
			if !isOk {
				"setup".openURL()
			}
		}).disposed(by: disposeBag)
		
	}
	
	@IBAction func notificationTap(_ sender: UITapGestureRecognizer) {
		/// 管理通知权限
		AAPermissionsManager.manager.getCurrentAuthorizationPermissions()
	}
	
	@IBAction func locationTap(_ sender: Any) {
		/// 管理定位权限
		AAPermissionsManager.manager.getCurrentLocationPermissions()
	}
	
	@IBAction func cameraTap(_ sender: Any) {
		/// 相机权限
		AAPermissionsManager.manager.getCameraPermissions(determinedHandle: nil)
	}
	@IBAction func contractTap(_ sender: Any) {
		"sign".openURL()
	}
	@IBAction func healthCardTap(_ sender: Any) {
		guard let userModel = UserModelManager.manager.userInfoModel else {
			self.view.aoaoMakeToast("获取用户信息失败")
			return
		}
		// 跳转健康证
		"health".openURL(para: ["healthCardInfo": userModel])
	}
}
