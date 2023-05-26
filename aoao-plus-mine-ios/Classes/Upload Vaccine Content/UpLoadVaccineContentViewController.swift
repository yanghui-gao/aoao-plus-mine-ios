//
//  UpLoadVaccineContentViewController.swift
//  flashman
//
//  Created by 高炀辉 on 2021/1/25.
//  Copyright © 2021 white. All rights reserved.
//

import UIKit
import aoao_common_ios
import RxSwift
import PGDatePicker
import SwiftDate
import JXPhotoBrowser

/// 附加信息有两个入口
/*
1. 个人信息 -> 骑手信息
2. 骑手管理 -> 指定骑手的骑手信息
- 两者区别在于 是否传递了 骑手对象 无骑手对象 -> 不合格情况下 可编辑
							  有骑手对象 -> 不合格情况下 不可编辑

// TODO: 全部更改为传递用户对象 根据 用户ID 比对是否为当前登录骑手
//
**/

class UpLoadVaccineContentViewController: AAViewController {
	/// 错误信息View
	@IBOutlet weak var errorContentView: UIView!
	/// 错误信息
	@IBOutlet weak var errorLabel: UILabel!
	/// 日期
	@IBOutlet weak var detectionDateLabel: UILabel!
	/// 过期日期
	@IBOutlet weak var detectionOverdueLabel: UILabel!
	/// 附件二日期
	@IBOutlet weak var inoculateLabel: UILabel!
	/// 编辑时: 请上传您的附件一截图
	/// 查看是: 附件一截图
	@IBOutlet weak var detectionTipLabel: UILabel!
	/// 编辑时: 上传截图
	/// 查看时: 网络图
	@IBOutlet weak var detectionImageView: UIImageView!
	/// 选择附件一图片Button
	@IBOutlet weak var detectionImageButton: UIButton!
	/// 编辑时: 请上传您的附件二截图
	/// 查看是: 附件二截图
	@IBOutlet weak var inoculateTipLabel: UILabel!
	/// 编辑时: 上传截图
	/// 查看时: 网络图
	@IBOutlet weak var inoculateImageView: UIImageView!
	
	/// 附件二截图 Button
	@IBOutlet weak var inoculateImageButton: UIButton!
	/// 编辑时: 提交信息
	/// 查看时:
	/// 	- 合格 不可编辑
	///		- 出错 重新提交
	@IBOutlet weak var commitButton: UIButton!
	
	/// 附件一日期Tap
	@IBOutlet var detectionDateTap: UITapGestureRecognizer!
	
	/// 附件一日期序列
	let detectionDateObservable = PublishSubject<String>()
	
	/// 附件一过期日期Tap
	@IBOutlet var detectionOverdueTap: UITapGestureRecognizer!
	
	/// 附件一过期序列
	let detectionOverdueObservable = PublishSubject<String>()
	
	/// 附件二Tap
	@IBOutlet var inoculateTap: UITapGestureRecognizer!
	
	/// 附件二序列
	let inoculateObservable = PublishSubject<String>()
	
	/// 附件一Image
	let detectionImageObservable = PublishSubject<UIImage?>()
	/// 附件二image
	let inoculateImageObservable = PublishSubject<UIImage?>()
	
	/// 当前附件二信息状态
	enum UpLoadVaccineContentState: Int {
		case done           = 100			// 完成
		case error          = -100			// 错误
		case empty			= 1             // 未填写
		case ongoing		= 50	        // 进行中
	}
	
	enum UpLoadVaccineSelectDate {
		case detection			// 附件一
		case inoculate			// 附件二
		case detectionpastDue	// 附件一过期
	}
	let vaccineContentStateobservable = PublishSubject<UpLoadVaccineContentState>()
	
	let disposeBag = DisposeBag()
	
	private var selectTag = 0
	
	var upLoadVaccineContentViewModel:UpLoadVaccineContentViewModel?
	
	var vaccineModel:UpLoadVaccineContentModel?
	
	let getVaccineContentObservable = PublishSubject<String>()
	
	public var upLoadVaccineContentState: UpLoadVaccineContentState = .empty
	
	var userInfoModel:UserInfoModel?
	
	typealias ParaType = (detectionDate: String?, detectionOverdue: String?, inoculate: String?, detectionImage: UIImage?, inoculateImage: UIImage?, courierId: String, isUpdate: Bool, vaccinationId: String?)
	
