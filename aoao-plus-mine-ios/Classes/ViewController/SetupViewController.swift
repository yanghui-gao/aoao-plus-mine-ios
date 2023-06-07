//
//  SetupViewController.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/3/11.
//

import UIKit
import RxSwift
import aoao_plus_common_ios

class SetupViewController: AAViewController {
	/// 语音提示开关
	@IBOutlet weak var VoiceSwitch: UISwitch!
	/// 震动开关
	@IBOutlet weak var vibrationSwitch: UISwitch!
	@IBOutlet weak var updateView: UIView!
	/// 更换手机号
	@IBOutlet var exchangePhoneTap: UITapGestureRecognizer!
	/// 检查更新
	@IBOutlet weak var checkupdateHeight: NSLayoutConstraint!
	
	@IBOutlet var setpasswordTap: UITapGestureRecognizer!
	@IBOutlet weak var isSetPassword: UILabel!
	
	@IBOutlet var checkUpdateTap: UITapGestureRecognizer!
	/// 关于
	@IBOutlet var aboutTap: UITapGestureRecognizer!
	
    @IBOutlet weak var logoutButton: UIButton!
	
	var loginOutViewModel:LoginOutViewModel?
	
	let loginOutObservable = PublishSubject<String>()
    /// 获取版本号
    var setupViewModel:SetupViewModel?
    
    /// 获取版本号序列
    let getVersionObservable = PublishSubject<Void>()
	
    let disposeBag = DisposeBag()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.setNavigationBarHidden(false, animated: animated)
	}
	override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
		bindViewModel()
    }
	func setUI() {
		self.title = "设置"
		self.view.backgroundColor = UIColor(named: "bgcolor_F5F5F5_000000", in: AAMineModule.share.bundle, compatibleWith: nil)
		VoiceSwitch.isOn = UserDefaults.standard.value(forKey: voiceCacheKey) as? Bool ?? true
		
		vibrationSwitch.isOn = UserDefaults.standard.value(forKey: vibrationCacheKey) as? Bool ?? true
        
        self.logoutButton.layer.cornerRadius = 4
		
		///审核账号移除检查更新
		if let model = UserModelManager.manager.userInfoModel {
			if model.id == "60780f7b577284611390db4d" {
				self.updateView.isHidden = true
				self.checkupdateHeight.constant = 0
			}
		}
		if let model =  UserModelManager.manager.userInfoModel, model.isSetPassword {
			self.isSetPassword.text = "已设置"
		} else {
			self.isSetPassword.text = "未设置"
		}
	}
	
	func bindViewModel() {
        
        let setupinput = SetupViewModel.Input.init(getVersionObservable: self.getVersionObservable)
        
        self.setupViewModel = SetupViewModel.init(input: setupinput)
        
        self.setupViewModel?.outPutResultObservable.subscribe(onNext: { json in
            self.navigationController?.view.dissmissLoadingView()
            print(json)
            if let resultCount = json["resultCount"].int {
                if resultCount != 0 {
                    let version = json["results"][0]["version"].stringValue
                    if let infoDictionary = Bundle.main.infoDictionary, let majorVersion = infoDictionary ["CFBundleShortVersionString"] as? String {
                        if version == majorVersion {
							self.view.makeToast("已经是最新版本")
						} else {
							let urlString = "itms-apps://itunes.apple.com/app/1554425649"
							if let url = URL(string: urlString) {
								UIApplication.shared.openURL(url)
							} else {
								self.view.makeToast("已经是最新版本")
							}
						}
                    }
				} else {
					self.view.makeToast("已经是最新版本")
				}
            } else {
                self.view.makeToast("已经是最新版本")
            }
            
        }).disposed(by: disposeBag)
        
        /// 显示加载框
        self.getVersionObservable.subscribe(onNext: { _ in
            self.navigationController?.view.showLoadingMessage()
        }).disposed(by: disposeBag)
        
        self.setupViewModel?.outPutErrorObservable.subscribe(onNext: { error in
            self.navigationController?.view.dissmissLoadingView()
            self.view.makeToast(error.zhMessage)
        }).disposed(by: disposeBag)
        
		/// 声音开关
		VoiceSwitch.rx.isOn.subscribe(onNext: { ison in
			UserDefaults.standard.setValue(ison, forKey: voiceCacheKey)
		}).disposed(by: disposeBag)
		
		/// 震动开关
		vibrationSwitch.rx.isOn.subscribe(onNext: { ison in
			UserDefaults.standard.setValue(ison, forKey: vibrationCacheKey)
		}).disposed(by: disposeBag)
		
		
		let input = LoginOutViewModel.Input.init(loginOutObservable: self.loginOutObservable)
		
		/// 退出登录Vm
		self.loginOutViewModel = LoginOutViewModel(input: input)
		
		self.loginOutObservable.subscribe(onNext: { _ in
			self.navigationController?.view.showLoadingMessage()
		}).disposed(by: disposeBag)
		/// 退出登录请求回调
		self.loginOutViewModel?.outPutResultObservable.subscribe(onNext: { _ in
			/// 移除用户信息
			UserModelManager.manager.removeUserInfo()
			/// 移除开关缓存
			UserDefaults.standard.removeObject(forKey: voiceCacheKey)
			UserDefaults.standard.removeObject(forKey: vibrationCacheKey)
			/// 跳转首页
			"login".openURL()
		}).disposed(by: disposeBag)
		
		self.loginOutViewModel?.outPutErrorObservable.subscribe(onNext: { error in
			self.navigationController?.view.dissmissLoadingView()
			self.view.makeToast(error.zhMessage)
		}).disposed(by: disposeBag)
		
		/// 关于点击事件
		self.aboutTap.rx.event.subscribe(onNext: { _ in
			"about".openURL()
		}).disposed(by: disposeBag)
		
		self.setpasswordTap.rx.event.subscribe(onNext: { _ in
			"setpassword".openURL()
		}).disposed(by: disposeBag)
		
		/// 修改手机号
		self.exchangePhoneTap.rx
			.event.subscribe(onNext: { _ in
				"changePhone".openURL()
			}).disposed(by: disposeBag)
		
		/// 检查更新
		self.checkUpdateTap.rx
			.event.subscribe(onNext: { _ in
                self.getVersionObservable.onNext(())
			}).disposed(by: disposeBag)
		
	}
    
    @IBAction func logout(_ sender: Any) {
		let alert = UIAlertController(title: nil, message: "确认退出登录？", preferredStyle: .alert)
		let confim = UIAlertAction(title: "确认", style: .default, handler: { action in
			/// 退出登录
			self.loginOutObservable.onNext(UserModelManager.manager.rootknightModel?.accessToken ?? "")
		})
		let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
		cancel.setValue(UIColor(named: "boss_000000-60_FFFFFF-60", in: AAMineModule.share.bundle, compatibleWith: nil), forKey:"titleTextColor")
		confim.setValue(UIColor(named: "color_19B675", in: AAMineModule.share.bundle, compatibleWith: nil), forKey:"titleTextColor")
		alert.addAction(confim)
		alert.addAction(cancel)
		self.navigationController?.present(alert, animated: true)
		
    }
    
}
