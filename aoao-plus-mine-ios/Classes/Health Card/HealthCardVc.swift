//
//  HealthCardVc.swift
//  boss-mine-ios
//
//  Created by 高炀辉 on 2020/9/1.
//

import UIKit
import aoao_plus_common_ios
import Kingfisher
import RxSwift
import aoao_plus_net_ios
import Moya
import SwiftDate


enum HealthEditStatus {
	case edit			// 编辑状态
	case done			// 完成状态
}

class HealthCardVc: AAViewController {
    // 正面
    @IBOutlet weak var healthCardT: UIButton!
    // 反面
    @IBOutlet weak var healthCardB: UIButton!
    // 有效期
    @IBOutlet weak var healthDateLabel: UILabel!
    // 提交按钮
    @IBOutlet weak var commitButton: UIButton!
    // 正面
    @IBOutlet weak var positiveImageView: UIImageView!
    // 反面
    @IBOutlet weak var backImageVIew: UIImageView!
    // 健康证 有效期 开始时间
	var healthCardStartDate: Int?
    // 健康证 有效期 结束时间
	var healthCardEndDate: Int?

    @IBOutlet var selectDateTap: UITapGestureRecognizer!

    var healthCardViewModel: HealthCardViewModel?
    
    var healthEditStatus:HealthEditStatus = .edit

	// 编辑状态
	var editStatus: HealthEditStatus?
	
    
	private let editStatusObservable = PublishSubject<HealthEditStatus>()
    /// 健康证信息(从前一个页面传递)
	var userInfoModel: KnightDetailInfoModel?
    /// 设置健康证信息
    private let setHealthObservable = PublishSubject<KnightDetailInfoModel?>()
    /// 正面
    private var frontImage: UIImage?
    /// 反面
    private var backImage: UIImage?
    
    // 提交事件序列
    let commitObservable = PublishSubject<(healthCertificate: UIImage?, healthCertificateBack: UIImage?, healthCertificateStart: Int, healthCertificateEnd: Int, userid: String)>()
    
    private let healthCardFrontkeyObservable = PublishSubject<String>()
    
    private let healthCardReversekeyObservable = PublishSubject<String>()
    
    private let healthCardDateObservable = PublishSubject<String>()
	
	
    
    let disposeBag = DisposeBag()