	var para: ParaType?
	
	/// 是否调用更新接口
	var isUpdate = false
	
	var commitObservable = PublishSubject<ParaType?>()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		setUI()
		bindViewModel()
		self.vaccineContentStateobservable.onNext(.empty)
		if let usermodel = self.userInfoModel, let vaccinationId = usermodel.vaccinationId, usermodel.vaccinationisFix {
			self.navigationController?.view.showLoadingMessage(message: "加载中...")
			self.getVaccineContentObservable.onNext(vaccinationId)
		}
		
	}
	func setUI() {
		self.title = "附件信息"
		
		self.commitButton.layer.cornerRadius = 4
	}
	func setDatePicker(type: UpLoadVaccineSelectDate) {
		let datePickManager = PGDatePickManager()
		datePickManager.confirmButtonTextColor = UIColor(named: "Color_00AD66", in: AAMineModule.share.bundle, compatibleWith: nil)
		datePickManager.cancelButtonTextColor = UIColor(named: "boss_000000-60_FFFFFF-60", in: AAMineModule.share.bundle, compatibleWith: nil)
		datePickManager.headerViewBackgroundColor = UIColor(named: "color_F8F8F8", in: AAMineModule.share.bundle, compatibleWith: nil)
		datePickManager.titleLabel.text = "选择日期"
		let datePicker = datePickManager.datePicker
		datePicker?.datePickerMode = .date
		datePicker?.maximumDate = Date() + 8.hours + 1.years
		datePicker?.minimumDate = Date() + 8.hours - 1.years
		datePicker?.selectedDate = { date in
			if let date = date, let year = date.year, let month = date.month, let day = date.day {
				
				let dateStr = "\(year)-\(month < 10 ? "0\(month)": "\(month)")-\(day < 10 ? "0\(day)": "\(day)")"
				switch type {
				case .detection:
					self.detectionDateLabel.text = dateStr
					self.detectionDateLabel.textColor = UIColor(named: "boss_000000-80_FFFFFF-80", in: AAMineModule.share.bundle, compatibleWith: nil)
					self.detectionDateObservable.onNext(dateStr)
				case .detectionpastDue:
					self.detectionOverdueLabel.text = dateStr
					self.detectionOverdueLabel.textColor = UIColor(named: "boss_000000-80_FFFFFF-80", in: AAMineModule.share.bundle, compatibleWith: nil)
					self.detectionOverdueObservable.onNext(dateStr)
				case .inoculate:
					self.inoculateLabel.text = dateStr
					self.inoculateLabel.textColor = UIColor(named: "boss_000000-80_FFFFFF-80", in: AAMineModule.share.bundle, compatibleWith: nil)
					self.inoculateObservable.onNext(dateStr)
				}
			}
		}
		self.present(datePickManager, animated: true, completion: nil)
		
	}
	func bindViewModel() {
		/// 监听当前状态
		self.vaccineContentStateobservable.subscribe(onNext: { state in
			self.upLoadVaccineContentState = state
			switch state {
			case .empty:
				// 隐藏错误信息
				self.errorContentView.isHidden = true
				// 更改为编辑状态
				self.detectionDateLabel.textColor = UIColor(named: "boss_000000-20_FFFFFF-20", in: AAMineModule.share.bundle, compatibleWith: nil)
				self.detectionDateLabel.text = "请选择日期"
				self.detectionOverdueLabel.textColor = UIColor(named: "boss_000000-20_FFFFFF-20", in: AAMineModule.share.bundle, compatibleWith: nil)
				self.detectionOverdueLabel.text = "请选择日期"
				self.inoculateLabel.textColor = UIColor(named: "boss_000000-20_FFFFFF-20", in: AAMineModule.share.bundle, compatibleWith: nil)
				self.inoculateLabel.text = "请选择日期"
				
				self.detectionImageView.image = UIImage(named: "uploadImage", in: AAMineModule.share.bundle, compatibleWith: nil)
				
				self.inoculateImageView.image = UIImage(named: "uploadImage", in: AAMineModule.share.bundle, compatibleWith: nil)
				
				self.detectionTipLabel.text = "请上传您的附件一截图"
				
				self.inoculateTipLabel.text = "请上传您的附件二截图"
				
				
				self.commitButton.setTitle("提交信息", for: .normal)
				
				self.detectionDateObservable.onNext("")
				self.detectionOverdueObservable.onNext("")
				self.inoculateObservable.onNext("")
				self.detectionImageObservable.onNext(nil)
				self.inoculateImageObservable.onNext(nil)
				
				/// 骑手编辑 -> 查看骑手 -> 附加信息
				if let usermodel = self.userInfoModel, let vaccinationId = usermodel.vaccinationId, let model = UserModelManager.manager.userInfoModel, let currentVaccinationId = model.vaccinationId  {
					self.commitButton.isHidden = !(vaccinationId == currentVaccinationId)
				} else {
					self.commitButton.isHidden = false
				}
				
			case .done, .ongoing:
				/// 如果不合格 且 在完成条件下 可重新提交
				if let isOrderTaker = self.userInfoModel?.isOrderTaker, !isOrderTaker, self.upLoadVaccineContentState == .done {
					/// 判断入口是否为 骑手管理
					if self.userInfoModel?.vaccinationId == UserModelManager.manager.userInfoModel?.vaccinationId {
						self.commitButton.isHidden = true
					} else {
						self.commitButton.isHidden = false
						self.commitButton.setTitle("更改信息", for: .normal)
						self.commitButton.backgroundColor = UIColor(named: "Color_00AD66", in: AAMineModule.share.bundle, compatibleWith: nil)
						self.isUpdate = false
					}
					
				} else {
					self.commitButton.isHidden = true
				}
				
				self.errorContentView.isHidden = true
				
				self.detectionTipLabel.text = "附件一截图"
				
				self.inoculateTipLabel.text = "附件二截图"
				
				self.detectionDateLabel.textColor = UIColor(named: "boss_000000-80_FFFFFF-80", in: AAMineModule.share.bundle, compatibleWith: nil)
				self.detectionDateLabel.text = self.vaccineModel?.testingDate
				self.detectionOverdueLabel.textColor = UIColor(named: "boss_000000-80_FFFFFF-80", in: AAMineModule.share.bundle, compatibleWith: nil)
				self.detectionOverdueLabel.text = self.vaccineModel?.testingExpireDate
				self.inoculateLabel.textColor = UIColor(named: "boss_000000-80_FFFFFF-80", in: AAMineModule.share.bundle, compatibleWith: nil)
				self.inoculateLabel.text = self.vaccineModel?.vaccinationDate
				// 图片
				// 图片
				self.detectionImageView.image = UIImage(named: "placehold_Image", in: AAMineModule.share.bundle, compatibleWith: nil)
				if let urlStr = self.vaccineModel?.testingAssetUrl, let url = URL(string: urlStr) {
					self.detectionImageView.kf.setImage(with: url, placeholder: UIImage(named: "placehold_Image", in: AAMineModule.share.bundle, compatibleWith: nil), completionHandler: { res in
						switch res {
						case .success(let result):
							if self.upLoadVaccineContentState == .empty {
								self.detectionImageView.image = UIImage(named: "uploadImage", in: AAMineModule.share.bundle, compatibleWith: nil)
							} else {
								self.detectionImageView.image = result.image
							}
						case .failure(let error):
							print(error)
						}
					})
				}
				self.inoculateImageView.image = UIImage(named: "placehold_Image", in: AAMineModule.share.bundle, compatibleWith: nil)
				if let urlStr = self.vaccineModel?.vaccinationAssetUrl, let url = URL(string: urlStr) {
					self.inoculateImageView.kf.setImage(with: url, placeholder: UIImage(named: "placehold_Image", in: AAMineModule.share.bundle, compatibleWith: nil), completionHandler: { res in
						switch res {
						case .success(let result):
							if self.upLoadVaccineContentState == .empty {
								self.inoculateImageView.image = UIImage(named: "uploadImage", in: AAMineModule.share.bundle, compatibleWith: nil)
							} else {
								self.inoculateImageView.image = result.image
							}
						case .failure(let error):
							print(error)
						}
						
					})
				}
				
				self.detectionDateObservable.onNext("detectionDateObservable")
				self.detectionOverdueObservable.onNext("detectionOverdueObservable")
				self.inoculateObservable.onNext("detectionOverdueObservable")
				self.detectionImageObservable.onNext(UIImage(named: "uploadImage", in: AAMineModule.share.bundle, compatibleWith: nil))
				self.inoculateImageObservable.onNext(UIImage(named: "uploadImage", in: AAMineModule.share.bundle, compatibleWith: nil))
			case .error:
				self.isUpdate = true
				
				
				self.commitButton.setTitle("更改信息", for: .normal)
				self.commitButton.backgroundColor = UIColor(named: "Color_00AD66", in: AAMineModule.share.bundle, compatibleWith: nil)
				
				// 骑手管理 -> 骑手信息 -> 附加信息
				if let usermodel = self.userInfoModel, let vaccinationId = usermodel.vaccinationId, let model = UserModelManager.manager.userInfoModel, let currentVaccinationId = model.vaccinationId  {
					self.commitButton.isHidden = !(vaccinationId == currentVaccinationId)
				} else {
					self.commitButton.isHidden = false
				}
				
				self.errorContentView.isHidden = false
				
				if let isOrderTaker = self.userInfoModel?.isOrderTaker, !isOrderTaker{
					self.errorLabel.text = "错误原因: 信息不合格"
				} else {
					self.errorLabel.text = "错误原因: \(self.vaccineModel?.reason ?? "")"
				}
				
				self.detectionTipLabel.text = "附件一截图"
				
				self.inoculateTipLabel.text = "附件二截图"
				
				self.detectionDateLabel.textColor = UIColor(named: "boss_000000-80_FFFFFF-80", in: AAMineModule.share.bundle, compatibleWith: nil)
				self.detectionDateLabel.text = self.vaccineModel?.testingDate
				
				self.detectionOverdueLabel.textColor = UIColor(named: "boss_000000-80_FFFFFF-80", in: AAMineModule.share.bundle, compatibleWith: nil)
				self.detectionOverdueLabel.text = self.vaccineModel?.testingExpireDate
				
				self.inoculateLabel.textColor = UIColor(named: "boss_000000-80_FFFFFF-80", in: AAMineModule.share.bundle, compatibleWith: nil)
				self.inoculateLabel.text = self.vaccineModel?.vaccinationDate
				
				// 图片
				self.detectionImageView.image = UIImage(named: "placehold_Image", in: AAMineModule.share.bundle, compatibleWith: nil)
				if let urlStr = self.vaccineModel?.testingAssetUrl, let url = URL(string: urlStr) {
					self.detectionImageView.kf.setImage(with: url, placeholder: UIImage(named: "placehold_Image", in: AAMineModule.share.bundle, compatibleWith: nil), completionHandler: { res in
						switch res {
						case .success(let result):
							if self.upLoadVaccineContentState == .empty {
								self.detectionImageView.image = UIImage(named: "uploadImage", in: AAMineModule.share.bundle, compatibleWith: nil)
							} else {
								self.detectionImageView.image = result.image
							}
						case .failure(let error):
							print(error)
						}
					})
				}
				// 图片
				self.inoculateImageView.image = UIImage(named: "placehold_Image", in: AAMineModule.share.bundle, compatibleWith: nil)
				if let urlStr = self.vaccineModel?.vaccinationAssetUrl, let url = URL(string: urlStr) {
					self.inoculateImageView.kf.setImage(with: url, placeholder: UIImage(named: "placehold_Image", in: AAMineModule.share.bundle, compatibleWith: nil), completionHandler: { res in
						switch res {
						case .success(let result):
							if self.upLoadVaccineContentState == .empty {
								self.inoculateImageView.image = UIImage(named: "uploadImage", in: AAMineModule.share.bundle, compatibleWith: nil)
							} else {
								self.inoculateImageView.image = result.image
							}
						case .failure(let error):
							print(error)
						}
						
					})
				}
				self.detectionDateObservable.onNext("detectionDateObservable")
				self.detectionOverdueObservable.onNext("detectionOverdueObservable")
				self.inoculateObservable.onNext("detectionOverdueObservable")
				self.detectionImageObservable.onNext(UIImage(named: "uploadImage", in: AAMineModule.share.bundle, compatibleWith: nil))
				self.inoculateImageObservable.onNext(UIImage(named: "uploadImage", in: AAMineModule.share.bundle, compatibleWith: nil))
			}
		}).disposed(by: self.disposeBag)
		
		self.detectionDateTap.rx.event.filter{_ in self.upLoadVaccineContentState == .empty}.subscribe(onNext: { _ in
			self.setDatePicker(type: .detection)
		}).disposed(by: disposeBag)
		
		self.detectionOverdueTap.rx.event.filter{_ in self.upLoadVaccineContentState == .empty}.subscribe(onNext: { _ in
			self.setDatePicker(type: .detectionpastDue)
		}).disposed(by: disposeBag)
		
		self.inoculateTap.rx.event.filter{_ in self.upLoadVaccineContentState == .empty}.subscribe(onNext: { _ in
			self.setDatePicker(type: .inoculate)
		}).disposed(by: disposeBag)
		
		let paraObservable = Observable.combineLatest(
			self.vaccineContentStateobservable,
			self.detectionDateObservable,
			self.detectionOverdueObservable,
			self.inoculateObservable,
			self.detectionImageObservable,
			self.inoculateImageObservable)
		
		/// 提交按钮是否可以点击
		/// 其余状态都可直接点击
		/// 只要有一个时间已经选择就可点击
		let commitIsEnableObservable = Observable
			.combineLatest(
				self.detectionDateObservable,
				self.detectionOverdueObservable,
				self.inoculateObservable)
			.map{!$0.isEmpty || !$1.isEmpty || !$2.isEmpty}
		
		commitIsEnableObservable.bind(to: self.commitButton.rx.isEnabled).disposed(by: disposeBag)
		commitIsEnableObservable.map{$0 ? UIColor(named: "Color_00AD66", in: AAMineModule.share.bundle, compatibleWith: nil) : UIColor(named: "color_CECECE", in: AAMineModule.share.bundle, compatibleWith: nil)}.bind(to: self.commitButton.rx.backgroundColor).disposed(by: disposeBag)
		/// 附件一点击
		self.detectionImageButton.rx.tap.subscribe(onNext: {
			
			if self.upLoadVaccineContentState == .empty {
				self.selectTag = 0
				normalCameraModule.manager.openCameraFromAlert()
			} else {
				/// 查看大图
				if let urlstr = self.vaccineModel?.testingAssetUrl, let url = URL(string: urlstr) {
					let browser = JXPhotoBrowser()
					browser.numberOfItems = {
						1
					}
					browser.reloadCellAtIndex = { context in
						let browserCell = context.cell as? JXPhotoBrowserImageCell
						browserCell?.imageView.kf.setImage(with: url, placeholder: nil, options: [], completionHandler: { _ in
							browserCell?.setNeedsLayout()
						})
					}
					browser.show()
				} else {
					self.navigationController?.view.showfailMessage(message: "暂不支持预览", handle: nil)
				}
			}
		}).disposed(by: disposeBag)
		
		/// 附件二点击
		self.inoculateImageButton.rx.tap.subscribe(onNext: {
			if self.upLoadVaccineContentState == .empty {
				self.selectTag = 1
				normalCameraModule.manager.openCameraFromAlert()
			} else {
				/// 查看大图
				if let urlstr = self.vaccineModel?.vaccinationAssetUrl, let url = URL(string: urlstr) {
					let browser = JXPhotoBrowser()
					browser.numberOfItems = {
						1
					}
					browser.reloadCellAtIndex = { context in
						let browserCell = context.cell as? JXPhotoBrowserImageCell
						browserCell?.imageView.kf.setImage(with: url, placeholder: nil, options: [], completionHandler: { _ in
							browserCell?.setNeedsLayout()
						})
					}
					browser.show()
				} else {
					self.navigationController?.view.showfailMessage(message: "暂不支持预览", handle: nil)
				}
			}
		}).disposed(by: disposeBag)
		
		/// 选择图片回调
		normalCameraModule.manager.imageObservable.subscribe(onNext: { image in
			if self.selectTag == 0 {
				self.detectionImageView.image = image
				self.detectionImageObservable.onNext(image)
			} else {
				self.inoculateImageView.image = image
				self.inoculateImageObservable.onNext(image)
			}
		}).disposed(by: disposeBag)
		
		
		let commitParaObservable = paraObservable.map{(detectionDate: $1, detectionOverdue: $2, inoculate: $3, detectionImage: $4, inoculateImage: $5, courierId: UserModelManager.manager.userInfoModel?.accountInfo.id ?? "", isUpdate: self.isUpdate, vaccinationId: UserModelManager.manager.userInfoModel?.vaccinationId)}
		
		/// 每次操作都会更新提交数据
		commitParaObservable.subscribe(onNext: { [unowned self] para in
			self.para = para
		}).disposed(by: disposeBag)
		
		/// 发起提交数据
		self.commitButton.rx.tap.subscribe(onNext: { _ in
			if self.upLoadVaccineContentState == .error {
				self.vaccineContentStateobservable.onNext(.empty)
			} else if self.upLoadVaccineContentState == .done {
				// 已完善 不合格
				self.vaccineContentStateobservable.onNext(.empty)
			} else if self.upLoadVaccineContentState == .empty{
				if let para = self.para {
					let date = Date()
					let formatter = DateFormatter()
					formatter.locale = Locale.init(identifier: "zh_CN")
					formatter.dateFormat = "yyyyMMdd"
					let date_int = Int(formatter.string(from: date)) ?? 0
					
					
					if let detectionOverdue = para.detectionOverdue, let detectionDate = para.detectionDate{
						let detectionOverdue_int = Int(detectionOverdue.replacingOccurrences(of: "-", with: "")) ?? 0
						let detectionDate_int = Int(detectionDate.replacingOccurrences(of: "-", with: "")) ?? 0
						print(detectionOverdue_int)
						print(detectionDate_int)
						print(date_int)
						//						if detectionOverdue_int == detectionDate_int {
						//							self.navigationController?.view.showfailMessage(message: "附件一过期日期不能等于附件一日期", handle: nil)
						//							return
						//						}
						
						if detectionOverdue_int < detectionDate_int {
							self.navigationController?.view.showfailMessage(message: "附件一过期日期不能早于附件一生效日期", handle: nil)
							return
						}
						
						if detectionOverdue_int < date_int {
							self.navigationController?.view.showfailMessage(message: "附件一过期日期不能早于当前日期", handle: nil)
							return
						}
					}
					if let inoculate = para.inoculate {
						
						let inoculate_int = Int(inoculate.replacingOccurrences(of: "-", with: "")) ?? 0
						
						if inoculate_int > date_int {
							self.navigationController?.view.showfailMessage(message: "附件二日期不能晚于当前日期", handle: nil)
							return
						}
					}
					
					self.navigationController?.view.showLoadingMessage(message: "上传中...")
					self.commitObservable.onNext(para)
				}
			}
		}).disposed(by: disposeBag)
		
		let input = UpLoadVaccineContentViewModel.Input.init(commitObservable: self.commitObservable, getUpLoadVaccineContent: self.getVaccineContentObservable)
		
		self.upLoadVaccineContentViewModel = UpLoadVaccineContentViewModel(input: input)
		
		/// 获取骑士当前附件信息
		self.upLoadVaccineContentViewModel?.outPutUpLoadVaccineContentObservable.subscribe(onNext: { [unowned self] model in
			self.navigationController?.view.dissmissLoadingView()
			self.vaccineModel = model
			
			if let isOrderTaker = self.userInfoModel?.isOrderTaker, !isOrderTaker{
				self.vaccineContentStateobservable.onNext(.error)
			} else {
				guard let vaccinationState = model.vaccinationState else {
					return
				}
				self.vaccineContentStateobservable.onNext(vaccinationState)
			}
			
		}).disposed(by: disposeBag)
		
		/// 获取保存信息结果
		self.upLoadVaccineContentViewModel?.outPutResultObservable.subscribe(onNext: { [unowned self] res in
			print(res)
			self.navigationController?.view.dissmissLoadingView()
			if let _ = res["_id"].string {
				self.navigationController?.popViewController(animated: true)
			} else {
				self.view.showfailMessage(message: "上传失败,请稍后再试", handle: nil)
			}
		}).disposed(by: disposeBag)
		
		self.upLoadVaccineContentViewModel?.outPutErrorObservable.subscribe(onNext: { error in
			self.navigationController?.view.dissmissLoadingView()
			self.view.showfailMessage(message: error.zhMessage, handle: nil)
		}).disposed(by: disposeBag)
	}
}