    private var imageTag = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
		setHealthObservable.onNext(self.userInfoModel)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func setUI() {
        // 圆角
        self.commitButton.layer.cornerRadius = 4
        
        self.commitButton.isEnabled = false
        self.commitButton.alpha = 0.4
    }
	func bindButtonTapEvent() {
		// 健康证正面点击
		self.healthCardT.rx.tap.subscribe { [unowned self] _ in
			self.imageTag = 0
			normalCameraModule.manager.openCameraFromAlert()
		}.disposed(by: disposeBag)
		// 健康证反面点击
		self.healthCardB.rx.tap.subscribe { [unowned self] _ in
			self.imageTag = 1
			normalCameraModule.manager.openCameraFromAlert()
		}.disposed(by: disposeBag)
		// 选择时间 点击事件
		self.selectDateTap.rx.event.subscribe(onNext: { [unowned self] _ in
            guard let _ = self.frontImage else {
                self.navigationController?.view.showfailMessage(message: "请选择健康证正面照片", handle: nil)
                return
            }
            guard let _ = self.BackImage else {
                self.navigationController?.view.showfailMessage(message: "请选择健康证反面照片", handle: nil)
                return
            }
			AADatePickerView.start_start_date = Date() - 2.years
			AADatePickerView.start_end_date = Date() + 1.years
			AADatePickerView.end_start_date = Date() - 2.years
			AADatePickerView.end_end_date = Date() + 2.years
			AACommonMoudle.share.datePickerView?.show(confirmHandle: { [unowned self] (res) in
				// 处理确定后的时间
				self.healthCardStartDate = Int(res.start.replacingOccurrences(of: ".", with: ""))
				self.healthCardEndDate = Int(res.end.replacingOccurrences(of: ".", with: ""))
                self.healthDateLabel.text = "\(res.start) - \(res.end)"
                healthCardDateObservable.onNext("\(res.start) - \(res.end)")
			})
		}).disposed(by: disposeBag)
	}
	func upLoadImageView() {
		// 选择图片就上传
        normalCameraModule.manager.imageObservable.subscribe(onNext: { image in
            if self.imageTag == 0 {
				self.frontImage = image
                self.positiveImageView.image = image
            } else {
				self.backImage = image
                self.backImageVIew.image = image
            }
        }).disposed(by: disposeBag)
	}
    func bindViewModel() {
		// 点击事件序列
		self.bindButtonTapEvent()
		// 上传事件序列
		self.upLoadImageView()
        
        self.commitButton.rx.tap.subscribe(onNext: { _ in
            if self.commitButton.titleLabel?.text == "更换健康证" {
                self.healthEditStatus = .edit
                self.editStatusObservable.onNext(.edit)
            } else {
				guard let _ = self.healthCardFrontkey else {
					self.navigationController?.view.showfailMessage(message: "请选择健康证正面照片", handle: nil)
					return
				}
				guard let _ = self.healthCardReversekey else {
					self.navigationController?.view.showfailMessage(message: "请选择健康证反面照片", handle: nil)
					return
				}
				guard let _ = self.healthCardStartDate else {
					self.navigationController?.view.showfailMessage(message: "请选择有效期", handle: nil)
					return
				}
				guard let _ = self.healthCardEndDate else {
					self.navigationController?.view.showfailMessage(message: "请选择有效期", handle: nil)
					return
				}
                self.commitObservable.onNext(
                    (healthCertificate: self.positiveImageView.image,
                     healthCertificateBack: self.backImageVIew.image,
                     healthCertificateStart: self.healthCardStartDate ?? 0,
                     healthCertificateEnd: self.healthCardEndDate ?? 0,
                     userid: UserModelManager.manager.userInfoModel?.id ?? ""))
                self.navigationController?.view.showLoadingMessage(message: "上传中...")
            }
        }).disposed(by: disposeBag)
        
		let input = HealthCardViewModel.Input(commitObservable: self.commitObservable)

		healthCardViewModel = HealthCardViewModel(input: input)
        
		healthCardViewModel?.outPutResultObservable.subscribe(onNext: { [unowned self] res in
            self.navigationController?.view.dissmissLoadingView()
            self.navigationController?.view.showSuccessMessage(message: "上传成功", handle: {
                self.navigationController?.popViewController(animated: true)
            })
		}).disposed(by: disposeBag)

        healthCardViewModel?.outPutErrorObservable.subscribe(onNext: { error in
            self.navigationController?.view.dissmissLoadingView()
            self.navigationController?.view.showfailMessage(message: error.zhMessage, handle: nil)
        }).disposed(by: disposeBag)

        // 获取健康证信息成功
        self.setHealthObservable.subscribe(onNext: { [unowned self] userModel in
			guard let model = userModel else {
				self.editStatusObservable.onNext(.edit)
				return
			}
            self.navigationController?.view.dissmissLoadingView()
			// 正面
			if let urlStr = model.frontUrl, let url = URL(string: urlStr) {
				self.positiveImageView.kf.setImage(with: url, placeholder: UIImage(named: "placehold_Image", in: AAMineModule.share.bundle, compatibleWith: nil), completionHandler: { res in
					switch res {
					case .success(let result):
						// 图片异步处理所以在展示的时候需要判断当前界面状态
						if self.healthEditStatus == .edit {
							self.positiveImageView.image = UIImage(named: "uploadImage", in: AAMineModule.share.bundle, compatibleWith: nil)
						} else {
							self.positiveImageView.image = result.image
						}
					case .failure(let error):
						print(error)
					}
					
				})
			}
			// 背面
			if let urlStr = model.healthCardInfo.backUrl, let url = URL(string: urlStr) {
				self.backImageVIew.kf.setImage(with: url, placeholder: UIImage(named: "placehold_Image", in: AAMineModule.share.bundle, compatibleWith: nil), completionHandler: { res in
					switch res {
					case .success(let result):
						// 图片异步处理所以在展示的时候需要判断当前界面状态
						if self.healthEditStatus == .edit {
							self.backImageVIew.image = UIImage(named: "uploadImage", in: AAMineModule.share.bundle, compatibleWith: nil)
						} else {
							self.backImageVIew.image = result.image
						}
					case .failure(let error):
						print(error)
					}
					
				})
			}
			// 开始 结束时间
			if let strat = model.healthCardInfo.fromDateStr, let end = model.healthCardInfo.endDateStr {
				healthDateLabel.text = "\(strat)-\(end)"
				healthDateLabel.textColor = UIColor(named: "boss_000000-90_FFFFFF-90", in: Bundle.main, compatibleWith: nil)
			}
			self.editStatusObservable.onNext(.done)
        }).disposed(by: disposeBag)

        self.editStatusObservable.subscribe(onNext: { state in
			self.healthEditStatus = state
            switch state {
            case .done:
				if self.userInfoModel?.id == UserModelManager.manager.userInfoModel?.id {
					self.title = "我的健康证"
				} else {
					self.title = "骑手健康证"
				}
                
                self.commitButton.setTitle("更换健康证", for: .normal)
                self.selectDateTap.isEnabled = false
                self.healthCardT.isEnabled = false
                self.healthCardB.isEnabled = false
                self.commitButton.isEnabled = true
                self.commitButton.alpha = 1
				/// 如果查看时: 查看本人的健康证信息 可以更新
				self.commitButton.isHidden = !(self.userInfoModel?.id == UserModelManager.manager.userInfoModel?.id)
				
            case .edit:
                self.title = "上传健康证"
                self.selectDateTap.isEnabled = true
                self.positiveImageView.image = UIImage(named: "uploadImage", in: AAMineModule.share.bundle, compatibleWith: nil)
                self.backImageVIew.image = UIImage(named: "uploadImage", in: AAMineModule.share.bundle, compatibleWith: nil)
                self.commitButton.setTitle("保存", for: .normal)
                self.healthDateLabel.text = "请选择有效期"
                self.healthCardFrontkeyObservable.onNext("")
                self.healthCardReversekeyObservable.onNext("")
                self.healthCardDateObservable.onNext("")
                self.healthDateLabel.textColor = UIColor(named: "boss_000000-40_FFFFFF-40", in: Bundle.main, compatibleWith: nil)
                self.healthCardT.isEnabled = true
                self.healthCardB.isEnabled = true
                self.commitButton.isEnabled = true
                self.commitButton.alpha = 1
            }
        }).disposed(by: disposeBag)
        
        let isCommitObservable = self.editStatusObservable.filter{$0 != .edit}.flatMapFirst{ _ -> Observable<Bool> in
            return Observable.combineLatest(self.healthCardFrontkeyObservable, self.healthCardReversekeyObservable, self.healthCardDateObservable){!$0.isEmpty && !$1.isEmpty && !$2.isEmpty}
        }
        isCommitObservable.bind(to: self.commitButton.rx.isEnabled).disposed(by: disposeBag)
        isCommitObservable.map{$0 ? 1 : 0.4}.bind(to: self.commitButton.rx.alpha).disposed(by: disposeBag)
    }

}
